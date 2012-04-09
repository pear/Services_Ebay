<?PHP
/**
 * Get the notification preferences
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetNotificationPreferences/GetNotificationPreferencesLogic.htm
 */
class Services_Ebay_Call_GetNotificationPreferences extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetNotificationPreferences';

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'PreferenceLevel'
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
        switch($this->args['PreferenceLevel']) {
            case 'Application':
                return $return['ApplicationDeliveryPreferences'];
                break;
            case 'User':
                return $return['UserDeliveryPreferenceArray'];
                break;
            case 'UserData':
                return $return['UserData'];
                break;
            case 'Event':
                return $return['EventProperty'];
                break;
            default:
                return $return;
        }
    }
}
?>
