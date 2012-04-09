<?PHP
/**
 * Get a all disputes the where the current user is either seller or buyer
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetUserDisputes/GetUserDisputesLogic.htm
 * @todo    parse the correct filters from the response
 */
class Services_Ebay_Call_GetUserDisputes extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetUserDisputes';

   /**
    * compatibility level this method was introduced
    *
    * @var  integer
    */
    protected $since = 361;
    
   /**
    * arguments of the call
    *
    * @var  array
    */
    protected $args = array(
                            'Pagination' => array(
                                                    'PageNumber' => '1'
                                                )
                        );
   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'DisputeFilterType',
                                 'DisputeSortType',
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
        return Services_Ebay::loadModel('DisputeList', $return, $session);
    }
}
?>
