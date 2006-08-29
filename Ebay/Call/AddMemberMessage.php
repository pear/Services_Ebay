<?PHP
/**
 * Add a message for an eBay member
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/AddMemberMessage/AddMemberMessageLogic.htm
 */
class Services_Ebay_Call_AddMemberMessage extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'AddMemberMessage';

   /**
    * compatibility level this method was introduced
    *
    * @var  integer
    */
    protected $since = 367;
    
   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'RecipientUserId',
                                 'MessageType',
                                 'QuestionType',
                                 'Subject',
                                 'Text',
                                 'ItemId',
                                 'DisplayToPublic',
                                 'EmailCopyToSender',
                                 'HideSendersEmailAddress'
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
        if ($return['Status'] === 'Success') {
        	return true;
        }
        return false;
    }
}
?>
