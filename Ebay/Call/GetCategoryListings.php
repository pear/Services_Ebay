<?PHP
/**
 * Get category listing
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetCategoryListings/GetCategoryListingsLogic.htm
 */
class Services_Ebay_Call_GetCategoryListings extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetCategoryListings';

   /**
    * arguments of the call
    *
    * @var  array
    */
    protected $args = array(
                            'ItemsPerPage'   => 100,
                            'PageNumber'     => 1,
                            'ItemTypeFilter' => 0
                        );
   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'CategoryId',
                                 'ItemsPerPage',
                                 'PageNumber',
                                 'OrderBy',
                                 'ItemTypeFilter',
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
        return $return['Listings'];
    }
}
?>