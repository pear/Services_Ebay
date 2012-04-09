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
 * Services/Ebay/Transport/Streams.php
 *
 * Send a request via streams and a simple file_get_contents
 *
 * @package  Services_Ebay
 * @author   Stephan Schmidt <schst@php.net>
 */

/**
 * Services/Ebay/Transport/Streams.php
 *
 * Send a request via streams and a simple file_get_contents
 *
 * @package  Services_Ebay
 * @author   Stephan Schmidt <schst@php.net>
 */
class Services_Ebay_Transport_Streams
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
        $headers['Content-Type'] = 'text/xml';
        $headers = implode("\r\n", $this->_createHeaders($headers));

        $opts = array(
                      'http' => array(
                                      'method'  => 'POST',
                                      'header'  => $headers,
                                      'content' => $body,
                                    )
                     );

        $context = stream_context_create($opts);

        $result = file_get_contents($url, false, $context);
        
        return $result;
    }

   /**
    * create the correct header syntax used by streams context
    *
    * @access   private
    * @param    array       headers as supplied by Services_Ebay
    * @return   array       headers as needed by stream_context_create
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