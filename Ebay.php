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
 * Services/Ebay.php
 *
 * package to access the eBay API
 *
 * @package  Services_Ebay
 * @author   Stephan Schmidt <schst@php.net>
 */

/**
 * uses PEAR_Exception
 */
require_once 'PEAR/Exception.php';
 
/**
 * directory where Services_Ebay is installed
 */
define('SERVICES_EBAY_BASEDIR', dirname(__FILE__));
 
/**
 * Services_Ebay exception classes
 */
require_once SERVICES_EBAY_BASEDIR . '/Ebay/Exception.php';

/**
 * API Call base class
 */
require_once SERVICES_EBAY_BASEDIR . '/Ebay/Call.php';

/**
 * Session
 */
require_once SERVICES_EBAY_BASEDIR . '/Ebay/Session.php';

/**
 * Model base class
 */
require_once SERVICES_EBAY_BASEDIR . '/Ebay/Model.php';

/**
 * uses XML_Serializer to build the request XML
 */
 require_once 'XML/Serializer.php';
 
/**
 * uses XML_Unserializer to parse the response XML
 */
 require_once 'XML/Unserializer.php';
  
/**
 * Services/Ebay.php
 *
 * package to access the eBay API
 *
 * @package  Services_Ebay
 * @author   Stephan Schmidt <schst@php.net>
 * @link     http://developer.ebay.com/DevProgram/developer/api.asp
 */
class Services_Ebay
{
   /**
    * no authentication, this is only needed when using FetchToken
    */
    const AUTH_TYPE_NONE = 0;

    /**
    * token based authentication
    */
    const AUTH_TYPE_TOKEN = 1;
    
   /**
    * authentication based on user id and password
    */
    const AUTH_TYPE_USER  = 2;
    
   /**
    * return only feedback summary
    */
    const FEEDBACK_BRIEF   = 0;

   /**
    * return verbose feedback
    */
    const FEEDBACK_VERBOSE = 1;

   /**
    * GetItemTransactions():
    * Detail level 2 focuses on checkout detail (and status) data.
    */
    const TRANSACTION_DETAIL_CHECKOUT = 2;

   /**
    * GetItemTransactions():
    * Detail level 4 focuses on retrieving user data for the buyer.
    */
    const TRANSACTION_DETAIL_BUYER = 4;
    
   /**
    * GetItemTransactions():
    * Detail level 8 focuses on the return of payment terms data.
    */
    const TRANSACTION_DETAIL_PAYMENTTERMS = 8;
    
   /**
    * GetItemTransactions():
    * Detail level 16 retrieves the user data for the seller.
    */
    const TRANSACTION_DETAIL_SELLER = 16;

   /**
    * GetItemTransactions():
    * Detail level 32 retrieves checkout status and general auction data (like Title and QuantitySold).
    */
    const TRANSACTION_DETAIL_PAYMENT_AUCTIONDATA = 32;

   /**
    * GetItemTransactions():
    * Detail level 64 focuses on retrieving end-of-auction data.
    */
    const TRANSACTION_DETAIL_PAYMENT_ENDOFACTION = 64;

   /**
    * GetUserDisputes():
    * 1 = See all disputes that involve me as seller or buyer.
    */
    const USER_DISPUTES_ALL = 1;

   /**
    * GetUserDisputes():
    * 2 = See all disputes that are awaiting my response.
    */
    const USER_DISPUTES_MY_RESPONSE = 2;

   /**
    * GetUserDisputes():
    * 3 = See all disputes that are awaiting the other party's response.
    */
    const USER_DISPUTES_OTHER_RESPONSE = 3;

   /**
    * GetUserDisputes():
    * 4 = See all closed disputes that involve me.
    */
    const USER_DISPUTES_CLOSED = 4;

   /**
    * AddDisputeResponse():
    * 11 = Seller wants to add information or respond to an email from the buyer.
    */
    const DISPUTE_RESPONSE_MESSAGE = 11;

   /**
    * AddDisputeResponse():
    * 13 = Seller has completed the transaction or otherwise does not need to pursue the dispute any longer.
    */
    const DISPUTE_RESPONSE_COMPLETED = 13;

   /**
    * AddDisputeResponse():
    * 14 = Seller has made an agreement with the buyer and requires a credit for FVF fees.
    */
    const DISPUTE_RESPONSE_AGREEMENT = 14;

   /**
    * AddDisputeResponse():
    * 15 = Seller wants to end communication or stop waiting for the buyer.
    */
    const DISPUTE_RESPONSE_AGREEMENT = 15;

   /**
    * SellerReverseDispute():
    * 7 = Came to agreement with buyer.
    */
    const DISPUTE_REVERSE_AGREEMENT = 7;

   /**
    * SellerReverseDispute():
    * 9 = Buyer reimbursed auction fees.
    */
    const DISPUTE_REVERSE_REIMBURSED = 9;

   /**
    * SellerReverseDispute():
    * 10 = Received payment.
    */
    const DISPUTE_REVERSE_RECEIVED = 10;

   /**
    * SellerReverseDispute():
    * 11 = Other.
    */
    const DISPUTE_REVERSE_OTHER = 11;

   /**
    * GetAccount():
    * 0 = view by period or date/range
    */
    const ACCOUNT_TYPE_PERIOD = 0;

   /**
    * GetAccount():
    * 1 = view by invoice
    */
    const ACCOUNT_TYPE_INVOICE = 1;
    
   /**
    * session used for the calls
    *
    * @var  object Services_Ebay_Session
    */
    private $session = null;

   /**
    * class maps for the model classes
    *
    * @var  array
    */
    static private $modelClasses = array();

   /**
    * create Services Ebay helper class
    *
    * @param    object Services_Ebay_Session
    */
    public function __construct(Services_Ebay_Session $session)
    {
        $this->session = $session;
    }
    
   /**
    * Factory method to create a new session
    *
    * @param    string      developer id
    * @param    string      application id
    * @param    string      certificate id
    * @return   object Services_Ebay_Session
    */
    public static function getSession($devId, $appId, $certId)
    {
        $session = new Services_Ebay_Session($devId, $appId, $certId);

        return $session;
    }

   /**
    * change the class that is used for a certain model
    *
    * @param    string      model name
    * @param    string      class name
    */
    public static function useModelClass($model, $class)
    {
        self::$modelClasses[$model] = $class;
    }

   /**
    * make an API call
    *
    * @param    string  method to call
    * @param    array   arguments of the call
    */
    public function __call($method, $args)
    {
        try {
            $call = self::loadAPICall($method, $args);
        } catch (Exception $e) {
            throw $e;
        }

        return $call->call($this->session);
    }

   /**
    * set the detail level for all subsequent calls
    *
    * @param    integer
    */
    public function setDetailLevel($level)
    {
        return $this->session->setDetailLevel($level);
    }

   /**
    * load a method call
    *
    * @param    string  name of the method
    * @param    array   arguments
    */
    public static function loadAPICall($method, $args = null)
    {
        $method = ucfirst($method);

        $classname = 'Services_Ebay_Call_'.$method;
        $filename  = SERVICES_EBAY_BASEDIR . '/Ebay/Call/'.$method.'.php';
        if (file_exists($filename)) {
            include_once $filename;
        }
        if (!class_exists($classname)) {
            throw new Services_Ebay_API_Exception('API-Call \''.$method.'\' could not be found, please check the spelling, remember that method calls are case-sensitive.');
        }
        $call = new $classname($args);
        return $call;
    }

   /**
    * load a model
    *
    * @param    string  type of the model
    * @param    array   properties
    */
    public static function loadModel($type, $properties = null, $session = null)
    {
        if (isset(self::$modelClasses[$type])) {
        	$classname = self::$modelClasses[$type];
        } else {
            // use the default model class
            $classname = 'Services_Ebay_Model_'.$type;
            include_once SERVICES_EBAY_BASEDIR . '/Ebay/Model/'.$type.'.php';
        }
        if (!class_exists($classname)) {
            throw new Services_Ebay_Exception('Model \''.$type.'\' could not be found, please check the spelling');   
        }
        $model = new $classname($properties, $session);
        
        return $model;
    }
    
   /**
    * get list of all available API calls
    *
    * This can be used to check, whether an API call already has
    * been implemented
    *
    * @return   array   list of all available calls
    */
    public function getAvailableApiCalls()
    {
        $calls = array();

        $it = new DirectoryIterator(SERVICES_EBAY_BASEDIR . '/Ebay/Call');
        foreach ($it as $file) {
        	if (!$file->isFile()) {
        		continue;
        	}
        	array_push($calls, substr($file->getFilename(), 0, -4));
        }
        return $calls;
    }
}
?>