<?PHP
/**
 * example that fetches the URL of the eBay logo
 * in three sizes.
 *
 * This call returns an array with the URL, width and height
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

echo "GetLogoURL('Small');<br />";
$logo = $ebay->GetLogoURL('Small');
echo sprintf('<img src="%s" width="%d" height="%d" title="This has been fetched from eBay" />', $logo['URL'], $logo['Width'], $logo['Height'] );
echo "<br /><br />";

echo "GetLogoURL('Medium');<br />";
$logo = $ebay->GetLogoURL('Medium');
echo sprintf('<img src="%s" width="%d" height="%d" title="This has been fetched from eBay" />', $logo['URL'], $logo['Width'], $logo['Height'] );
echo "<br /><br />";

echo "GetLogoURL('Large');<br />";
$logo = $ebay->GetLogoURL('Large');
echo sprintf('<img src="%s" width="%d" height="%d" title="This has been fetched from eBay" />', $logo['URL'], $logo['Width'], $logo['Height'] );
echo "<br /><br />";

echo "GetLogoURL();<br />";
$logo = $ebay->GetLogoURL();
echo sprintf('<img src="%s" width="%d" height="%d" title="This has been fetched from eBay" />', $logo['URL'], $logo['Width'], $logo['Height'] );
echo "<br /><br />";

echo "GetLogoURL(array('Size' => 'Small'));<br />";
$logo = $ebay->GetLogoURL(array('Size' => 'Small'));
echo sprintf('<img src="%s" width="%d" height="%d" title="This has been fetched from eBay" />', $logo['URL'], $logo['Width'], $logo['Height'] );
echo "<br /><br />";
?>