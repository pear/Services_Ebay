<?PHP
/**
 * Verify an item before adding it
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/VerifyAddItem/VerifyAddItemLogic.htm
 */

/**
 * This call is based on AddItem
 */
require_once SERVICES_EBAY_BASEDIR.'/Ebay/Call/AddItem.php';

 
/**
 * Verify an item before adding it
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/VerifyAddItem/VerifyAddItemLogic.htm
 */
class Services_Ebay_Call_VerifyAddItem extends Services_Ebay_Call_AddItem
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'VerifyAddItem';

   /**
    * make the API call
    *
    * @param    object Services_Ebay_Session
    * @return   string
    */
    public function call(Services_Ebay_Session $session)
    {
        $return = Services_Ebay_Call::call($session);
        if (isset($return['Item'])) {
            return $return['Item'];
        }
        return false;
    }
}
?>