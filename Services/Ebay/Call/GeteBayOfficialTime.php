<?PHP
/**
 * Get the official eBay time
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GeteBayOfficialTime/GeteBayOfficialTimeLogic.htm
 */
class Services_Ebay_Call_GetEbayOfficialTime extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GeteBayOfficialTime';

   /**
    * make the API call
    *
    * @param    object Services_Ebay_Session
    * @return   string
    */
    public function call(Services_Ebay_Session $session)
    {
        $return = parent::call($session);
        return $return['Timestamp'];
    }
}
?>
