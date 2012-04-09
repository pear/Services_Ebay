<?PHP
/**
 * Get suggested categories
 *
 * Use this to determine the best category for an
 * item you want to add
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetSuggestedCategories/GetSuggestedCategoriesLogic.htm
 */
class Services_Ebay_Call_GetSuggestedCategories extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetSuggestedCategories';

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'Query',
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
        return $return['SuggestedCategories'];
    }
}
?>