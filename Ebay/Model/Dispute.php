<?PHP
/**
 * Model for a eBay dispute
 *
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 */
class Services_Ebay_Model_Dispute extends Services_Ebay_Model implements IteratorAggregate
{
   /**
    * dispute messages
    *
    * @var  array
    */
    private $messages = array();
    
   /**
    * constructor
    *
    * @param    array
    */
    public function __construct($props, $session = null)
    {
        if (isset($props['Messages'])) {
            $messages = $props['Messages'];
            unset($props['Messages']);
            if (isset($messages['Message'][0])) {
                $this->messages = $messages['Message'];
            } else {
                $this->messages = array($messages['Message']);
            }
        }
        parent::__construct($props, $session);
    }
    
   /**
    * iterate through the messages in the dispute
    *
    * @return   object
    */
    public function getIterator()
    {
        $it = new ArrayObject($this->messages);
        return $it;
    }
}
?>