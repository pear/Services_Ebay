<?PHP
/* vim: set expandtab tabstop=4 shiftwidth=4: */
// +----------------------------------------------------------------------+
// | PHP Version 4                                                        |
// +----------------------------------------------------------------------+
// | Copyright (c) 1997-2002 The PHP Group                                |
// +----------------------------------------------------------------------+
// | This source file is subject to version 2.0 of the PHP license,       |
// | that is bundled with this package in the file LICENSE, and is        |
// | available at through the world-wide-web at                           |
// | http://www.php.net/license/2_02.txt.                                 |
// | If you did not receive a copy of the PHP license and are unable to   |
// | obtain it through the world-wide-web, please send a note to          |
// | license@php.net so we can mail you a copy immediately.               |
// +----------------------------------------------------------------------+
// | Authors: Stephan Schmidt <schst@php.net>                             |
// +----------------------------------------------------------------------+
//
// $Id$

/**
 * Services/Ebay/Session.php
 *
 * manages IDs, authentication, serialization, etc.
 *
 * @package  Services_Ebay
 * @author   Stephan Schmidt <schst@php.net>
 */
class Services_Ebay_Session
{
   /**
    * developer ID
    *
    * If you do not already have one, please
    * apply for a developer ID at http://developer.ebay.com
    *
    * @var string
    */
    private $devId;
    
   /**
    * application id
    *
    * @var string
    */
    private $appId;

   /**
    * application id
    *
    * @var certificate ID
    */
    private $certId;
    
   /**
    * Auth & Auth token
    *
    * @var string
    */
    private $token;

   /**
    * auth username
    *
    * @var string
    */
    private $requestUserId;

   /**
    * auth password
    *
    * @var string
    */
    private $requestPassword;

    /**
    * name of the transport driver to use
    *
    * @var string
    */
    private $transportDriver = 'Curl';

   /**
    * transpor driver
    *
    * @var  object Services_Ebay_Transport
    */
    private $transport;
    
   /**
    * URL to use
    *
    * @var  string
    */
    private $url = 'https://api.sandbox.ebay.com/ws/api.dll';

   /**
    * XML_Serializer object
    *
    * @var object XML_Serializer
    */
    private $ser;

   /**
    * XML_Unserializer object
    *
    * @var object XML_Unserializer
    */
    private $us;
    
   /**
    * debug flag
    *
    * @var boolean
    */
    public $debug = 1;
    
   /**
    * XML wire
    *
    * @var string
    */
    public $wire;
    
   /**
    * compatibility level
    *
    * @var       integer
    */
    public $compatLevel = 379;

   /**
    * general detail Level
    *
    * @var  int
    */
    private $detailLevel = 0;

   /**
    * additional options for the serializer
    *
    * These options will be set by the call objects
    *
    * @var  array
    */
    private $serializerOptions = array();
    
   /**
    * create the session object
    *
    * @param    string  developer id
    * @param    string  application id
    * @param    string  certificate id
    */
	public function __construct($devId, $appId, $certId)
	{
        $this->devId = $devId;
        $this->appId = $appId;
        $this->certId = $certId;

        $opts = array(
                         'indent'             => '  ',
                         'linebreak'          => "\n",
                         'typeHints'          => false,
                         'addDecl'            => true,
						 'scalarAsAttributes' => false,
                         'rootName'           => 'request',
                         'rootAttributes'     => array( 'xmlns' => 'urn:eBayAPIschema' ),
                    );
        $this->ser = new XML_Serializer( $opts );

        $opts = array(
                    'forceEnum' => array('Error')
                    );
        $this->us  = new XML_Unserializer( $opts );
	}
	
   /**
    * set the authentication token
    *
    * @param    string
    */
	public function setToken($token)
	{
	    $this->token = $token;
	}
	
   /**
    * set the authentication username and password
    *
    * @param    string
    */
	public function setAuthenticationData($username, $password = null)
	{
	    $this->requestUserId   = $username;
	    $this->requestPassword = $password;
	}

	/**
    * set the API URL
    *
    * @param    string
    */
	public function setUrl()
	{
	   $this->url = $url;
	}

   /**
    * set the detail level
    *
    * @param    integer
    */
    public function setDetailLevel($level)
    {
        $this->detailLevel = $level;
    }
	
   /**
    * build XML code for a request
    *
    * @access   private
    * @param    string      verb of the request
    * @param    array|null  parameters of the request
    * @return   string      XML request
    */
    public function buildRequestBody( $verb, $params = array(), $authType = Services_Ebay::AUTH_TYPE_TOKEN )
    {
        $request = array(
                            'DetailLevel'     => $this->detailLevel,
                            'ErrorLevel'      => 1,
                            'SiteId'          => 0,
                            'Verb'            => $verb
                        );
        switch ($authType) {
            case Services_Ebay::AUTH_TYPE_TOKEN:
                if (empty($this->token)) {
                    throw new Services_Ebay_Auth_Exception('No authentication token set.');
                }
                $request['RequestToken'] = $this->token;
                break;
            case Services_Ebay::AUTH_TYPE_USER:
                if (empty($this->requestUserId) || empty($this->requestPassword)) {
                    throw new Services_Ebay_Auth_Exception('No authentication data (username and password) set.');
                }
                $request['RequestUserId']   = $this->requestUserId;
                $request['RequestPassword'] = $this->requestPassword;
                break;
            case Services_Ebay::AUTH_TYPE_NONE:
                if (empty($this->requestUserId)) {
                    throw new Services_Ebay_Auth_Exception('No username has been set.');
                }
                $request['RequestUserId']   = $this->requestUserId;
                break;
        }

        $request = array_merge($request, $params);

        $this->ser->serialize($request, $this->serializerOptions);
        
        return $this->ser->getSerializedData();
    }

   /**
    * send a request
    *
    * This method is used by the API methods. You
    * may call it directly to access any eBay function that
    * is not yet implemented.
    *
    * @access   public
    * @param    string      function to call
    * @param    array       associative array containing all parameters for the function call
    * @return   array       response
    * @todo     add real error handling
    */
    public function sendRequest( $verb, $params = array(), $authType = Services_Ebay::AUTH_TYPE_TOKEN )
    {
        $this->wire = '';

        $body    = $this->buildRequestBody($verb, $params, $authType);

        if (!isset($params['DetailLevel'])) {
            $params['DetailLevel'] = $this->detailLevel;
        }
        
        $headers = array(
                            'X-EBAY-API-SESSION-CERTIFICATE' => sprintf( '%s;%s;%s', $this->devId, $this->appId, $this->certId ),  	// Required. Used to authenticate the function call. Use this format, where DevId is the same as the value of the X-EBAY-API-DEV-NAME header, AppId is the same as the value of the X-EBAY-API-APP-NAME header, and CertId  is the same as the value of the X-EBAY-API-CERT-NAME header: DevId;AppId;CertId
                            'X-EBAY-API-COMPATIBILITY-LEVEL' => $this->compatLevel, 	                                            // Required. Regulates versioning of the XML interface for the API.
                            'X-EBAY-API-DEV-NAME'            => $this->devId,                                                       // Required. Developer ID, as registered with the Developer's Program. This value should match the first value (DevId) in the X-EBAY-API-SESSION-CERTIFICATE header. Used to authenticate the function call.
                            'X-EBAY-API-APP-NAME'            => $this->appId,                                                       // Required. Application ID, as registered with the Developer's Program. This value should match the second value (AppId) in the X-EBAY-API-SESSION-CERTIFICATE header. Used to authenticate the function call.
                            'X-EBAY-API-CERT-NAME'           => $this->certId,                                                      // Required. Certificate ID, as registered with the Developer's Program. This value should match the third value (CertId) in the X-EBAY-API-SESSION-CERTIFICATE header. Used to authenticate the function call.
                            'X-EBAY-API-CALL-NAME'           => $verb,                                                              // Required. Name of the function being called, for example: 'GetItem' (without the quotation marks). This must match the information passed in the Verb input argument for each function.
                            'X-EBAY-API-SITEID'              => 0,                                                                  // Required. eBay site an item is listed on or that a user is registered on, depending on the purpose of the function call. This must match the information passed in the SiteId input argument for all functions.
                            'X-EBAY-API-DETAIL-LEVEL'        => $params['DetailLevel'],                                             // Required. Controls amount or level of data returned by the function call. May be zero if the function does not support varying detail levels. This must match the information passed in the DetailLevel input argument for each function.
                            'Content-Type'                   => 'text/xml',                                                         // Required. Specifies the kind of data being transmitted. The value must be 'text/xml'. Sending any other value (e.g., 'application/x-www-form-urlencoded') may cause the call to fail.
                            'Content-Length'                 => strlen( $body )                                                     // Recommended. Specifies the size of the data (i.e., the length of the XML string) you are sending. This is used by eBay to determine how much data to read from the stream.
                        );

        $file  = SERVICES_EBAY_BASEDIR.'/Ebay/Transport/'.$this->transportDriver.'.php';
        $class = 'Services_Ebay_Transport_'.$this->transportDriver;

        include_once $file;
        $tp = new $class;
        
        if ($this->debug > 0) {
            $this->wire .= $body."\n\n";
        }

        $response = $tp->sendRequest($this->url, $body, $headers);

        if (PEAR::isError($response)) {
            return $response;
        }
        
        if ($this->debug > 0) {
            $this->wire .= $response."\n\n";
        }

        $this->us->unserialize( $response );
        
        $result = $this->us->getUnserializedData();

        if ($this->debug > 1) {
            echo $this->wire;
        }
        
        if (isset($result['Errors'])) {
            if (isset($result['Errors']['Error'])) {
                $message = '';
                foreach ($result['Errors']['Error'] as $error) {
                	$message = $message . ' ' . $error['LongMessage'];
                }
                throw new Services_Ebay_Exception( $message );
            } else {
                throw new Services_Ebay_API_Exception('Unknown error occured.');
            }
            
        }

        return $result;
    }
    
   /**
    * set additional options for the serializer
    *
    * @param    array
    */
    public function setSerializerOptions($opts = array())
    {
        $this->serializerOptions = $opts;
    }
}
?>