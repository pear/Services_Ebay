<?PHP
/**
 * Add a shipment
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 */
class Services_Ebay_Call_AddShipment extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'AddShipment';

   /**
    * options that will be passed to the serializer
    *
    * @var  array
    */
    protected $serializerOptions = array(
                                            'defaultTagName' => 'Transaction'
                                        );
   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array();

   /**
    * constructor
    *
    * @param    array
    */
    public function __construct($args)
    {
        $item = $args[0];
        
        if (!$item instanceof Services_Ebay_Model_Shipment ) {
            throw new Services_Ebay_Exception( 'No shipment passed.' );
        }
        $this->item = $item;
        $this->args['Shipment'] = $item->toArray();
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
        echo '<pre>';
        print_r($return);
        echo '</pre>';
        return false;
    }
}
?>