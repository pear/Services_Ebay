<?PHP
/**
 * Example that fetches a dutch auction's high bidders
 *
 * $Id$
 *
 * @package     Services_Ebay
 * @subpackage  Examples
 * @author      Carsten Lucke <luckec@php.net>
 */
error_reporting(E_ALL);
require_once '../Ebay.php';
require_once 'config.php';

$session = Services_Ebay::getSession($devId, $appId, $certId);

$session->setToken($token);

$ebay = new Services_Ebay($session);

$itemId = 4502096230;
$bidList = $ebay->GetHighBidders($itemId);

// output number of bids
echo sprintf('Number of bids: %d <br /><br />', $bidList->getCount());

// iterate through list of bidders
foreach ($bidList as $bid) {
    echo '<hr />';
    echo 'Time: ' . $bid->TimeBid . '<br />';
    echo 'Price: ' . $bid->MaxBid . ' ' . $bid->CurrencyId . '<br />';
    echo 'Quantity: ' . $bid->Quantity . '<br /><br />';
      
    $user = $bid->getBidder();
    echo '<pre> $user->toArray(): ';
    print_r($user->toArray());
    echo '</pre>';
}


?>