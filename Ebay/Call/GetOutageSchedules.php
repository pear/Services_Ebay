<?PHP
/**
 * Get the outage schedules
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetOutageSchedules/GetOutageSchedules.htm
 */
class Services_Ebay_Call_GetOutageSchedules extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetOutageSchedules';

   /**
    * make the API call
    *
    * @param    object Services_Ebay_Session
    * @return   string
    */
    public function call(Services_Ebay_Session $session)
    {
        $return = parent::call($session);
        
        if (!isset($return['OutageSchedules']) || !is_array($return['OutageSchedules'])) {
            return array();
        }
        
        $list = $return['OutageSchedules']['OutageSchedule'];
        if (!isset($list[0])) {
            $list = array($list);
        }
        return $list;
    }
}
?>