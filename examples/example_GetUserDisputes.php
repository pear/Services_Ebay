<?PHP
/**
 * example that fetches all disputes the current user is involved in
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
$disputes = $ebay->GetUserDisputes(Services_Ebay::USER_DISPUTES_ALL, Services_Ebay::USER_DISPUTES_SORT_TIME_ASC);

echo '<pre>';
print_r($disputes->toArray());
echo '</pre>';

foreach ($disputes as $dispute) {
    echo '<pre>';
    print_r($dispute);
    echo '</pre>';
}
?>
