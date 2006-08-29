<?PHP
/**
 * example that fetches a members messages
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
$messageList = $ebay->GetMemberMessages('2005-01-01');

/**
 * some additional information about the message-list
 */
echo 'Number of entries: ' . $messageList->getNumberOfEntries() . '<br />';
echo 'Number of Pages: ' . $messageList->getNumberOfPages() . '<br />';
echo 'Has more items? ' . ($messageList->hasMoreItems() ? 'yes':'no') . '<br />';
/**
 * iterating through the messages in the message-list
 * 
 */
if ($messageList->getNumberOfEntries() > 0) {
    foreach ($messageList as $message) {
        echo '<pre> $message->toArray: ';
        print_r($message->toArray());
        echo '</pre>';
    }
} else {
    echo 'No messages in the message-list.';
}
?>
