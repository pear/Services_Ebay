<?PHP
/**
 * Model for an eBay user
 *
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 */
class Services_Ebay_Model_User extends Services_Ebay_Model
{
   /**
    * model type
    *
    * @var  string
    */
    protected $type = 'User';

   /**
    * property that stores the unique identifier (=pk) of the model
    *
    * @var string
    */
    protected $primaryKey = 'UserId';

    /**
    * get the feedback for the user
    *
    * @param    int     Detail Level
    * @param    int     starting page
    * @param    int     items per page
    * @link     http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetFeedback/GetFeedback.htm
    */
    public function GetFeedback($DetailLevel = Services_Ebay::FEEDBACK_BRIEF, $StartingPage = 1, $ItemsPerPage = 25)
    {
        $args = array(
                       'UserId'       => $this->properties['UserId'],
                       'StartingPage' => $StartingPage,
                       'ItemsPerPage' => $ItemsPerPage,
                       'DetailLevel'  => $DetailLevel
                    );
        $call = Services_Ebay::loadAPICall('GetFeedback');
        $call->setArgs($args);
        
        return $call->call($this->session);
    }
    
   /**
    * get the list of items the user is selling
    *
    * @param    array   all arguments
    * @link     http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetSellerList/GetSellerList.htm
    */
    public function GetSellerList($args = array())
    {
        $defaultArgs = array(
                       'UserId'       => $this->properties['UserId'],
                       'DetailLevel'  => 16
                    );
        $args = array_merge($defaultArgs, $args);
        $call = Services_Ebay::loadAPICall('GetSellerList');
        $call->setArgs($args);
        
        return $call->call($this->session);
    }

   /**
    * get list of items on which the user is/has been bidding
    *
    * @link     http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetBidderList/GetBidderList.htm
    */
    public function GetBidderList($Active = 1, $DetailLevel = 32, $Days = null, $EndTimeFrom = null, $EndTimeTo = null)
    {
        $args = array(
                       'UserId'       => $this->properties['UserId'],
                       'Active'       => $Active,
                       'DetailLevel'  => 32,
                       'Days'         => $Days,
                       'EndTimeFrom'  => $EndTimeFrom,
                       'EndTimeTo'    => $EndTimeTo
                    );
        $call = Services_Ebay::loadAPICall('GetBidderList');
        $call->setArgs($args);
        
        return $call->call($this->session);
    }

   /**
    * leave feedback for the user
    *
    * @param    array   all arguments
    * @link     http://developer.ebay.com/DevZone/docs/API_Doc/Functions/LeaveFeedback/LeaveFeedbackLogic.htm
    */
    public function LeaveFeedback($ItemId, $CommentType, $Comment, $TransactionId = null)
    {
        $args = array(
                       'TargetUser'   => $this->properties['UserId'],
                       'ItemId'       => $ItemId,
                       'CommentType'  => $CommentType,
                       'Comment'      => $Comment
                    );
        if (!is_null($TransactionId)) {
            $args['TransactionId'] = $TransactionId;
        }
        $call = Services_Ebay::loadAPICall('LeaveFeedback');
        $call->setArgs($args);
        
        return $call->call($this->session);
    }

   /**
    * get the user from eBay
    *
    * Use this to query by a previously set user id
    *
    * <code>
    * $user = Services_Ebay::loadModel('User', 'superman-74', $session);
    * $user->Get();
    * </code>
    *
    * @param    string    ItemId
    * @see      Services_Ebay_Call_GetUser
    */
    public function Get($ItemId = null)
    {
        $args = array(
                        'UserId' => $this->properties['UserId'],
                        'ItemId' => $ItemId
                    );

        $call = Services_Ebay::loadAPICall('GetUser');
        $call->setArgs($args);
        
        $tmp = $call->call($this->session);
        $this->properties     = $tmp->toArray();
        $this->eBayProperties = $this->properties;
        unset($tmp);
        return true;
    }
}
?>