<?PHP
/**
 * Test-script for bug 4296
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

$ebay = new Services_Ebay($session);

$item = Services_Ebay::loadModel('Item', null, $session);
$item->Category = 57882;
$item->Title = 'International Item';
$item->Description = 'This description contains Umlaut characters like Ä, ü and ß';
$item->Location = 'At my home';
$item->MinimumBid = '532.0';

$item->VisaMaster = 1;

$item->ShippingType = 1;
$item->CheckoutDetailsSpecified = 1;

$item->Country = 'US';

$item->SetShipToLocations(array('US', 'DE', 'GB'));

$item->addShippingServiceOption(1, 1, 3, 1, array('US'));

$result = $ebay->AddItem($item);

// You could as well call the Add() method on the item directly
//$result = $item->Add();


if ($result === true) {
    echo 'Item has been added with ItemId: '.$item->Id.' and ends on '.$item->EndTime.'<br />';
} else {
    echo 'An error occured while adding the item.';
}
?>
