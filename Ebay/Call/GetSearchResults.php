<?PHP
/**
 * Get search results
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetSearchResults/GetSearchResultsLogic.htm
 */
class Services_Ebay_Call_GetSearchResults extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetSearchResults';

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'Query',
                                 'SearchInDescription',
                                 'Skip',
                                 'MaxResults',
                                 'Category'
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
        return Services_Ebay::loadModel('SearchResult', $return['Search'], $session);
    }
}
?>