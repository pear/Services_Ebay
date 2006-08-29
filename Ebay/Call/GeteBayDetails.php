<?PHP
/**
 * Get Details about an eBay site
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GeteBayDetails/GeteBayDetailsLogic.htm
 */
class Services_Ebay_Call_GeteBayDetails extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GeteBayDetails';

   /**
    * compatibility level this method was introduced
    *
    * @var integer
    */
    protected $since = 437;

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                    'DetailName'
                                );
    
   /**
    * make the API call
    *
    * @param    object Services_Ebay_Session
    * @return   string
    */
    public function call(Services_Ebay_Session $session)
    {
        $returnElement = $this->args['DetailName'];
        $returnSubElements = str_replace('Details', '', $returnElement);
        $return = parent::call($session);
        if (!isset($return[$returnElement][0][$returnSubElements])) {
            $return[$returnElement][$returnSubElements] = array($return[$returnElement][$returnSubElements]);
        }
        return $return[$returnElement];
    }
}
?>
