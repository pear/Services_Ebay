<?PHP
/**
 * Model for an eBay item
 *
 * $Id$
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 */
class Services_Ebay_Model_Item extends Services_Ebay_Model
{
   /**
    * model type
    *
    * @var  string
    */
    protected $type = 'Item';

   /**
    * property that stores the unique identifier (=pk) of the model
    *
    * @var string
    */
    protected $primaryKey = 'ItemID';

    /**
    * create new item
    *
    * @param    array   properties
    */
    public function __construct($props, $session = null)
    {
        if (is_array($props) && isset($props['Seller'])) {
            $props['Seller'] = Services_Ebay::loadModel('User', $props['Seller'], $session);
        }
        parent::__construct($props, $session);
    }

    public function __set($prop, $value)
    {
        $this->properties['Item'][$prop] = $value;
    }

   /**
    * set the locations you will ship the item to
    *
    * @param    array
    */
    public function setShipToLocations($ShipToLocations)
    {
        $this->properties['ShipToLocations'] = array(
        	                                          'ShipToLocation' => $ShipToLocations
        	                                        );
        return true;
    }

   /**
    * add a shipping service option
    *
    * @param    integer     shipping service, {@link http://developer.ebay.com/DevZone/docs/API_Doc/Appendixes/AppendixN.htm#shippingservices}
    * @param    integer     priority (1-3)
    * @param    float       cost for the item
    * @param    float       cost for an additional item
    * @return   boolean
    */
    public function addShippingServiceOption($ShippingService, $ShippingServicePriority, $ShippingServiceCost, $ShippingServiceAdditionalCost)
    {
        $option = array(
                        'ShippingService'               => $ShippingService,
                        'ShippingServicePriority'       => $ShippingServicePriority,
                        'ShippingServiceCost'           => $ShippingServiceCost,
                        'ShippingServiceAdditionalCost' => $ShippingServiceAdditionalCost,
                    );
        if (!isset($this->properties['ShippingServiceOptions'])) {
        	$this->properties['ShippingServiceOptions'] = array(
        	                                                      'ShippingServiceOption' => array()
        	                                                   );
        }
        array_push($this->properties['ShippingServiceOptions']['ShippingServiceOption'], $option);
        return true;
    }
    
   /**
    * add an international shipping service option
    *
    * @param    integer     shipping service, {@link http://developer.ebay.com/DevZone/docs/API_Doc/Appendixes/AppendixN.htm#shippingservices}
    * @param    integer     priority (1-3)
    * @param    float       cost for the item
    * @param    float       cost for an additional item
    * @param    array       locations for this shipping service options
    * @return   boolean
    */
    public function addInternationalShippingServiceOption($ShippingService, $ShippingServicePriority, $ShippingServiceCost, $ShippingServiceAdditionalCost, $ShipToLocations)
    {
        $option = array(
                        'ShippingService'               => $ShippingService,
                        'ShippingServicePriority'       => $ShippingServicePriority,
                        'ShippingServiceCost'           => $ShippingServiceCost,
                        'ShippingServiceAdditionalCost' => $ShippingServiceAdditionalCost,
                        'ShipToLocations'               => array(
                                                                'ShipToLocation' => $ShipToLocations
                                                                )
                    );
        if (!isset($this->properties['InternationalShippingServiceOptions'])) {
        	$this->properties['InternationalShippingServiceOptions'] = array(
        	                                                      'ShippingServiceOption' => array()
        	                                                   );
        }
        array_push($this->properties['InternationalShippingServiceOptions']['ShippingServiceOption'], $option);
        return true;
    }

   /**
    * create a string representation of the item
    *
    * @return   string
    */
    public function __toString()
    {
        if (isset($this->properties['Title'])) {
            return $this->properties['Title'] . ' (# '.$this->properties['ItemID'].')';
        }
        return '# '.$this->properties['ItemID'];
    }

   /**
    * get the item from eBay
    *
    * Use this to query by a previously set itemId.
    *
    * <code>
    * $item = Services_Ebay::loadModel('Item', null, $session);
    * $item->Id = 4501296414;
    * $item->Get();
    * </code>
    *
    * @param    int     DetailLevel
    * @param    int     DescFormat
    * @see      Services_Ebay_Call_GetItem
    */
    public function Get($DetailLevel = null, $DescFormat = 0)
    {
        $args = array(
                        'ItemID'        => $this->properties['Item']['Id'],
                        'DescFormat'    => $DescFormat
                    );
        if (!is_null($DetailLevel)) {
            $args['DetailLevel'] = $DetailLevel;
        }

        $call = Services_Ebay::loadAPICall('GetItem');
        $call->setArgs($args);
        
        $tmp = $call->call($this->session);
        $this->properties = $tmp->toArray();
        $this->eBayProperties = $this->properties;
        unset($tmp);
        return true;
    }

   /**
    * get cross promotions
    *
    * @param    int     DetailLevel
    * @param    int     DescFormat
    * @see      Services_Ebay_Call_GetCrossPromotions
    */
    public function GetCrossPromotions($PromotionMethod = 'CrossSell', $PromotionViewMode = null)
    {
        $args = array(
                        'ItemID'          => $this->properties['ItemID'],
                        'PromotionMethod' => $PromotionMethod
                    );
        if (!is_null($PromotionViewMode)) {
            $args['PromotionViewMode'] = $PromotionViewMode;
        }

        $call = Services_Ebay::loadAPICall('GetCrossPromotions');
        $call->setArgs($args);
        
        return $call->call($this->session);
    }
    
   /**
    * add text to the item description
    *
    * @param    string
    * @return   boolean
    * @see      Services_Ebay_Call_AddToItemDescription
    */
    public function AddToDescription($Description)
    {
        $args = array(
                        'ItemID'          => $this->properties['ItemID'],
                        'Description'     => $Description
                    );
        $call = Services_Ebay::loadAPICall('AddToItemDescription');
        $call->setArgs($args);
        
        return $call->call($this->session);
    }

   /**
    * and an auction
    *
    * @param    integer
    * @return   array
    * @see      Services_Ebay_Call_EndItem
    */
    public function End($EndCode)
    {
        $args = array(
                        'ItemID'  => $this->properties['ItemID'],
                        'EndCode' => $EndCode
                    );
        $call = Services_Ebay::loadAPICall('EndItem');
        $call->setArgs($args);
        
        return $call->call($this->session);
    }

   /**
    * Add the item to eBay
    *
    * This starts a new auction
    *
    * @see      Services_Ebay_Call_RelistItem
    */
    public function Add()
    {
        if (isset($this->properties['ItemID']) && !is_null($this->properties['ItemID'])) {
        	throw new Services_Ebay_Exception('This item already has an ItemId and thus cannot be added.');
        }
        $call = Services_Ebay::loadAPICall('AddItem', array($this));
        
        return $call->call($this->session);
    }

   /**
    * Re-list the item
    *
    * This adds a new auction with exactly the same item data
    *
    * @todo     check return value
    * @see      Services_Ebay_Call_RelistItem
    */
    public function Relist()
    {
        $args = array(
                        'ItemID'  => $this->properties['ItemID']
                    );
        $call = Services_Ebay::loadAPICall('RelistItem');
        $call->setArgs($args);
        
        return $call->call($this->session);
    }

   /**
    * Revise the item
    *
    * @return   boolean
    * @see      Services_Ebay_Call_ReviseItem
    */
    public function Revise()
    {
        $call = Services_Ebay::loadAPICall('ReviseItem', array($this));
        return $call->call($this->session);
    }

   /**
    * Add a second chance offer
    *
    * This adds a new auction with exactly the same item data
    *
    * @return   object Services_Ebay_Model_Item
    * @see      Services_Ebay_Call_AddSecondChanceItem
    */
    public function AddSecondChance($RecipientBidderUserId, $Duration = 'Days_3', $BuyItNowPrice = null)
    {
        $args = array(
                        'OriginalItemID'        => $this->properties['ItemID'],
                        'RecipientBidderUserID' => $RecipientBidderUserId,
                        'Duration'              => $Duration,
                    );
        if ($BuyItNowPrice !== null) {
        	$args['BuyItNowPrice'] = $BuyItNowPrice;
        }
        $call = Services_Ebay::loadAPICall('AddSecondChanceItem');
        $call->setArgs($args);
        
        return $call->call($this->session);
    }
}
?>
