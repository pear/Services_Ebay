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
 * get the user information
 */
$user = $ebay->GetUser('agebook');

/**
 * access single properties
 */
echo 'Display a the user ID: ';
echo $user->UserId."<br>";

/**
 * get all properties
 */
echo 'Display all properties: ';
echo '<pre>';
print_r($user->toArray());
echo '</pre>';

/**
 * get feedback summary
 */
echo 'Get the feedback for the user';
$summary = $user->getFeedback( Services_Ebay::FEEDBACK_BRIEF );
echo "This user's score is ".$summary->Score."<br />";

echo '<pre>';
print_r($summary->toArray());
echo '</pre>';
?>