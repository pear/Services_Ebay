<?PHP
/**
 * Model for a eBay feedback
 *
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 */
class Services_Ebay_Model_FeedbackEntry extends Services_Ebay_Model
{
   /**
    * get the item, for which the feedback was given
    *
    * @return object Services_Ebay_Model_Item
    */
    public function getItem()
    {
        $args = array(
                        'Id' => $this->properties['ItemNumber']
                    );
        $call = Services_Ebay::loadAPICall('GetItem');
        $call->setArgs($args);
        
        return $call->call($this->session);
    }
    
   /**
    * create string representation of the entry
    *
    * @return string
    */
    public function __toString()
    {
        return sprintf('%s: %s', $this->properties['CommentingUser'], $this->properties['CommentText']);
    }
}
?>