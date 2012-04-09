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
        $this->properties['TransactionArray'] = array('Transaction' => array());
        $this->properties['ShippingDetails']  = array(
                                                        'ShippingServiceOptions'            => array(),
                                                        'InternationalShippingServiceOption'=> array(),
                                                        'SalesTax'                          => array()
                                                     );
    }

   /**
    * set a property
    * (overriding the parent one)
    *
    * @prop     string  property name
    * @prop     mixed   property value
    */   
    public function __set($prop, $value)
    {
        $shippingDetailsSubElements = array(
                                            'ApplyShippingDiscount',
                                            'InsuranceFee',
                                            'InsuranceOption',
                                            'ThirdPartyCheckout'
                                        );
        if (in_array($prop, $shippingDetailsSubElements)) {
            $this->properties['ShippingDetails'][$prop] = $value;
        } else {
            $this->properties[$prop] = $value;
        }
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
                            'Item'          => array(
                                                      'ItemID' => $ItemId
                                                    ),
                            'TransactionID' => $TransactionId
                            );
                            
        array_push($this->properties['TransactionArray']['Transaction'], $Transaction);
    }

   /**
    * add a new shipping option
    *
    * @param    string
    * @param    string
    */    
    public function AddShippingServiceOption($ShippingInsuranceCost, $ShippingService, $ShippingServiceAdditionalCost,
                                             $ShippingServiceCost, $ShippingServicePriority)
    {
        $Option = array(
                            'ShippingInsuranceCost'         => $ShippingInsuranceCost,
                            'ShippingService'               => $ShippingService,
                            'ShippingServiceAdditionalCost' => $ShippingServiceAdditionalCost,
                            'ShippingServiceCost'           => $ShippingServiceCost,
                            'ShippingServicePriority'       => $ShippingServicePriority
                       );
                            
        array_push($this->properties['ShippingDetails']['ShippingServiceOptions'], $Option);
    }

   /**
    * Add International shipping service options
    *
    * @param    string
    * @param    string
    * @param    string
    * @param    int
    * @param    string
    */
    public function AddInternationalShippingServiceOption($ShippingService, $ShippingServiceAdditionalCost,
                                                          $ShippingServiceCost, $ShippingServicePriority,
                                                          $ShipToLocation)
    {
        $Options = array(
                            'ShippingService'               => $ShippingService,
                            'ShippingServiceAdditionalCost' => $ShippingServiceAdditionalCost,
                            'ShippingServiceCost'           => $ShippingServiceCost,
                            'ShippingServicePriority'       => $ShippingServicePriority,
                            'ShipToLocation'                => $ShipToLocation
                        );

        array_push($this->properties['ShippingDetails']['InternationalShippingServiceOption'], $Options);
    }

   /**
    * Add Sales tax options
    *
    * @param    float
    * @param    string
    * @param    boolean
    */
    public function AddSalesTax($SalesTaxPercent, $SalesTaxState, $ShippingIncludedInTax)
    {
        $Option = array(
                            'SalesTaxPercent'       => $SalesTaxPercent,
                            'SalesTaxState'         => $SalesTaxState,
                            'ShippingIncludedInTax' => $ShippingIncludedInTax
                        );

        array_push($this->properties['ShippingDetails']['SalesTax'], $Option);
    }
}
?>
