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

$item = $ebay->GetItem(4501333179);

echo 'User-Id of the seller: '.$item->Seller->UserId.'<br />';

echo '<pre>';
print_r($item->toArray());
echo '</pre>';

/**
 * to get the item description,
 * you must use Detail Level 2
 */
$item = $ebay->GetItem(4501333179, 2);

echo 'Get description of the item:<br />';
echo $item->Description;

echo 'You may also access properties using the array syntax:<br />';
echo $item['Description'];
?>