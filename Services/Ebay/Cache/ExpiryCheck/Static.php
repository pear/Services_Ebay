<?PHP
/**
 * Static Expiry Check
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 */
class Services_Ebay_Cache_ExpiryCheck_Static
{
   /**
    * static lifetime of the cache
    *
    * @var  integer
    */
    private $lifetime = null;
    
   /**
    * constructor
    *
    * @param   integer      lifetime in seconds
    */
    public function __construct($lifetime)
    {
    	$this->lifetime = $lifetime;
    }
    
   /**
    * check, whether the cache is valid
    *
    * @param   string      type of the model
    * @param   integer      timestamp the cache has been created
    * @param   array        model properties stored in the cache
    */
    public function isValid($Type, $timestamp, $props)
    {
    	if ($timestamp + $this->lifetime > time()) {
    		return true;
    	}
    	return false;
    }
}
?>