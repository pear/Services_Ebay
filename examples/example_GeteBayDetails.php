<?PHP
/**
 * example that fetches information about a site
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


$details = $ebay->GeteBayDetails();
echo '<pre>';
print_r($details);
echo '</pre>';


$details = $ebay->GeteBayDetails('Currency');
echo '<pre>';
print_r($details);
echo '</pre>';
?>