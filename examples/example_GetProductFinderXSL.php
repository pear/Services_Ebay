<?PHP
/**
 * example that fetches product finder XSL
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

// get one file, including XSL
$xslFiles = $ebay->GetProductFinderXSL('product_finder.xsl', 2);

echo '<pre>';
echo htmlentities($xslFiles[0]['Xsl']);
echo '</pre>';
?>