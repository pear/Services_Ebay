<?PHP
/**
 * Get the logo URL
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Carsten Lucke <luckec@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/api_doc/Functions/GetMemberMessages/getmembermessageslogic.htm
 * @todo    perhaps this should be split into two wrapper-calls: GetMemberMessagesByItemId, GetMemberMessagesByDateRange
 */
class Services_Ebay_Call_GetMemberMessages extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetMemberMessages';

   /**
    * arguments of the call
    *
    * @var  array
    */
    protected $args = array(
                            'MailMessageType' => 'AskSellerQuestion'
                        );

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'StartCreationTime',
                                 'EndCreationTime',
                                 'ItemID',
                                 'MailMessageType',
                                 'DisplayToPublic',
                                 'Pagination',
                                 'MessageStatus'
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
        $result = Services_Ebay::loadModel('MemberMessageList', $return, $session);
        return $result;
    }
}
?>
