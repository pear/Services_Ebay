<?PHP
/**
 * Model for a list of member messages
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Carsten Lucke <luckec@php.net>
 */
class Services_Ebay_Model_MemberMessageList extends Services_Ebay_Model implements IteratorAggregate
{
   /**
    * member messages
    *
    * @var  array
    */
    private $messages = array();
    
    /**
     * Total number of entries being retrieved.
     * 
     * @var integer
     */
    private $entries = 0;
    
    /**
     * Total number of pages in the retrieval.
     * 
     * @var integer
     */
    private $pages = 0;
    
    /**
     * Whether or not there are more messages left to retrieve.
     * 
     * @var boolean
     */
    private $moreItems = false;
    
   /**
    * create new feedback model
    *
    * @param    array   feedback
    */
    public function __construct($messages, $session = null)
    {
        $this->moreItems = $messages['HasMoreItems'] == 'false' ? false : true;
        $this->pages = (integer)$messages['PaginationResult']['TotalNumberOfPages'];
        $this->entries = (integer)$messages['PaginationResult']['TotalNumberOfEntries'];
        if (isset($messages['MemberMessage'])) {
            if (!isset($messages['MemberMessage'][0])) {
                $messages['MemberMessage'] = array($messages['MemberMessage']);
            }
            foreach ($messages['MemberMessage'] as $tmp) {
                array_push($this->messages, Services_Ebay::loadModel('MemberMessage', $tmp, $session));
            }
            unset($messages['MemberMessage']);
        }
        parent::__construct($messages);
    }
    
   /**
    * iterate through the transactions
    *
    * @return array
    */
    public function getIterator()
    {
        return new ArrayObject($this->messages);
    }
    
    /**
     * Returns the total number of pages in the retrieval.
     * 
     * @return integer total number of pages in the retrieval
     */
    public function getNumberOfPages() {
        return $this->pages;
    }
    
    /**
     * Returns the total number of entries being retrieved.
     * 
     * @return integer total number of entries being retrieved
     */
    public function getNumberOfEntries() {
        return $this->entries;
    }
    
    /**
     * Determines whether or not there are more messages left to retrieve.
     * 
     * @return boolean whether or not there are more messages left to retrieve
     */
    public function hasMoreItems() {
        return $this->moreItems;
    }
}
?>
