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
    * Debugging disabled
    */
    const DEBUG_NONE = 0;

   /**
    * Store debug data, so it can be displayed using getWire()
    */
    const DEBUG_STORE = 1;

   /**
    * Display debug data
    */
    const DEBUG_PRINT = 2;

   /**
    * Sandbox gateway URL
    */
    const URL_SANDBOX = 'https://api.sandbox.ebay.com/ws/api.dll';

   /**
    * Production gateway URL
    */
    const URL_PRODUCTION = 'https://api.ebay.com/ws/api.dll';

   /**o
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
    * transport driver
    *
    * @var  object Services_Ebay_Transport
    */
    private $transport;
    
   /**
    * URL to use
    *
    * By default, the sandbox URL is used.
    *
    * @var  string
    */
    private $url;

   /**
    * site id
    *
    * @var  integer
    */
    private $siteId = 0;

   /**
    * Session options
    *
    * @var  array
    */
    private $opts;

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
    public $wire = null;
    
   /**
    * compatibility level
    *
    * @var       integer
    */
    public $compatLevel = 405;

   /**
    * detail level
    *
    * @var  string
    */
    public $detailLevel;

   /**
    * general warning Level
    *
    * @var  int
    */
    private $warningLevel = 'High';

   /**
    * error language
    *
    * @var  int
    */
    private $errorLanguage = 'en_US';

   /**
    * additional options for the serializer
    *
    * These options will be set by the call objects
    *
    * @var  array
    */
    private $serializerOptions = array();

   /**
    * additional options for the unserializer
    *
    * These options will be set by the call objects
    *
    * @var  array
    */
    private $unserializerOptions = array();

   /**
    * errors returned by the webservice
    *
    * @var array
    */
    private $errors = array();
    
   /**
    * create the session object
    *
    * @param    string  developer id
    * @param    string  application id
    * @param    string  certificate id
    * @param    string  external encoding, as eBay uses UTF-8, the session will encode and decode to
    *                   the specified encoding. Possible values are ISO-8859-1 and UTF-8
    */
    public function __construct($devId, $appId, $certId, $encoding = 'ISO-8859-1')
    {
        $this->devId = $devId;
        $this->appId = $appId;
        $this->certId = $certId;
        $this->url = self::URL_SANDBOX;
        
        $this->opts = array(
                                'indent'             => '  ',
                                'linebreak'          => "\n",
                                'typeHints'          => false,
                                'addDecl'            => true,
                                'encoding'           => 'UTF-8',
                                'scalarAsAttributes' => false
                           );
        // UTF-8 encode the document, if the user does not already
        // use UTF-8 encoding
        if ($encoding !== 'UTF-8') {
        	$opts['encodeFunction'] = 'utf8_encode';
        }

        $opts = array(
                    'forceEnum'      => array('Error'),
                    'encoding'       => 'UTF-8',
                    'targetEncoding' => $encoding,
                    );
        $this->us  = new XML_Unserializer($opts);
    }
 
   /**
    * set the debug mode
    *
    * Possible values are:
    * - Services_Ebay_Session::DEBUG_NONE
    * - Services_Ebay_Session::DEBUG_STORE
    * - Services_Ebay_Session::DEBUG_PRINT
    *
    * @param    integer
    * @see      getWire()
    */
    public function setDebug($debug)
    {
        $this->debug = $debug;
    }

   /**
    * get the XML code that was sent accross the network
    *
    * To use this, debug mode must be set to DEBUG_STORE or DEBUG_PRINT
    *
    * @return   string      xml wire
    */
    public function getWire()
    {
        return $this->wire;
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
    *
    * Possible values are:
    * - Services_Ebay_Session::URL_SANDBOX
    * - Services_Ebay_Session::URL_PRODUCTION
    * - Other URLs as applicable
    *
    */
    public function setUrl($url)
    {
       $this->url = $url;
    }

   /**
    * set the site id
    *
    * @param    integer
    */
    public function setSiteId($siteId)
    {
       $this->siteId = $siteId;
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
    * set the error language
    *
    * @param    string
    */
    public function setErrorLanguage($language)
    {
       $this->errorLanguage = $language;
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
        $this->opts['rootName'] = $verb.'Request';
        $this->opts['rootAttributes'] = array( 'xmlns' => 'urn:ebay:apis:eBLBaseComponents' );
        $this->ser = new XML_Serializer($this->opts);

        $request = array(
                            'ErrorLanguage'     => $this->errorLanguage,
                            'Version'           => $this->compatLevel,
                            'WarningLevel'      => $this->warningLevel
                        );
        if (!is_null($this->detailLevel)) {
            $request['DetailLevel'] = $this->detailLevel;
        }

        switch ($authType) {
            case Services_Ebay::AUTH_TYPE_TOKEN:
                if (empty($this->token)) {
                    throw new Services_Ebay_Auth_Exception('No authentication token set.');
                }
                $request['RequesterCredentials']['eBayAuthToken'] = $this->token;
                break;
            case Services_Ebay::AUTH_TYPE_USER:
                if (empty($this->requestUserId) || empty($this->requestPassword)) {
                    throw new Services_Ebay_Auth_Exception('No authentication data (username and password) set.');
                }
                $request['RequesterCredentials']['Username']   = $this->requestUserId;
                $request['RequesterCredentials']['Password']   = $this->requestPassword;
                break;
            case Services_Ebay::AUTH_TYPE_NONE:
                if (empty($this->requestUserId)) {
                    throw new Services_Ebay_Auth_Exception('No username has been set.');
                }
                $request['RequesterCredentials']['Username']   = $this->requestUserId;
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
    * @param    integer     authentication type
    * @param    boolean     flag to indicate, whether XML should be parsed or returned raw
    * @return   array       response
    * @todo     add real error handling
    */
    public function sendRequest( $verb, $params = array(), $authType = Services_Ebay::AUTH_TYPE_TOKEN, $parseResult = true )
    {
        $this->wire = '';

        if (!isset($params['ErrorLanguage']) && !is_null($this->errorLanguage)) {
            $params['ErrorLanguage'] = $this->errorLanguage;
        }

        if (!isset($params['WarningLevel']) && !is_null($this->warningLevel)) {
            $params['WarningLevel'] = $this->warningLevel;
        }

        $body    = $this->buildRequestBody($verb, $params, $authType);
        
        $headers = array(
                            'X-EBAY-API-SESSION-CERTIFICATE' => sprintf( '%s;%s;%s', $this->devId, $this->appId, $this->certId ),      // Required. Used to authenticate the function call. Use this format, where DevId is the same as the value of the X-EBAY-API-DEV-NAME header, AppId is the same as the value of the X-EBAY-API-APP-NAME header, and CertId  is the same as the value of the X-EBAY-API-CERT-NAME header: DevId;AppId;CertId
                            'X-EBAY-API-COMPATIBILITY-LEVEL' => $this->compatLevel,                                                 // Required. Regulates versioning of the XML interface for the API.
                            'X-EBAY-API-DEV-NAME'            => $this->devId,                                                       // Required. Developer ID, as registered with the Developer's Program. This value should match the first value (DevId) in the X-EBAY-API-SESSION-CERTIFICATE header. Used to authenticate the function call.
                            'X-EBAY-API-APP-NAME'            => $this->appId,                                                       // Required. Application ID, as registered with the Developer's Program. This value should match the second value (AppId) in the X-EBAY-API-SESSION-CERTIFICATE header. Used to authenticate the function call.
                            'X-EBAY-API-CERT-NAME'           => $this->certId,                                                      // Required. Certificate ID, as registered with the Developer's Program. This value should match the third value (CertId) in the X-EBAY-API-SESSION-CERTIFICATE header. Used to authenticate the function call.
                            'X-EBAY-API-CALL-NAME'           => $verb,                                                              // Required. Name of the function being called, for example: 'GetItem' (without the quotation marks). This must match the information passed in the Verb input argument for each function.
                            'X-EBAY-API-SITEID'              => $this->siteId,                                                      // Required. eBay site an item is listed on or that a user is registered on, depending on the purpose of the function call. This must match the information passed in the SiteId input argument for all functions.
                            'Content-Type'                   => 'text/xml',                                                         // Required. Specifies the kind of data being transmitted. The value must be 'text/xml'. Sending any other value (e.g., 'application/x-www-form-urlencoded') may cause the call to fail.
                            'Content-Length'                 => strlen( $body )                                                     // Recommended. Specifies the size of the data (i.e., the length of the XML string) you are sending. This is used by eBay to determine how much data to read from the stream.
                        );

        $file  = SERVICES_EBAY_BASEDIR.'/Ebay/Transport/'.$this->transportDriver.'.php';
        $class = 'Services_Ebay_Transport_'.$this->transportDriver;

        @include_once $file;
        if (!class_exists($class)) {
            throw new Services_Ebay_Transport_Exception('Could not load selected transport driver.');            
        }
        $tp = new $class();
        
        if ($this->debug > 0) {
            $this->wire .= "Sending request:\n";
            $this->wire .= $body."\n\n";
        }

        $response = $tp->sendRequest($this->url, $body, $headers);

        if (PEAR::isError($response)) {
            return $response;
        }
        
        if ($this->debug > 0) {
            $this->wire .= "Received response:\n";
            $this->wire .= $response."\n\n";
        }

        if ($this->debug > 1) {
            echo $this->wire . "\n";
        }
        
        if ($parseResult === false) {
            return $response;
        }

        $this->us->unserialize( $response, false, $this->unserializerOptions );
        $result = $this->us->getUnserializedData();

        $errors = array();
        
        if (isset($result['Ack']) && $result['Ack'] == 'Failure') {
            if (isset($result['Errors'])) {
                if (isset($result['Errors'][0])) {
                    foreach ($result['Errors'] as $error) {
                        $tmp = new Services_Ebay_Error($error);

                        // last errors
                        array_push($errors, $tmp);

                        // all errors
                        array_push($this->errors, $tmp);
                    }
                } else {
                    $error = array();
                    foreach ($result['Errors'] as $key=>$value) {
                        $error[$key] = $value;
                    }
                    $tmp = new Services_Ebay_Error($error);

                    array_push($errors, $tmp);
                    array_push($this->errors, $tmp);
                }

                // check for serious errors
                $message = '';
                $severe  = array();
                foreach ($errors as $error) {
                	if ($error->getSeverityCode() == 'Warning') {
                		continue;
                	}
                	$message .= $error->getLongMessage();
                	$message .= "\n";
                	array_push($severe, $error);
                }
                if (!empty($severe)) {
                	throw new Services_Ebay_API_Exception($message, $severe);
                }
            } else {
                throw new Services_Ebay_API_Exception('Unknown error occured.');
            }
        }
        return $result;
    }

   /**
    * get the errors and warnings that happened during the
    * last API calls
    *
    * @param  boolean   whether to clear the internal error list
    * @return array
    */
    public function getErrors($clear = true)
    {
        $errors = $this->errors;
        if ($clear === true) {
        	$this->errors = array();
        }
        return $errors;
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

   /**
    * set additional options for the unserializer
    *
    * @param    array
    */
    public function setUnserializerOptions($opts = array())
    {
        $this->unserializerOptions = $opts;
    }

   /**
    * set compatibility level if particular request needs
    * another version of API instead of default one
    *
    * @param    int
    */
    public function setCompatLevel($compatLevel)
    {
        $this->compatLevel = $compatLevel;
    }
}
?>
