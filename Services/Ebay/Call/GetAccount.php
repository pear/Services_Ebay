<?PHP
/**
 * Get the account of the user
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetAccount/GetAccountLogic.htm
 */
class Services_Ebay_Call_GetAccount extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetAccount';

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'AccountHistorySelection',
                                 'BeginDate',
                                 'EndDate',
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
        return Services_Ebay::loadModel('Account', $return['AccountEntries'], $session);
    }
}
?>
