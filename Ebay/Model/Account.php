<?PHP
/**
 * Model for an eBay account
 *
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 */
class Services_Ebay_Model_Account extends Services_Ebay_Model implements IteratorAggregate
{
   /**
    * entries in the account
    *
    * @var  array
    */
    private $entries = array();
    
   /**
    * create new model
    *
    * @param    array
    * @param    object
    */
    public function __construct($props, $session = null)
    {
        if (isset($props['Entry'])) {
            $entries = $props['Entry'];
            unset($props['Entry']);
            if (isset($entries[0])) {
                $this->entries = $entries;
            } else {
                $this->entries = array($entries);
            }
        }
        parent::__construct($props, $session);
    }

   /**
    * iterate through the items
    *
    * @return   object
    */
    public function getIterator()
    {
        $it = new ArrayObject($this->entries);
        return $it;
    }
}
?>