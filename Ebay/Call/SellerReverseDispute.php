<?PHP
/**
 * Reverse a dispute
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/SellerReverseDispute/SellerReverseDisputeLogic.htm
 */
class Services_Ebay_Call_SellerReverseDispute extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'SellerReverseDispute';

   /**
    * compatibility level this method was introduced
    *
    * @var  integer
    */
    protected $since = 361;
    
   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'DisputeId',
                                 'ReversalReasonId'
                                );
    
   /**
    * make the API call
    *
    * @param    object Services_Ebay_Session
    * @return   boolean
    */
    public function call(Services_Ebay_Session $session)
    {
        $return = parent::call($session);
        if ($return['CallStatus'] === 'Success') {
        	return true;
        }
        return false;
    }
}
?>