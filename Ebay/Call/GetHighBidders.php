<?PHP
/**
 * Get high bidders for a dutch auction
 * 
 * Be careful, this API call has not yet been tested!
 * 
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Carsten Lucke <luckec@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetHighBidders/GetHighBiddersLogic.htm
 */
class Services_Ebay_Call_GetHighbidders extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetHighBidders';

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'ItemId'
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

        return $return['Bids'];
    }
}
?>