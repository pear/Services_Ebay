<?PHP
/**
 * example that fetches information on a dispute
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

$dispute = $ebay->GetDispute('997');

echo '<pre>';
print_r($dispute->toArray());
echo '</pre>';

foreach ($dispute as $message) {
	echo '<pre>';
	print_r($message);
	echo '</pre>';
}
?>