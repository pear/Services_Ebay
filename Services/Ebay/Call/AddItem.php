<?PHP
/**
 * Add an item to Ebay
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/AddItem/AddItemLogic.htm
 */
class Services_Ebay_Call_AddItem extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'AddItem';

   /**
    * compatibility level this method was introduced
    *
    * @var integer
    */
    protected $since = 465;

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
    * default parameters that will be used when
    * adding an item
    *
    * @var  array
    */
    protected $args = array(
                            'Item' => array(
                                            'ShippingDetails'   => array(
                                                                            'InsuranceFee' => 0
                                                                        ),
                                            'Country'           => 'US',
                                            'Currency'          => 'USD',
                                            'StartPrice'        => '1.0',
                                            'Quantity'          => '1'
                                           ),
                           );

   /**
    * item that should be added
    *
    * @var  object Services_Ebay_Model_Item
    */
    protected $item;

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
        
        $this->setItem($item);
    }

   /**
    * set the item that should be added
    *
    * @param    Services_Ebay_Model_Item
    * @return   boolean
    */
    public function setItem(Services_Ebay_Model_Item $item)
    {
        $this->item = $item;
        $this->args = array_merge( $this->args, $item->toArray() );
        
        return true;
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

        if (isset($return['ItemID'])) {
            $this->item->Id = $return['ItemID'];
            $this->item->StartTime = $return['StartTime'];
            $this->item->EndTime = $return['EndTime'];
            $this->item->Fees = $return['Fees']['Fee'];
        
            return true;
        }
        return false;
    }
}
?>
