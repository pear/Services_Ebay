<?PHP
/**
 * Model for a single bid
 *
 * @package Services_Ebay
 * @author  Carsten Lucke <luckec@php.net>
 */
class Services_Ebay_Model_Bid extends Services_Ebay_Model
{
    /**
     * The bidder.
     * 
     * @var Services_Ebay_Model_User the bidding user
     */
    private $user;
    
    /**
     * Constructor
     *
     * @param array     $props  properties
     * @param Services_Ebay_Session $session    session
     * @param integer   $DetailLevel    detail-level
     */
    public function __construct($props, $session = null, $DetailLevel = 0) {
        parent::__construct($props, $session, $DetailLevel);
        
        $this->user = Services_Ebay::loadModel('User', $props['User'], $session);
        unset($this->properties['User']);
    }
    
    /**
     * Returns the user model with abbreviated user-information.
     * 
     * To fetch all information use the model's Get() method.
     * 
     * <code>
     *  $user = $bid->getBidder();
     *  
     *  // fetch the user's details from eBay
     *  $user->Get($itemId);
     * </code>
     * 
     * @return  Services_Ebay_Model_User    the user
     */
    public function getBidder() {
        return $this->user;
    }
}
?>