<?PHP
/**
 * example that searches for items
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

$result = $ebay->GetSearchResults('NoteBook');

echo 'General information about the search result:<br />';
echo '<pre>';
print_r($result->toArray());
echo '</pre>';

echo 'Iterate through the found items<br />';
foreach ($result as $item) {
	echo $item;
	echo '<br />';
}
?>
