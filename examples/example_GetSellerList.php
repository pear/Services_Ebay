<?PHP
/**
 * example that fetches a user object
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

/**
 * get the user information
 */
$list = $ebay->GetSellerList('agebook');

echo	'<pre>';
print_r($list->toArray());
echo	'</pre>';

echo 'Items:<br />';
foreach ($list as $item) {
    echo $item;
    echo '<br />';
}

echo	'<pre>';
print_r($item->toArray());
echo	'</pre>';

$item->Get();

echo	'<pre>';
print_r($item->toArray());
echo	'</pre>';
?>