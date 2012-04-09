<?PHP
/**
 * Get XSL stylesheet to transform product finder
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetProductFinderXSL/GetProductFinderXSLLogic.htm
 */
class Services_Ebay_Call_GetProductFinderXSL extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetProductFinderXSL';

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'FileName',
                                 'Version',
                                );

   /**
    * arguments of the call
    *
    * @var  array
    */
    protected $args = array(
                            'DetailLevel' => 1
                        );

   /**
    * options that will be passed to the unserializer
    *
    * @var  array
    */
    protected $unserializerOptions = array(
                                            'parseAttributes' => true,
                                            'contentName'     => 'Xsl',
                                            'forceEnum'       => array('XslFile')
                                        );

   /**
    * make the API call
    *
    * @param    object Services_Ebay_Session
    * @return   string
    */
    public function call(Services_Ebay_Session $session)
    {
        $return = parent::call($session);

        $result = array();
        foreach ($return['ProductFinderXsl']['XslFile'] as $xsl) {
        	if (isset($xsl['Xsl'])) {
        		$xsl['Xsl'] = base64_decode($xsl['Xsl']);
        	}
        	array_push($result, $xsl);
        }
        return $result;
    }
}
?>