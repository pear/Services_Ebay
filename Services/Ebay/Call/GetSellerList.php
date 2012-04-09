<?PHP
/**
 * Get all items a user is selling
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetRuName/GetRuNameLogic.htm
 * @todo    test paginating
 * @todo    build item list model
 */
class Services_Ebay_Call_GetSellerList extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetSellerList';

   /**
    * arguments of the call
    *
    * @var  array
    */
    protected $args = array(
                            'UserID'        => null,
                            'DetailLevel'   => 'ReturnAll',
                            'Pagination'    => array(
                                                        'PageNumber'    => 1,
                                                        'EntriesPerPage'=> 100
                                                    )
                        );
   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'UserID',
                                 'EntriesPerPage',
                                 'Sort'
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
        return Services_Ebay::loadModel('ItemList', $return, $session);
    }
}
?>
