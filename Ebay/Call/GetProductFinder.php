<?PHP
/**
 * Get XSL stylesheet to transform product finder
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetProductFinder/GetProductFinderLogic.htm
 */
class Services_Ebay_Call_GetProductFinder extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetProductFinder';

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'ProductFinderId',
                                 'Version'
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
    * options that will be passed to the serializer
    *
    * @var  array
    */
    protected $serializerOptions = array(
                                            'mode' => 'simplexml'
                                        );

   /**
    * make the API call
    *
    * @param    object Services_Ebay_Session
    * @return   string
    */
    public function call(Services_Ebay_Session $session)
    {
        if (isset($this->args['ProductFinderId'])) {
            $ids = $this->args['ProductFinderId'];
            unset($this->args['ProductFinderId']);
            if (!is_array($ids)) {
            	$ids = array($ids);
            }
        	$this->args['ProductFinderIds']['ProductFinderId'] = $ids;
        }
        
        $xml = parent::call($session, false);
        $dom = DOMDocument::loadXML($xml);

        $result = array();
        $productFinders = $dom->getElementsByTagName('ProductFinder');
        foreach ($productFinders as $node) {
        	$result[] = Services_Ebay::loadModel('ProductFinder', $node, $session);
        }
        
        return $result;
    }
}
?>