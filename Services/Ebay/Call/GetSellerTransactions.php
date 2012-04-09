<?PHP
/**
 * Get all transactions for the current user
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetSellerTransactions/GetSellerTransactionsLogic.htm
 * @todo    create a model for the result set
 */
class Services_Ebay_Call_GetSellerTransactions extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetSellerTransactions';

    protected $args = array(
                            'Pagination'    => array(
                                                        'EntriesPerPage'=> 100,
                                                        'PageNumber'    => 1
                                                    )
                        );

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'ModTimeFrom',
                                 'ModTimeTo',
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
        if (isset($result['TransactionArray'])) {
            $result = Services_Ebay::loadModel('TransactionList', $return['TransactionArray'], $session);
            return $result;
        }

        return false;
    }
}
?>
