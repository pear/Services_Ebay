<?PHP
/**
 * Model for an eBay order
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 */
class Services_Ebay_Model_Order extends Services_Ebay_Model
{
   /**
    * create a new order
    *
    * @param    array
    * @param    object
    */
    public function __construct($props, $session = null)
    {
        parent::__construct($props, $session);
        $this->properties['Transactions'] = array('Transaction' => array());
        $this->properties['ShippingServiceOptions'] = array('ShippingServiceOption' => array());
        $this->properties['PaymentTerms'] = array();
    }
    
   /**
    * add a new transaction
    *
    * @param    string
    * @param    string
    */    
    public function AddTransaction($ItemId, $TransactionId)
    {
        $Transaction = array(
                            'ItemId' => $ItemId,
                            'TransactionId' => $TransactionId
                            );
                            
        array_push($this->properties['Transactions']['Transaction'], $Transaction);
    }

   /**
    * add a new shipping option
    *
    * @param    string
    * @param    string
    */    
    public function AddShippingServiceOption($ShippingService, $ShippingServiceCost, $ShippingServicePriority)
    {
        $Option = array(
                            'ShippingService'         => $ShippingService,
                            'ShippingServiceCost'     => $ShippingServiceCost,
                            'ShippingServicePriority' => $ShippingServicePriority
                            );
                            
        array_push($this->properties['ShippingServiceOptions']['ShippingServiceOption'], $Option);
    }

   /**
    * set the accepted payment terms
    *
    * @param    string
    */    
    public function AcceptPaymentTerms($methods)
    {
        $methods = func_get_args();
        foreach ($methods as $method) {
        	$this->properties['PaymentTerms'][$method] = 1;
        }
    }
    
}
?>