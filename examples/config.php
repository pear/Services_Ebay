<?PHP
$devId  = '';

$appId  = '';

$certId = '';

$username = '';

$password = '';

$token = '';

if ($devId === '') {
    if (file_exists('config-local.php')) {
    	require_once 'config-local.php';
    }
}
if ($devId === '') {
    
    echo 'In order to use Services_Ebay, you must specify devId, appId, certId and a token.<br />';
    echo 'Please register at <a href="http://developer.ebay.com">http://developer.ebay.com</a> to get this IDs and then modify examples/config.php<br />';
    exit();
}
?>