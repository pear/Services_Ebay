<?PHP
/**
 * example that adds information to the item description
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

$item   = $ebay->GetItem(4501336808);
$result = $item->EndItem(1);

echo '<pre>';
print_r($result);
echo '</pre>';
?>