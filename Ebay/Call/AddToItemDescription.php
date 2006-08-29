<?PHP
/**
 * Add information to the item descriptions
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/AddToItemDescription/AddToItemDescriptionLogic.htm
 * @see     Services_Model_Item::AddToDescription()
 */
class Services_Ebay_Call_AddToItemDescription extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'AddToItemDescription';

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'ItemID',
                                 'Description'
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
        if ($return['AddToItemDescriptionResponse']['Ack'] === 'Success') {
            return true;
        }
        return false;
    }
}
?>
