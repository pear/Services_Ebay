<?PHP
/**
 * example that adds a response to a dispute
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

$result = $ebay->SellerReverseDispute('997', Services_Ebay::DISPUTE_REVERSE_OTHER);

if ($result === true) {
	echo 'Dispute has been reversed.';
} else {
    echo 'An error occured';
}
?>