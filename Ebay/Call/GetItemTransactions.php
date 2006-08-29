<?PHP
/**
 * Get all transactions for an item
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetItemTransactions/GetItemTransactionsLogic.htm
 * @todo    create a model for the result set
 */
class Services_Ebay_Call_GetItemTransactions extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetItemTransactions';

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'ItemID',
                                 'ModTimeFrom',
                                 'ModTimeTo',
                                 'TransactionsPerPage',
                                 'PageNumber'
                                );
   /**
    * make the API call
    *
    * @param    object Services_Ebay_Session
    * @return   string
    */
    public function call(Services_Ebay_Session $session)
    {
        $bak = $this->args;
        $this->args['PaginationType'] = array();
        foreach ($this->paramMap as $param) {
            if ($param == 'TransactionsPerPage' || $param == 'PageNumber') {
                if (!isset($this->args[$param])) {
                    continue;
                }
                $this->args['PaginationType'][$param] = $this->args[$param];
                unset( $this->args[$param] );
            }
        }

        $return = parent::call($session);
        $result = Services_Ebay::loadModel('TransactionList', $return, $session);

        $this->args = $bak;
        return $result;
    }
}
?>
