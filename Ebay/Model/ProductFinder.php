<?PHP
/**
 * Model for a product finder
 *
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 */
class Services_Ebay_Model_ProductFinder extends Services_Ebay_Model
{
   /**
    * stores the DOM document
    *
    * @var object
    */
    protected $dom = null;
    
   /**
    * create new model
    *
    * @param    array
    * @param    object
    */
    public function __construct($node, $session = null)
    {
        $this->dom = new DOMDocument();

        $ebay = new DOMElement('eBay');
        $ebay = $this->dom->appendChild($ebay);

        $pf = new DOMElement('ProductFinders');
        $pf = $ebay->appendChild($pf);

        $newNode = $this->dom->importNode($node, true);
        $pf->appendChild($newNode);
    }

   /**
    * render the product finder using an XSL stylesheet
    *
    * @access   public
    * @param    string      xsl stylesheet
    * @return   string      result of the transformation
    */
    public function render($xsl = null)
    {
        if (is_string($xsl)) {
            $xsl = DomDocument::loadXML($xsl);
        }

        $proc = new xsltprocessor;
        $proc->importStyleSheet($xsl);

        return $proc->transformToXML($this->dom);
    }
}
?>