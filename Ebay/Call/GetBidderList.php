<?PHP
/**
 * Get all items a user has been/is bidding on
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @todo    build item list model
 */
class Services_Ebay_Call_GetBidderList extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetBidderList';

   /**
    * arguments of the call
    *
    * @var  array
    */
    protected $args = array(
                            'UserId'       => null,
                            'Active'       => 1,
                            'DetailLevel'  => 32
                        );
   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'UserId',
                                 'Active',
                                 'DetailLevel',
                                 'Days',
                                 'EndTimeFrom',
                                 'EndTimeTo'
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
        return Services_Ebay::loadModel('ItemList', $return['BidderList'], $session);
    }
}
?>