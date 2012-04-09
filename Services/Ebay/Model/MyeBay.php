<?PHP
/**
 * Model for My eBay
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @todo    implement some helper methods to work with the lists
 */
class Services_Ebay_Model_MyeBay extends Services_Ebay_Model implements IteratorAggregate
{
   /**
    * available item lists
    *
    * @var  array
    */
    private $lists = array();

   /**
    * create a new item list
    *
    * @param    array   properties
    * @param    object Services_Ebay_Session
    */
    public function __construct($props, $session = null)
    {
        foreach ($props as $list => $data) {
        	$this->lists[$list] = Services_Ebay::loadModel('ItemList', $data, $session);
        }
    }

   /**
    * get the iterator for the items in the list
    *
    * @return   object
    */
    public function getIterator()
    {
        $iterator = new ArrayObject($this->lists);
        return $iterator;
    }
}
?>