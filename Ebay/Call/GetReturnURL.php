<?PHP
/**
 * Get the return URL
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetReturnURL/GetReturnURLLogic.htm
 */
class Services_Ebay_Call_GetReturnUrl extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetReturnUrl';

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
    protected $paramMap = array();
    
   /**
    * make the API call
    *
    * @param    object Services_Ebay_Session
    * @return   string
    */
    public function call(Services_Ebay_Session $session)
    {
        $return = parent::call($session);
        return $return;
    }
}
?>
