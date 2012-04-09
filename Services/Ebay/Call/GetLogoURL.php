<?PHP
/**
 * Get the logo URL
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetItemShipping/GetItemShippingLogic.htm
 */
class Services_Ebay_Call_GetLogoUrl extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetLogoURL';

   /**
    * arguments of the call
    *
    * @var  array
    */
    protected $args = array(
                            'Size' => 'Medium'
                        );

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'Size'
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
        return $return['Logo'];
    }
}
?>