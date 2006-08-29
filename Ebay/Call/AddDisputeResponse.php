<?PHP
/**
 * Add a dispute response
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/AddDisputeResponse/AddDisputeResponseLogic.htm
 */
class Services_Ebay_Call_AddDisputeResponse extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'AddDisputeResponse';

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
                                 'DisputeID',
                                 'DisputeActivity',
                                 'MessageText'
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
        if ($return['Ack'] === 'Success') {
        	return true;
        }
        return false;
    }
}
?>
