<?PHP
/**
 * example that fetches information on a store
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

$store = $ebay->GetStoreDetails('usa5');

echo '<pre>';
print_r($store->toArray());
echo '</pre>';

foreach ($store as $cat) {
	echo '<pre>';
	print_r($cat);
	echo '</pre>';
}

$store2 = $ebay->GetStoreDetails('superman-74');
echo '<pre>';
print_r($store2->toArray());
echo '</pre>';
?>