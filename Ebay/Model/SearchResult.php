<?PHP
/**
 * Model for a search result
 *
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 */
class Services_Ebay_Model_SearchResult extends Services_Ebay_Model implements IteratorAggregate
{
   /**
    * items that have been found
    *
    * @var  array
    */
    private $items = array();
    
   /**
    * create new model
    *
    * @param    array
    * @param    object
    */
    public function __construct($props, $session = null)
    {
        if (isset($props['SearchResultItemArray']['SearchResultItem'])) {
            $items = $props['SearchResultItemArray']['SearchResultItem'];
            unset($props['SearchResultItemArray']['SearchResultItem']);
            if (isset($items[0])) {
                $items = $items;
            } else {
                $items = array($items);
            }
            foreach ($items as $tmp) {
                array_push($this->items, Services_Ebay::loadModel('Item', $tmp['Item'], $session));
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
        $it = new ArrayObject($this->items);
        return $it;
    }
}
?>
