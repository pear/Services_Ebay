<?PHP
/**
 * example that fetches shipping rates
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

$session->debug = 2;

$rates = $ebay->GetShippingRates('95125', '02138', 0, 5, 0);

echo '<pre>';
print_r($rates);
echo '</pre>';
?>