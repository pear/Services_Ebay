<?PHP
/**
 * Add an order
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/AddOrder/AddOrderLogic.htm
 */
class Services_Ebay_Call_AddOrder extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'AddOrder';

   /**
    * options that will be passed to the serializer
    *
    * @var  array
    */
    protected $serializerOptions = array(
                                            'mode' => 'simplexml'
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
        $order = $args[0];
        
        if (!$order instanceof Services_Ebay_Model_Order ) {
            throw new Services_Ebay_Exception( 'No order passed.' );
        }
        $this->args['Order'] = $order->toArray();
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
        if (isset($return['OrderID'])) {
        	return $return['OrderID'];
        }
        return false;
    }
}
?>
