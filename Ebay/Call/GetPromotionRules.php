<?PHP
/**
 * Get promotion rules
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetPromotionRules/GetPromotionRulesLogic.htm
 */
class Services_Ebay_Call_GetPromotionRules extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetPromotionRules';

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'PromotionMethod',
                                 'ItemId',
                                 'StoreCatId'
                                );
 
   /**
    * make the API call
    *
    * @param    object Services_Ebay_Session
    * @return   string
    */
    public function call(Services_Ebay_Session $session)
    {
        $this->args = array('Context' => $this->args);
        $return = parent::call($session);
        if (!empty($return['PromotionRules'])) {
            return $return['PromotionRules'];	
        }
        return array();
    }
}
?>