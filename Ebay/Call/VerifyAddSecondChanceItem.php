<?PHP
/**
 * Verify a second chance item before adding it
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/VerifyAddSecondChanceItem/VerifyAddSecondChanceItemLogic.htm
 */

/**
 * This call is based on AddSecondChanceItem
 */
require_once SERVICES_EBAY_BASEDIR.'/Ebay/Call/AddSecondChanceItem.php';

 
/**
 * Verify an item before adding it
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/VerifyAddSecondChanceItem/VerifyAddSecondChanceItemLogic.htm
 */
class Services_Ebay_Call_VerifyAddSecondChanceItem extends Services_Ebay_Call_AddSecondChanceItem
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'VerifyAddSecondChanceItem';

   /**
    * make the API call
    *
    * @param    object Services_Ebay_Session
    * @return   array
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