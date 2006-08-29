<?PHP
/**
 * Revise (change) an item that has been added to Ebay
 *
 * <code>
 * $item = $eBay->GetItem('12345678');
 * $item->Title = 'New title';
 * $eBay->ReviseItem($item);
 * </code>
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/ReviseItem/ReviseItemLogic.htm
 * @see     Services_Ebay_Model_Item::Revise()
 */
class Services_Ebay_Call_ReviseItem extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'ReviseItem';

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array();

   /**
    * options that will be passed to the serializer
    *
    * @var  array
    */
    protected $serializerOptions = array(
                                            'mode' => 'simplexml'
                                        );
   /**
    * constructor
    *
    * @param    array
    */
    public function __construct($args)
    {
        $item = $args[0];
        
        if (!$item instanceof Services_Ebay_Model_Item) {
            throw new Services_Ebay_Exception( 'No item passed.' );
        }
        
        $id = $item->Id;
        
        if (empty($id)) {
            throw new Services_Ebay_Exception( 'Item has no ID.' );
        }

        $this->args = $item->GetModifiedProperties();
        if (isset($this->args['Id'])) {
            throw new Services_Ebay_Exception( 'You must not change the item ID.' );
        }
        
        $this->args['ItemID'] = $id;
    }
    
   /**
    * make the API call
    *
    * @param    object Services_Ebay_Session
    * @return   string
    */
    public function call(Services_Ebay_Session $session)
    {
        $return = parent::call($session);
        if (isset($return['Item'])) {
            $returnItem = $return['Item'];

            $this->item->Id = $returnItem['Id'];
            $this->item->StartTime = $returnItem['StartTime'];
            $this->item->EndTime = $returnItem['EndTime'];
            $this->item->Fees = $returnItem['Fees'];
        
            return true;
        }
        return false;
    }
}
?>
