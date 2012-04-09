<?PHP
/**
 * Get shipping costs for an item
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetItemShipping/GetItemShippingLogic.htm
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
                                 'ItemID',
                                 'DestinationPostalCode',
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
        
        if (isset($return['ShippingDetails']['ShippingServiceOptions'][0])) {
            $return['ShippingDetails']['ShippingServiceOptions'] = $return['ShippingDetails']['ShippingServiceOptions'];
            unset($return['ShippingDetails']['ShippingServiceOptions']);
        } else {
            $return['ShippingDetails']['ShippingServiceOptions'] = array( $return['ShippingDetails']['ShippingServiceOptions'] );
            unset($return['ShippingRate']['ShippingServiceOptions']);
        }
        
        return $return['ShippingDetails'];
    }
}
?>
