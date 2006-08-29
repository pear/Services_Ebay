<?PHP
/**
 * example that fetches a unique RuName
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

$session->setAuthenticationData($username, $password);

$ebay = new Services_Ebay($session);
echo 'Getting RuName...';
$RuName = $ebay->GetRuName('MyUseCase');
echo $RuName.'<br />';

$result = $ebay->SetReturnURL($RuName, 'add', 'https://foo.de/accept/', 'https://foo.de/reject');
echo 'Setting Return URL...';

$result = $ebay->GetReturnURL();
echo '<pre>';
print_r($result);
echo '</pre>';
?>
