<?PHP
/**
 * example that fetches shipping rates
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

$order = Services_Ebay::loadModel('Order');

$order->Currency = 1;
$order->CreatedBy = 2;
$order->Total = '60.0';

$order->AddTransaction('4501333765', 0);
$order->AddTransaction('4501336808', 0);
$order->AddShippingServiceOption(1, '40.0', 1);

$order->AcceptPaymentTerms('CCAccepted', 'PaymentOther');
$order->AcceptPaymentTerms('PayPalAccepted', 'VisaMaster');

$result = $ebay->AddOrder($order);
?>