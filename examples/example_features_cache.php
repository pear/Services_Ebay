<?PHP
/**
 * Example that uses a custom model for items
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

/**
 * load the user model as we want to set a static cache
 */
require_once '../Ebay/Model/User.php';

$session = Services_Ebay::getSession($devId, $appId, $certId);
$session->setToken($token);

// build a filesystem cache
$userCache = Services_Ebay::loadCache('Filesystem', array('path' => './cache'));

// use a static expiry of 15 minutes
$userCache->setExpiry('Static', 15);

// use this cache for all user models
Services_Ebay_Model_User::setCache($userCache);

// load a new user model
$user = Services_Ebay::loadModel('User', 'superman-74', $session);

if ($user->isCached()) {
    echo 'data had been cached<br />';
    echo '<pre>';
    print_r($user->toArray());
    echo '</pre>';
} else {
    echo 'fetching user data from eBay<br />';
    $user->Get();

    echo '<pre>';
    print_r($user->toArray());
    echo '</pre>';
}
?>