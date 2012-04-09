<?PHP
/**
 * Revise the checkout status of a transaction
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/ReviseCheckoutStatus/ReviseCheckoutStatusLogic.htm
 */
class Services_Ebay_Call_ReviseCheckoutStatus extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'ReviseCheckoutStatus';

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'ItemId',
                                 'TransactionId',
                                 'StatusIs',
                                 'ShippingServiceSelected',
                                 'PaymentMethodUsed',
                                 'AmountPaid',
                                 'Currency'
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