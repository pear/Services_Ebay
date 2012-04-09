<?PHP
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
 * Services/Ebay/Transport/Curl.php
 *
 * Send a request via Curl
 *
 * @package  Services_Ebay
 * @author   Stephan Schmidt <schst@php.net>
 */

/**
 * Services/Ebay/Transport/Curl.php
 *
 * Send a request via Curl
 *
 * @package  Services_Ebay
 * @author   Stephan Schmidt <schst@php.net>
 */
class Services_Ebay_Transport_Curl
{
   /**
    * send a request
    *
    * @access   public
    * @param    string  uri to send data to
    * @param    string  body of the request
    * @param    array   headers for the request
    * @return   mixed   either
    */
    function sendRequest( $url, $body, $headers )
    {
        $curl = curl_init($url);
        curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
        curl_setopt($curl, CURLOPT_POST, 1);
        curl_setopt($curl, CURLOPT_HTTPHEADER, $this->_createHeaders($headers));
        curl_setopt($curl, CURLOPT_POSTFIELDS, $body);
        curl_setopt($curl, CURLOPT_SSL_VERIFYPEER, false);
        curl_setopt($curl, CURLOPT_VERBOSE, 0);
        
        $result = curl_exec($curl);
        
        if ($result === false) {
            throw new Services_Ebay_Transport_Exception(curl_error( $curl ));
        }
        return $result;
    }

   /**
    * create the correct header syntax used by curl
    *
    * @access   private
    * @param    array       headers as supplied by Services_Ebay
    * @return   array       headers as needed by curl
    */
    function _createHeaders( $headers )
    {
        $tmp = array();
        foreach ($headers as $key => $value) {
            array_push($tmp, "$key: $value");
        }
        return $tmp;
    }
}
?>