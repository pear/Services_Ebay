<?PHP
/**
 * Model for a item list
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 */
class Services_Ebay_Model_ItemList extends Services_Ebay_Model implements IteratorAggregate
{
   /**
    * items of the list
    *
    * @var  array
    */
    private $items = array();

   /**
    * create a new item list
    *
    * @param    array   properties
    * @param    object Services_Ebay_Session
    */
    public function __construct($props, $session = null)
    {
        if (isset($props['Item'])) {
            if ( is_array($props['Item'])) {
                if (!isset($props['Item'][0])) {
                    $props['Item'] = array($props['Item']);
                }
                foreach ($props['Item'] as $item) {
                    array_push( $this->items, Services_Ebay::loadModel('Item', $item, $session) );
                }
            }
            unset($props['Item']);
        }
    
        parent::__construct($props, $session);
    }

   /**
    * get the iterator for the items in the list
    *
    * @return   object
    */
    public function getIterator()
    {
        $iterator = new ArrayObject($this->items);
        return $iterator;
    }
}
?>