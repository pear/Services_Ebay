<?PHP
/**
 * example that adds a shipment
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

$shipment = Services_Ebay::loadModel('Shipment');

$shipment->InsuredValue = 400;
$shipment->PayPalShipmentId = '12345678';
$shipment->PostageTotal = 3;
$shipment->PrintedTime = date('Y-m-d H:i:s');

$shipment->ShippingServiceUsed = 3;

$shipment->ShippingPackage = 0;
$shipment->setPackageDimensions(10, 5, 8);

$shipment->ShipmentTrackNumber = uniqid('shipment');

$shipment->SetFromAddress('Foobar', 'Clark Kent', 'Any Street 123', null, 'San Francisco', '94101', 'CA', 'USA');
$shipment->SetAddress(2, 'Foobar', 'Clark Kent', 'Any Street 456', null, 'San Francisco', '94101', 'CA', 'USA');

$shipment->AddTransaction(4501333179, 0);

$shipment->InsuredValue = '450.00';
$shipment->ShippingCarrierUsed = 1;
$shipment->WeightMajor = 2;
$shipment->WeightMinor = 0;
$shipment->WeightUnit = 1;

$session->debug = 2;

$ebay->AddShipment($shipment);
?>