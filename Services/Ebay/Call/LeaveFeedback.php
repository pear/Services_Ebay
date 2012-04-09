<?PHP
/**
 * Leave feedback for a user
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/LeaveFeedback/LeaveFeedbackLogic.htm
 */
class Services_Ebay_Call_LeaveFeedback extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'LeaveFeedback';

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'TargetUser',
                                 'ItemId',
                                 'CommentType',
                                 'Comment',
                                 'TransactionId'
                                );
    
   /**
    * make the API call
    *
    * @param    object Services_Ebay_Session
    * @return   string  feedback ID
    */
    public function call(Services_Ebay_Session $session)
    {
        $return = parent::call($session);
        if ($return['LeaveFeedback']['Status'] === 'Success') {
            return $return['LeaveFeedback']['FeedbackId'];
        }
        return false;
    }
}
?>