<?PHP
/**
 * example that shows how a call object is 
 * able to show its list of parameters
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

$call = Services_Ebay::loadAPICall('GetLogoURL');
echo '<pre>';
$call->describeCall();
echo '</pre>';
?>