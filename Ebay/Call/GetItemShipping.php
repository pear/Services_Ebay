<?PHP
/**
 * Get shipping costs for an item
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 */
class Services_Ebay_Call_GetItemShipping extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetItemShipping';

   /**
    * arguments of the call
    *
    * @var  array
    */
    protected $args = array(
                            'QuantitySold' => 1
                        );

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'ItemId',
                                 'ShipToZipCode',
                                 'QuantitySold'
                                );
    
   /**
    * make the API call
    *
    * @param    object Services_Ebay_Session
    * @return   string
    */
    public function call(Services_Ebay_Session $session)
    {
        $return = parent::call($session);
        
        if (isset($return['ShippingRate']['ShippingServiceOptions']['ShippingServiceOption'][0])) {
            $return['ShippingRate']['ShippingServiceOptions'] = $return['ShippingRate']['ShippingServiceOptions']['ShippingServiceOption'];
            unset($return['ShippingRate']['ShippingServiceOptions']['ShippingServiceOption']);
        } else {
            $return['ShippingRate']['ShippingServiceOptions'] = array( $return['ShippingRate']['ShippingServiceOptions']['ShippingServiceOption'] );
            unset($return['ShippingRate']['ShippingServiceOptions']['ShippingServiceOption']);
        }
        
        
        
        return $return['ShippingRate'];
    }
}
?>