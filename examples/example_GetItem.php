<?PHP
/**
 * example that fetches an item
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

$session = Services_Ebay::getSession($devId, $appId, $certId);

$session->setToken($token);

$ebay = new Services_Ebay($session);

$item = $ebay->GetItem(110002463992);
echo 'User-Id of the seller: '.$item->Seller->UserID.'<br />';
echo '<pre>';
print_r($item->toArray());
echo '</pre>';

$item_2 = Services_Ebay::loadModel('Item', null, $session);
$item_2->Id = 110002463987;
$res2 = $item_2->Get();
?>
