<?PHP
/**
 * Get Details about an eBay site
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GeteBayDetails/GeteBayDetailsLogic.htm
 */
class Services_Ebay_Call_GeteBayDetails extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GeteBayDetails';

   /**
    * options that will be passed to the serializer
    *
    * @var  array
    */
    protected $serializerOptions = array(
                                            'defaultTagName' => 'Detail'
                                        );
   /**
    * create a new call
    *
    * @param    array   details you want to retrieve
    */
    public function __construct($args)
    {
        if (!empty($args)) {
            $this->args['Details'] = array();
            foreach ($args as $detail) {
            	array_push($this->args['Details'], array('Name' => $detail));
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
        if (!isset($return['Details']['Detail'][0])) {
            $return['Details']['Detail'] = array($return['Details']['Detail']);
        }
        return $return['Details']['Detail'];
    }
}
?>