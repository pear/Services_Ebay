<?PHP
/**
 * example that makes use of the Exception handling
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

try {
    $foo = $ebay->UnknownMethod('foo');
} catch (Services_Ebay_Exception $e) {
    echo 'An error occured: '.$e->getMessage();
}
?>