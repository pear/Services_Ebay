<?PHP
/**
 * Model for a shipment
 *
 *
 * @package Services_Ebay
 * @author  Stephan Schmidt <schst@php.net>
 */
class Services_Ebay_Model_Shipment extends Services_Ebay_Model
{
   /**
    * default properties for a shipment
    *
    * @var  array
    */
    protected $properties = array(
                                    'CurrencyId'   => 1,
                                    'Transactions' => array()
                                );

   /**
    * set package dimemsions for the shipment
    *
    * @param    int     depth
    * @param    int     length
    * @param    int     width
    * @return   void
    */               
    public function SetPackageDimensions($Depth, $Length, $Width)
    {
        $this->properties['PackageDimensions'] = array(
                                                        'Depth'         => $Depth,
                                                        'Length'        => $Length,
                                                        'Width'         => $Width,
                                                        'UnitOfMeasure' => 1
                                                    );
    }
                                
   /**
    * add a transaction
    *
    * @param    string  item id
    * @param    string  transactio id
    * @return   void
    */               
    public function AddTransaction($ItemId, $TransactionId)
    {
        array_push($this->properties['Transactions'], array( 'ItemId' => $ItemId, 'TransactionId' => $TransactionId ));
    }

   /**
    * set the from address
    *
    * @param    string  company name
    * @param    string  name
    * @param    string  street, line 1
    * @param    string  street, line 2
    * @param    string  city
    * @param    string  zipcode
    * @param    string  state or province
    * @param    string  country
    * @param    string  phone number
    * @return   void
    */               
    public function SetFromAddress($CompanyName, $Name, $Street1, $Street2, $City, $Zip, $StateOrProvince, $Country, $Phone = null)
    {
        $this->properties['ShipFromAddress'] = array(
                                                        'CompanyName'     => $CompanyName,
                                                        'Name'            => $Name,
                                                        'Street1'         => $Street1,
                                                        'Street2'         => $Street2,
                                                        'City'            => $City,
                                                        'Zip'             => $Zip,
                                                        'StateOrProvince' => $StateOrProvince,
                                                        'Country'         => $Country,
                                                        'Phone'           => $Phone
                                                    );
    }

   /**
    * set the to address
    *
    * @param    string  type of the address
    * @param    string  company name
    * @param    string  name
    * @param    string  street, line 1
    * @param    string  street, line 2
    * @param    string  city
    * @param    string  zipcode
    * @param    string  state or province
    * @param    string  country
    * @param    string  phone number
    * @return   void
    */               
    public function SetAddress($Type, $CompanyName, $Name, $Street1, $Street2, $City, $Zip, $StateOrProvince, $Country, $Phone = null)
    {
        $this->properties['ShippingAddress'] = array(
                                                        'AddressType'     => $Type,
                                                        'CompanyName'     => $CompanyName,
                                                        'Name'            => $Name,
                                                        'Street1'         => $Street1,
                                                        'Street2'         => $Street2,
                                                        'City'            => $City,
                                                        'Zip'             => $Zip,
                                                        'StateOrProvince' => $StateOrProvince,
                                                        'Country'         => $Country,
                                                        'Phone'           => $Phone
                                                    );
    }
}
?>