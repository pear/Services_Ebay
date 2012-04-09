<?PHP
/**
 * Get user preferences
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetPreferences/GetPreferencesLogic.htm
 * @todo    build a model for preferences
 */
class Services_Ebay_Call_GetPreferences extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetPreferences';

   /**
    * options that will be passed to the serializer
    *
    * @var  array
    */
    protected $serializerOptions = array(
                                            'defaultTagName' => 'Preference'
                                        );
   /**
    * create a new call
    *
    * @param    array   details you want to retrieve
    */
    public function __construct($args)
    {
        if (!empty($args)) {
            if (is_array($args[0])) {
                $this->args['Preferences'] = $args[0];
            } else {
                $this->args['Preferences'] = array( $args[0] );
            }
        }
    }

   /**
    * make the API call
    *
    * @param    object Services_Ebay_Session
    * @return   string
    */
    public function call(Services_Ebay_Session $session)
    {
        $return = parent::call($session);
        return Services_Ebay::loadModel('Preferences', $return['GetPreferencesResult']['Preferences'], $session);
    }
}
?>