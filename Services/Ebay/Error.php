<?php
/* vim: set expandtab tabstop=4 shiftwidth=4: */
// +----------------------------------------------------------------------+
// | PHP Version 4                                                        |
// +----------------------------------------------------------------------+
// | Copyright (c) 1997-2002 The PHP Group                                |
// +----------------------------------------------------------------------+
// | This source file is subject to version 2.0 of the PHP license,       |
// | that is bundled with this package in the file LICENSE, and is        |
// | available at through the world-wide-web at                           |
// | http://www.php.net/license/2_02.txt.                                 |
// | If you did not receive a copy of the PHP license and are unable to   |
// | obtain it through the world-wide-web, please send a note to          |
// | license@php.net so we can mail you a copy immediately.               |
// +----------------------------------------------------------------------+
// | Authors: Stephan Schmidt <schst@php.net>                             |
// +----------------------------------------------------------------------+
//
// $Id$

/**
 * Services/Ebay/Error.php
 *
 * Warning object
 *
 * @package  Services_Ebay
 * @author   Stephan Schmidt <schst@php.net>
 */

/**
 * Services_Ebay_Error
 *
 * Gives you access to an error returned by eBay
 *
 * @package  Services_Ebay
 * @author   Stephan Schmidt <schst@php.net>
 */
class Services_Ebay_Error
{
    private $code = null;
    private $severityCode = null;
    private $shortMessage = null;
    private $longMessage = null;

   /**
    * create a new error object
    *
    * @param array      error data
    */
    public function __construct($data)
    {
    	if (isset($data['ErrorCode'])) {
    		$this->code = (integer)$data['ErrorCode'];
    	}
    	if (isset($data['SeverityCode'])) {
    		$this->severityCode = $data['SeverityCode'];
    	}
    	if (isset($data['ShortMessage'])) {
    		$this->shortMessage = $data['ShortMessage'];
    	}
    	if (isset($data['LongMessage'])) {
    		$this->longMessage = $data['LongMessage'];
    	}
    }
    
   /**
    * return the error code
    *
    * @return int
    */
    public function getCode()
    {
        return $this->code;
    }

   /**
    * return the severity code
    *
    * @return int
    */
    public function getSeverityCode()
    {
        return $this->severityCode;
    }

   /**
    * return the short message
    *
    * @return string
    */
    public function getShortMessage()
    {
        return $this->shortMessage;
    }

   /**
    * return the short message
    *
    * @return string
    */
    public function getLongMessage()
    {
        return $this->longMessage;
    }
    
   /**
    * String overloading
    *
    * @return string
    */
    public function __toString()
    {
        return sprintf("Services_Ebay %s: %s (%d)\n", $this->getSeverityCode(), $this->getLongMessage(), $this->getCode());
    }
}
?>
