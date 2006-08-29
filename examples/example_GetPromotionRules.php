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

$rules = $ebay->GetPromotionRules('UpSell', 110002463992);

echo '<pre>';
print_r($rules);
echo '</pre>';
?>
