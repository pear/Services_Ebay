<?PHP
/**
 * Base class for all models
 *
 * $Id$
 *
 * The base class provides __set() and __get()
 * as well as some other helper methods.
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 *
 * @todo    different caches for different detail levels
 * @todo    add the possibility to disable the cache for single models
 */
class Services_Ebay_Model implements ArrayAccess
{
   /**
    * model type
    *
    * @var  string
    */
    protected $type = null;
    
   /**
    * properties of the model
    *
    * @var  array
    */
    protected $properties = array();

   /**
    * properties that are stored in eBay's database
    *
    * These are stored to check, which fields have been modified
    * in the item
    *
    * @var  array
    */
    protected $eBayProperties = array();

   /**
    * optional session, used to send API calls
    *
    * @var  object Services_Ebay_Session
    */
    protected $session;
    
   /**
    * property that stores the unique identifier (=pk) of the model
    *
    * @var string
    */
    protected $primaryKey = null;

   /**
    * store the static cache for all models of this type
    *
    * @var  object Services_Ebay_Cache
    */
    protected static $cache = null;

   /**
    * indicates, whether the model has been cached
    *
    */
    protected $cached = false;
    
    /**
    * create new model
    *
    * @param    array   properties
    */
    public function __construct($props, $session = null, $DetailLevel = 0)
    {
        $this->cached = false;
        if (is_array($props)) {
            $this->properties = $props;
        } elseif ($this->primaryKey !== null) {
            $this->properties[$this->primaryKey] = $props;
            
            // try loading the data from the cache
            if (is_object(self::$cache)) {
            	$cacheProps = self::$cache->load($this->type, $this->getPrimaryKey(), $DetailLevel);
            	if (is_array($cacheProps)) {
            		$this->properties = $cacheProps;
            		$this->cached = true;
            	}
            }
        }
        
        // store the session
        if( $session instanceof Services_Ebay_Session) {
            $this->session = $session;
        }
        $this->eBayProperties = $this->properties;
        
        if (!$this->isCached() && is_object(self::$cache)) {
        	self::$cache->store($this->type, $this->getPrimaryKey(), $DetailLevel, $this->properties);
        }
    }
    
   /**
    * check, whether the model has been cached
    *
    * @return   boolean
    */
    public function isCached()
    {
    	return $this->cached;
    }
    
   /**
    * set the session
    *
    * @param    object Services_Ebay_Session
    */
    public function setSession(Services_Ebay_Session $session)
    {
        $this->session = $session;
    }

   /**
    * set the cache
    *
    * @param    object Services_Ebay_Cache
    */
    static public function setCache(Services_Ebay_Cache $cache)
    {
        self::$cache = $cache;
    }
    
   /**
    * get a property
    *
    * @param    string   property name
    * @return   mixed    property value
    */
    public function __get($prop)
    {
        if (isset($this->properties[$prop])) {
            return $this->properties[$prop];
        }
    }
    
   /**
    * set a property
    *
    * @param    string   property name
    * @param    mixed    property value
    */
    public function __set($prop, $value)
    {
        $this->properties[$prop] = $value;
    }
    
   /**
    * return all properties of the user
    *
    * @return   array
    */
    public function toArray()
    {
        return $this->properties;
    }

   /**
    * get the properties that have been modified,
    * since the item has been fetched the last
    * time.
    *
    * This does not involve an API-call
    *
    * @return   array
    */
    public function GetModifiedProperties()
    {
        $modified = array();
        foreach ($this->properties as $key => $value) {
            if (!isset($this->eBayProperties[$key])) {
                $modified[$key] = $value;
                continue;
            }
            if ($this->eBayProperties[$key] === $value) {
                continue;
            }
            $modified[$key] = $value;
        }
        return $modified;
    }

   /**
	* check, whether a property exists
	*
	* This is needed to implement the ArrayAccess interface
	*
	* @param	string	property
	*/
	public function offsetExists($offset)
	{
	    if (isset($this->properties[$offset])) {
	    	return true;
	    }
	    return false;
	}

   /**
	* get a property
	*
	* This is needed to implement the ArrayAccess interface
	*
	* @param	string	property
	*/
	public function offsetGet($offset)
	{
		return $this->properties[$offset];
	}

   /**
	* set a property
	*
	* This is needed to implement the ArrayAccess interface
	*
	* @param	string	property
	* @param	mixed	value
	*/
	public function offsetSet($offset, $value)
	{
		$this->properties[$offset] = $value;
	}

   /**
	* unset a property
	*
	* This is needed to implement the ArrayAccess interface
	*
	* @param	string	property
	*/
	public function offsetUnset($offset)
	{
		unset($this->properties[$offset]);
	}

   /**
    * get the primary key of the model
    *
    * @return   string
    */
	public function getPrimaryKey()
	{
		if ($this->primaryKey === null) {
			return false;
		}
		if (!isset($this->properties[$this->primaryKey])) {
			return false;
		}
		return $this->properties[$this->primaryKey];
	}
}
?>