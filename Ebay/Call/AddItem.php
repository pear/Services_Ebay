<?PHP
/**
 * Add an item to Ebay
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
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
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array();

   /**
    * default parameters that will be used when
    * adding an item
    *
    * @var  array
    */
    protected $args = array(
                            'CheckoutDetailsSpecified' => 0,
                            'Country'                  => 'us',
                            'Currency'                 => '1',
                            'Duration'                 => '7',
                            'MinimumBid'               => '1.0',
                            'Quantity'                 => '1',
                            'Region'                   => '0',
                            'Version'                  => '2'
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
            throw new Exception( 'No item passed.' );
        }
        $this->item = $item;
        $this->args = array_merge( $this->args, $item->toArray() );
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