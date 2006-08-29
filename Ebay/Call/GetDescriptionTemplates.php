<?PHP
/**
 * Get templates for item description
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 * @link    http://developer.ebay.com/DevZone/docs/API_Doc/Functions/GetDescriptionTemplates/GetDescriptionTemplatesLogic.htm
 * @todo    build some kind of model or container for the result, best would be some kind of mini templateing system.
 */
class Services_Ebay_Call_GetDescriptionTemplates extends Services_Ebay_Call 
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = 'GetDescriptionTemplates';

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array(
                                 'LastModifiedTime'
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
        return $return['DescriptionTemplate'];
    }
}
?>
