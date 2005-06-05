<?php
/**
 * script to automate the generation of the
 * package.xml file.
 *
 * $Id$
 *
 * @author      Stephan Schmidt <schst@php-tools.net>
 * @package     Services_Ebay
 * @subpackage  Tools
 */

/**
 * uses PackageFileManager
 */ 
require_once 'PEAR/PackageFileManager.php';

/**
 * current version
 */
$version = '0.12.0';

/**
 * current state
 */
$state = 'alpha';

/**
 * release notes
 */
$notes = <<<EOT
Services_Ebay now always encodes data in UTF-8, as requested by the eBay webservice. You can still use ISO-8859-1 encoding in your scripts as all encoding and decoding is done automatically.
If you like to switch off this feature, you can tell the session-object that your data already is UTF-8 encoded and that you want UTF-8 encoded data in return.
- Added new getErrors() method to Services_Ebay session which will return an array of Services_Ebay_Error objects containing information about all warnings and serious errors (schst)
- fixed bug #4181: Only serious errors will be thrown as exceptions (schst)
- fixed bug #4296: UTF-8 encoding (schst)
- fixed bug #4326: wrong variable name (schst)
- fixed bug #4420: wrong capitalization in example (amt)
EOT;

/**
 * package description
 */
$description = <<<EOT
Interface to eBay's XML-API. It provides objects that are able to communicate with eBay as well as models that help you working with the return values like User or Item models.
The Services_Ebay class provides a unified method to use all objects.
EOT;

$package = new PEAR_PackageFileManager();

$result = $package->setOptions(array(
    'package'           => 'Services_Ebay',
    'summary'           => 'Interface to eBay\'s XML-API.',
    'description'       => $description,
    'version'           => $version,
    'state'             => $state,
    'license'           => 'PHP License',
    'filelistgenerator' => 'cvs',
    'ignore'            => array('package.php', 'package.xml'),
    'notes'             => $notes,
    'simpleoutput'      => true,
    'baseinstalldir'    => 'Services',
    'packagedirectory'  => './',
    'dir_roles'         => array('docs' => 'doc',
                                 'examples' => 'doc',
                                 'tests' => 'test',
                                 )
    ));

if (PEAR::isError($result)) {
    echo $result->getMessage();
    die();
}

$package->addMaintainer('schst', 'lead', 'Stephan Schmidt', 'schst@php.net');
$package->addMaintainer('luckec', 'developer', 'Carsten Lucke', 'luckec@php.net');
$package->addMaintainer('amt', 'contributor', 'Adam Maccabee Trachtenberg', 'amt@php.net');

$package->addDependency('PEAR', '1.3.2', 'ge', 'pkg', false);
$package->addDependency('XML_Serializer', '0.16.0', 'ge', 'pkg', false);
$package->addDependency('php', '5.0.0', 'ge', 'php', false);
$package->addDependency('curl', '', 'has', 'ext', false);

if (isset($_GET['make']) || (isset($_SERVER['argv'][1]) && $_SERVER['argv'][1] == 'make')) {
    $result = $package->writePackageFile();
} else {
    $result = $package->debugPackageFile();
}

if (PEAR::isError($result)) {
    echo $result->getMessage();
    die();
}
?>