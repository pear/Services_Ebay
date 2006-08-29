<?PHP
/**
 * Get all access rules for the API
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetAPIAccessRules/GetAPIAccessRulesLogic.htm
 */
class Services_Ebay_Call_GetAPIAccessRules extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetAPIAccessRules';

   /**
    * make the API call
    *
    * @param    object Services_Ebay_Session
    * @return   string
    */
    public function call(Services_Ebay_Session $session)
    {
        $return = parent::call($session);
        return $return['ApiAccessRule'];
    }
}
?>
