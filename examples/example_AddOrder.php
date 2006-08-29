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

$order->CreatingUserRole = 'Buyer';
$order->PaymentMethods = 'None';
$order->Total = '60.0';
$order->ApplyShippingDiscount = 'true';
$order->InsuranceFee = '02.0';
$order->InsuranceOption = 'NotOffered';

$order->AddTransaction('4501333765', 0);
$order->AddTransaction('4501336808', 0);
$order->AddShippingServiceOption('12.12', 1, '40.0', '1.00', 1);
$order->AddInternationalShippingServiceOption(2376, 1, '40.0', 1, 'US');
$order->AddSalesTax('1.03', '1', 'true');

$result = $ebay->AddOrder($order);
?>
