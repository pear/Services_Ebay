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
 * Services/Ebay/Transport/HttpRequest.php
 *
 * Send a request via PEAR::HTTP_Request
 *
 * @package  Services_Ebay
 * @author   Stephan Schmidt <schst@php.net>
 */
 
/**
 * needs HTTP_Request
 */
require_once 'HTTP/Request.php';
 
/**
 * Services/Ebay/Transport/HttpRequest.php
 *
 * Send a request via PEAR::HTTP_Request
 *
 * @package  Services_Ebay
 * @author   Stephan Schmidt <schst@php.net>
 */
class Services_Ebay_Transport_HttpRequest
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
        $params  = array(
                         'method'  => 'POST',
                         'timeout' => 30
                        );
        $request = new HTTP_Request($url);
        
        foreach ($headers as $name => $value) {
            $request->addHeader($name, $value);
        }
        $request->addRawPostData($body);

        $result = $request->sendRequest();
        if (PEAR::isError($result)) {
            throw new Services_Ebay_Transport_Exception('Could not send request.');
        }
        
        $response = $request->getResponseBody();
        return $response;
    }
}
?>