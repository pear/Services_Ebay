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
$version = '0.6.1';

/**
 * current state
 */
$state = 'devel';

/**
 * release notes
 */
$notes = <<<EOT
All models now support ArrayAccess, released during the PEAR talk at the PHP Conference 2004
EOT;

/**
 * package description
 */
$description = <<<EOT
Interface to eBay's XML-API. It provides objects that are able to
communicate with eBay as well as models that help you working with
the return values like User or Item models.
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

$package->addMaintainer('schst', 'lead', 'Stephan Schmidt', 'schst@php-tools.net');

$package->addDependency('PEAR', '1.3.2', 'ge', 'pkg', false);
$package->addDependency('XML_Serializer', '0.9.1', 'ge', 'pkg', false);
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