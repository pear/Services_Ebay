<?PHP
/**
 * Get cross promotions for an items
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetCrossPromotions/GetCrossPromotions.htm
 */
class Services_Ebay_Call_GetCrossPromotions extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetCrossPromotions';

   /**
    * arguments of the call
    *
    * @var  array
    */
    protected $args = array(
                            'PromotionMethod' => 'CrossSell'
                        );
   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'ItemId',
                                 'PromotionMethod',
                                 'PromotionViewMode'
                                );
   /**
    * make the API call
    *
    * @param    object Services_Ebay_Session
    * @return   string
    */
    public function call(Services_Ebay_Session $session)
    {
        $bak = $this->args;
        $this->args['Context'] = array();
        foreach ($this->paramMap as $param) {
            if (!isset($this->args[$param])) {
                continue;
            }
            $this->args['Context'][$param] = $this->args[$param];
            unset( $this->args[$param] );
        }
        
        $return = parent::call($session);
        $this->args = $bak;

        return $return['CrossPromotions'];
    }
}
?>