<?PHP
/**
 * Base class for all caches
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 */
abstract class Services_Ebay_Cache
{
   /**
    * options of the cache
    *
    * @var  array
    */
    protected $options = array();
    
   /**
    * stores the expiry object
    *
    * @var  object
    */
    protected $expiry = null;
    
   /**
    * constructor
    *
    * @param    array   options for the cache
    */
    public function __construct($options)
    {
    	$this->options = $options;
    }
    
   /**
    * load a model from cache
    *
    * @param    string      model type
    * @param    string      primary key
    * @param    integer     detail level
    * @return   array|boolean
    */
    abstract public function load($Type, $Key, $DetailLevel);

   /**
    * store model data in the cache
    *
    * @param    string      model type
    * @param    string      primary key
    * @param    integer     detail level
    * @param    array       properties
    * @return   boolean
    */
    abstract public function store($Type, $Key, $DetailLevel, $Props);

   /**
    * set the expiry type
    *
    * Services_Ebay allows custom expiry objects to check the validity of
    * a cached model.
    * This enables you to create a cache lifetime depending of the 
    * end of the auction or the version number of a category listing.
    *
    * The following expiry types have been implemented:
    * - Static
    *
    * @param    string      expiry type
    * @param    mixed       parameters for the expiry
    */
    public function setExpiry($type, $params)
    {
        $className = 'Services_Ebay_Cache_ExpiryCheck_' . $type;
        $fileName  = SERVICES_EBAY_BASEDIR . '/Ebay/Cache/ExpiryCheck/' . $type . '.php';
        @include_once $fileName;
        
        if (!class_exists($className)) {
        	throw new Services_Ebay_Exception('Unknown expiry check \''.$type.'\'.');
        }
        
        $this->expiry = new $className($params);
        return true;
    }
    
   /**
    * check the validity of the cache
    *
    * @param    string      type of the model
    * @param    integer     time the cache has been created
    * @param    array       model properties
    */
    protected function isValid($Type, $ts, $props)
    {
        if (!is_object($this->expiry)) {
        	return true;
        }
        return $this->expiry->isValid($Type, $ts, $props);
    }
}
?>