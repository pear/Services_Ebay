<?PHP
/**
 * example that fetches a user object
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

/**
 * get the bidder list
 */
echo 'Getting Bidder List directly:<br />';

$list = $ebay->GetBidderList('pgoodman123');
foreach ($list as $item) {
    echo $item;
    echo '<br />';
}

echo '<br /><br />';

/**
 * get the user
 */
$user = $ebay->GetUser('loislane-74');

echo 'Getting Bidder List on User object:<br />';
$list2 = $user->GetBidderList();
foreach ($list2 as $item) {
    echo $item;
    echo '<br />';
}
?>