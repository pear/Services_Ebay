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
    protected $properties = array(
                                    'CurrencyId'   => 1,
                                    'Transactions' => array()
                                );


                                
    public function SetPackageDimensions($Depth, $Length, $Width)
    {
        $this->properties['PackageDimensions'] = array(
                                                        'Depth'         => $Depth,
                                                        'Length'        => $Length,
                                                        'Width'         => $Width,
                                                        'UnitOfMeasure' => 1
                                                    );
    }
                                
    public function AddTransaction($ItemId, $TransactionId)
    {
        array_push($this->properties['Transactions'], array( 'ItemId' => $ItemId, 'TransactionId' => $TransactionId ));
    }

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