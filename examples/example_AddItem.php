<?PHP
/**
 * example that fetches an item
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

$item = Services_Ebay::loadModel('Item', null, $session);
$item->Category = 57882;
$item->Title = 'Supergirls\'s cape';
$item->Description = 'Another test item';
$item->Location = 'At my home';
$item->MinimumBid = '1000.0';

$item->VisaMaster = 1;

$result = $ebay->AddItem($item);

// You could as well call the Add() method on the item directly
//$result = $item->Add();


if ($result === true) {
    echo 'Item has been added with ItemId: '.$item->Id.' and ends on '.$item->EndTime.'<br />';
} else {
    echo 'An error occured while adding the item.';
}
?>