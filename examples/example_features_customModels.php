<?PHP
/**
 * Example that uses a custom model for items
 *
 * $Id$
 *
 * @package     Services_Ebay
 * @subpackage  Examples
 * @author      Stephan Schmidt
 */
error_reporting(E_ALL);
require_once '../Ebay.php';
require_once 'config.php';

/**
 * load the default item model as we want to extend it.
 */
require_once '../Ebay/Model/Item.php';

/**
 * simple model class
 *
 * You may implement any additional methods you need
 * in your custom models.
 */
class myItem extends Services_Ebay_Model_Item
{
   /**
    * Dummy method
    *
    * This does not really do anything, but you can implement whatever you like
    * here...
    *
    */
    public function StoreItem()
    {
        echo "Now you could store the item data in your local database...";
    }
}

Services_Ebay::useModelClass('Item', 'myItem');

$session = Services_Ebay::getSession($devId, $appId, $certId);
$session->setToken($token);

$item = Services_Ebay::loadModel('Item', '4501296414', $session);

$item->Get();
$item->StoreItem();
?>