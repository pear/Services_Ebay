<?PHP
/**
 * Model for an eBay preference
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 */
class Services_Ebay_Model_Preferences extends Services_Ebay_Model
{
    /**
     * preferences
     * 
     * @var array
     */
    protected $preferences = array();

    /**
     * set of preferences
     * 
     * @var array
     */
    protected $preferenceSets = array();
    
   /**
    * create new preferences
    *
    *
    */
    public function __construct($props, $session = null)
    {
        if (is_string($props)) {
            $this->properties['Name'] = $props;	
        } elseif (is_array($props)) {
            if (isset($props['Name'])) {
                $this->properties['Name'] = $props['Name'];
            }
            if (isset($props['PreferenceRole'])) {
                $this->properties['PreferenceRole'] = $props['PreferenceRole'];
            }
            if (isset($props['Preference'])) {
                if (isset($props['Preference'][0])) {
                	$this->preferences = $props['Preference'];
                } else {
                    $this->preferences = array($props['Preference']);
                }
            }
            if (isset($props['Preferences'])) {
                if (isset($props['Preferences'][0])) {
                	$tmp = $props['Preferences'];
                } else {
                    $tmp = array($props['Preferences']);
                }
                foreach ($tmp as $set) {
                	$this->AddPreference(Services_Ebay::loadModel('Preferences', $set, $session));
                }
            }
        }
    }
    
   /**
    * add a new preference or preference set
    *
    * @param    string|object
    * @param    mixed
    * @param    string
    */
    public function AddPreference($Name, $Value = null, $ValueType = null )
    {
        if ($Name instanceof Services_Ebay_Model_Preferences) {
        	array_push($this->preferenceSets, $Name);
        } else {
            array_push($this->preferences, array(
                                                   'Name'      => $Name,
                                                   'Value'     => $Value,
                                                   'ValueType' => $ValueType
                                                )
                    );

        }
    }

   /**
    * creates an array for serialization
    *
    * @return   array
    */
    public function toArray()
    {
        $array = parent::toArray();
        if (!empty($this->preferences)) {
            $array['Preference']  = $this->preferences;
        }
        if (!empty($this->preferenceSets)) {
            $array['Preferences'] = array();
            foreach ($this->preferenceSets as $set) {
            	array_push($array['Preferences'], $set->toArray());
            }
        }
        
        return $array;
    }
}
?>