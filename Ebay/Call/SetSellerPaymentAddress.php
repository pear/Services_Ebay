<?PHP
/**
 * Set the payment adress for the seller
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/SetSellerPaymentAddress/SetSellerPaymentAddressLogic.htm
 */
class Services_Ebay_Call_SetSellerPaymentAddress extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'SetSellerPaymentAddress';

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'Name',
                                 'Street1',
                                 'Street2',
                                 'City',
                                 'StateOrProvince',
                                 'Country',
                                 'Zip',
                                 'Phone'
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
        if ($return['CallStatus']['Status'] === 'Success') {
        	return true;
        }
        return false;
    }
}
?>