<?PHP
/**
 * Model for a list of eBay disputes
 *
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 */
class Services_Ebay_Model_DisputeList extends Services_Ebay_Model implements IteratorAggregate
{
   /**
    * container for disputes
    *
    * @var  array
    */
    private $disputes = array();
    
   /**
    * create a new list of disputes
    *
    * @param    array   return value from GetUserDisputes
    * @param    Services_Ebay_Session
    */
    public function __construct($props, $session = null)
    {
        if (isset($props['Disputes'])) {
            $disputes = $props['Disputes'];
            unset($props['Disputes']);
            if (isset($disputes['Dispute'][0])) {
                $this->disputes = $disputes['Dispute'];
            } else {
                $this->disputes = array($disputes['Dispute']);
            }
        }
        parent::__construct($props, $session);
    }
    
   /**
    * iterate through the disputes
    *
    * @return   object
    */
    public function getIterator()
    {
        $it = new ArrayObject($this->disputes);
        return $it;
    }
}
?>