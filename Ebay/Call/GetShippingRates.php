<?PHP
/**
 * Get shipping rates
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetShippingRates/GetShippingRatesLogic.htm
 */
class Services_Ebay_Call_GetShippingRates extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetShippingRates';

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'ShipFromZipCode',
                                 'ShipToZipCode',
                                 'ShippingPackage',
                                 'WeightMajor',
                                 'WeightMinor'
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
        if (isset($return['ShippingRates']['ShippingRate'][0])) {
        	return $return['ShippingRates']['ShippingRate'];
        }
        return array($return['ShippingRates']['ShippingRate']);
    }
}
?>