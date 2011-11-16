<?PHP
/**
 * Test-script for bug 4181
 *
 * $Id$
 *
 * @package     Services_Ebay
 * @subpackage  Tests
 * @author      Stephan Schmidt
 */
require_once '../Ebay.php';
require_once '../examples/config-local.php';

$session = Services_Ebay::getSession($devId, $appId, $certId);
$session->setToken($token);

$session->setDebug(Services_Ebay_Session::DEBUG_PRINT);

$item = Services_Ebay::loadModel('Item', null, $session);

// set the item props
$item->AmEx = 1;
$item->BuyItNowPrice = 25.32;
$item->CashOnPickupAccepted = 1;
$item->Category = 2228;
$item->CheckoutDetailsSpecified = 1;
$item->CheckoutInstructions = 'This is  test of checkout Instructions';
$item->Counter = 1;
$item->Country = 'US';
$item->Currency = '$';
$item->Description = 'This book is awesome.';
$item->Duration = 10;
$item->InsuranceFee = 0.50;
$item->Location = 52556;
$item->MinimumBid = 1.50;
$item->Quantity = 1;
$item->ReservePrice = 5.30;
$item->ShippingType = 1;
$item->Title = 'Beggining CSS';
$item->Type = 1;
$item->setShipToLocations(array('US', 'UK', 'DE'));
$item->addShippingServiceOption(1, 1, 3, 1);

// add the item
try {
    $item->Add();
} catch (Exception $e) {
    echo "An exception has been thrown:<br />";
    echo $e;
    exit();
}

echo "<pre>";
echo "Checking for more errors\n";
foreach ($session->getErrors() as $error) {
	echo $error;
}
echo '</pre>';

echo '<pre>';
echo "Getting Item Properties:\n";
print_r($item->toArray());
echo '</pre>';
?>
