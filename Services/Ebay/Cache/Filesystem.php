<?php
/**
 * Very simple filesystem cache
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 */

/**
 * load base class for caches
 */
require_once SERVICES_EBAY_BASEDIR . '/Ebay/Cache.php';

/**
 * Very simple filesystem cache
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 *
 * @todo    add some checks before writing files
 */
class Services_Ebay_Cache_Filesystem extends Services_Ebay_Cache 
{
   /**
    * load a model from cache
    *
    * @param    string      model type
    * @param    string      primary key
    * @param    integer     detail level
    * @return   array|boolean
    */
    public function load($Type, $Key, $DetailLevel)
    {
        $filename = $this->getCacheFilename($Type, $Key, $DetailLevel);
        if (!file_exists($filename)) {
        	return false;
        }
        if (!is_readable($filename)) {
        	return false;
        }
        
        // time the cache has been created
        $created = filemtime($filename);
        $props   = unserialize(file_get_contents($filename));
        
        // check validity
        if (!$this->isValid($Type, $created, $props)) {
        	return false;
        }
        
        // return the cache        
        return $props;
    }
    
   /**
    * store model data in the cache
    *
    * @param    string      model type
    * @param    string      primary key
    * @param    integer     detail level
    * @param    array       properties
    * @return   boolean
    */
    public function store($Type, $Key, $DetailLevel, $Props)
    {
        $filename = $this->getCacheFilename($Type, $Key, $DetailLevel);
    	return file_put_contents($filename, serialize($Props));
    }

   /**
    * get the name of the cache file
    *
    * @param    string      model type
    * @param    string      primary key
    * @param    integer     detail level
    * @return   string
    */
    private function getCacheFilename($Type, $Key, $DetailLevel)
    {
        return sprintf('%s/%s_%s_%s.cache',$this->options['path'], $Type, md5($Key), $DetailLevel);
    }
}
?>