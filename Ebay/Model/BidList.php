<?PHP
/**
 * Model for a list of bids
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Carsten Lucke <luckec@php.net>
 */
class Services_Ebay_Model_BidList extends Services_Ebay_Model implements IteratorAggregate
{
   /**
    * bids
    *
    * @var  array
    */
    private $bids = array();
    
    /**
     * Number of bids in the bid-list
     * 
     * @var integer
     */
    private $count = 0;
    
   /**
    * create new feedback model
    *
    * @param    array   feedback
    */
    public function __construct($bids, $session = null)
    {
        $this->count = (integer)$bids['Bids']['Count'];
        
        if (isset($bids['Bids']['Bid'])) {
            if (!isset($bids['Bids']['Bid'][0])) {
                $bids['Bids']['Bid'] = array($bids['Bids']['Bid']);
            }
            foreach ($bids['Bids']['Bid'] as $tmp) {
                array_push($this->bids, Services_Ebay::loadModel('Bid', $tmp, $session));
            }
        	unset($bids['Bids']);
        }
        parent::__construct($bids);
    }
    
   /**
    * iterate through the transactions
    *
    * @return array
    */
    public function getIterator()
    {
        return new ArrayObject($this->bids);
    }
    
    /**
     * Returns the number of bids, the bid-list contains.
     * 
     * @return integer  number of bids
     */
    public function getCount() {
        return $this->count;
    }
}
?>