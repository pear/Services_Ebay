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
 */
class Services_Ebay_Model
{
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
    * create new model
    *
    * @param    array   properties
    */
    public function __construct($props, $session = null)
    {
        if (is_array($props)) {
            $this->properties = $props;
        } elseif ($this->primaryKey !== null) {
            $this->properties[$this->primaryKey] = $props;
        }
        if( $session instanceof Services_Ebay_Session) {
            $this->session = $session;
        }
        $this->eBayProperties = $this->properties;
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
}
?>