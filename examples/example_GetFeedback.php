<?PHP
/**
 * example that fatches feedback of a user
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
 * get the summary
 */
echo 'Get only the summary<br />';
$feedback = $ebay->GetFeedback('loislane-74');
echo	"<pre>";
print_r($feedback->toArray());
echo	"</pre>";

/**
 * get the detailed feedback
 */
echo 'Get verbose feedback<br />';
$feedback = $ebay->GetFeedback('loislane-74', Services_Ebay::FEEDBACK_VERBOSE);
echo	"<pre>";
print_r($feedback->toArray());
echo	"</pre>";

foreach ($feedback as $entry) {
    echo $entry;
    echo "<br />";
}

echo 'Pick one feedback entry:<br />';
$entry = $feedback->getEntry(1);
echo	"<pre>";
print_r($entry->toArray());
echo	"</pre>";
?>