<?PHP
/**
 * Model for a list of transactions
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @todo    improve handling of transactions (possibly store the itemId in each transaction object)
 * @todo    build seller object
 */
class Services_Ebay_Model_TransactionList extends Services_Ebay_Model implements IteratorAggregate
{
   /**
    * transactions
    *
    * @var  array
    */
    private $transactions = array();
    
   /**
    * create new feedback model
    *
    * @param    array   feedback
    */
    public function __construct($transactions, $session = null)
    {
        if (isset($transactions['Transactions']['Transaction'])) {
            if (!isset($transactions['Transactions']['Transaction'][0])) {
                $transactions['Transactions']['Transaction'] = array( $transactions['Transactions']['Transaction'] );
            }
            foreach ($transactions['Transactions']['Transaction'] as $tmp) {
                array_push($this->transactions, Services_Ebay::loadModel('Transaction', $tmp, $session));
            }
        	unset($transactions['Transactions']);
        }
        parent::__construct($transactions);
    }
    
   /**
    * iterate through the transactions
    *
    * @return array
    */
    public function getIterator()
    {
        return new ArrayObject($this->transactions);
    }
}
?>