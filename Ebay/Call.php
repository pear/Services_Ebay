<?PHP
/**
 * base class for API call objects
 *
 * $Id$
 *
 * @package     Services_Ebay
 * @author      Stephan Schmidt <schst@php.net>
 *
 * @todo        implement __toString()
 * @todo        allow rules for parameters
 */
abstract class Services_Ebay_Call
{
   /**
    * verb of the API call
    *
    * @var  string
    */
    protected $verb = null;

   /**
    * arguments of the call
    *
    * @var  array
    */
    protected $args = array();

   /**
    * authentication type of the call
    *
    * @var  int
    */
    protected $authType = Services_Ebay::AUTH_TYPE_TOKEN;

   /**
    * parameter map that is used, when scalar parameters are passed
    *
    * @var  array
    */
    protected $paramMap = array();

   /**
    * options that will be passed to the serializer
    *
    * @var  array
    */
    protected $serializerOptions = array();

   /**
    * options that will be passed to the unserializer
    *
    * @var  array
    */
    protected $unserializerOptions = array();

   /**
    * compatibility level this method was introduced
    *
    * @var  integer
    */
    protected $since = null;

   /**
    * deprecated since API version
    *
    * @var  integer
    */
    protected $deprecated = null;

   /**
    * constructor
    *
    * @param    array   arguments to the call
    */
    public function __construct($args = null)
    {
        if ($this->verb === null) {
            $this->verb = substr(get_class($this), 19);
        }

        // no arguments
        if (is_null($args)) {
            return;
        }
    
        // arguments have been passed as assoc array
        if (isset($args[0]) && is_array($args[0])) {
            $this->args = $args[0];
            return;
        }

        $cnt = count($args);
        if ($cnt > count($this->paramMap)) {
            throw new Services_Ebay_Exception('To many parameters have been passed');
        }

        for ($i = 0; $i < $cnt; $i++) {
            $this->args[$this->paramMap[$i]] = $args[$i];
        }
    }

   /**
    * make the API call
    *
    * @param  object Services_Ebay_Session
    * @param  boolean  flag to indicate, whether the result should be parsed using XML_Serializer
    * @return array
    */
    public function call(Services_Ebay_Session $session, $parseResult = true)
    {
        $session->setSerializerOptions($this->serializerOptions);
        $session->setUnserializerOptions($this->unserializerOptions);
        $return = $session->sendRequest($this->verb, $this->args, $this->authType, $parseResult);
        return $return;
    }
    
   /**
    * set arguments for the API call
    *
    * @param    array
    * @return   boolean
    */
    public function setArgs($args)
    {
        $this->args = $args;
        return true;
    }

   /**
    * set the detail level for this call
    *
    * @param    integer
    * @return   boolean
    */
    public function setDetailLevel($level)
    {
        $this->args['DetailLevel'] = $level;
        return true;
    }

   /**
    * describe the call
    *
    * This returns information about the possible parameters
    */
    public function describeCall()
    {
        echo 'API Call : '.$this->verb."\n";
        if ($this->since !== null) {
        	echo 'Added in API version : ' . $this->since . "\n";
        }
        if ($this->deprecated !== null) {
        	echo 'Deprecated in API version : ' . $this->deprecated . "\n";
        }
        echo "\n";
        echo 'Parameters (max. '.count($this->paramMap).')'."\n";
        $i = 0;
        foreach ($this->paramMap as $param) {
            echo ' '.++$i.'. '.$param;
            if (isset($this->args[$param])) {
                echo '('.$this->args[$param].')';
            } else {
                echo '(no default value)';
            }
            echo "\n";
        }
        $rc = new ReflectionClass($this);
        $dc = $rc->getDocComment();
        if (preg_match('/@link +(.+)/', $dc, $matches)) {
            echo 'API Documentation : '.$matches[1]."\n";            
        }
    }
}
?>