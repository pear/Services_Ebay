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

$item = Services_Ebay::loadModel('Item');
$item->Category = 57882;
$item->Title = 'Supergirls\'s cape';
$item->Description = 'Another test item';
$item->Location = 'At my home';
$item->MinimumBid = '1000.0';

$item->VisaMaster = 1;

$result = $ebay->VerifyAddItem($item);

echo '<pre>';
print_r($result);
echo '</pre>';
?>