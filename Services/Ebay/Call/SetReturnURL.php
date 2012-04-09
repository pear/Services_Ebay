<?PHP
/**
 * Set the return URL
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/SetReturnURL/SetReturnURLLogic.htm
 */
class Services_Ebay_Call_SetReturnUrl extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'SetReturnUrl';

   /**
    * authentication type of the call
    *
    * @var  int
    */
    protected $authType = Services_Ebay::AUTH_TYPE_USER;

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                'RuName',
                                'Action',
                                'AcceptURL',
                                'RejectURL',
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
        if ($return['Status'] === 'Success') {
            return true;
        }
        return false;
    }
}
?>