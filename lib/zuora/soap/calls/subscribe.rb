module Zuora
  module Soap
    module Calls
      module Subscribe
        def self.xml_builder
          # account, batch, payment_method, bill_to_contact, subscription
        end
      end
    end
  end
end

# rubocop:disable Metrics/LineLength
# <!-- sample subscribe call -->
# <ns2:subscribe>
# <ns2:subscribes>
# <ns2:Account>
# <ns1:AccountNumber>t-1246636315.4928</ns1:AccountNumber>
# <!-- Set AutoPay to true for automatic payments via Zuora -->
#    <ns1:AutoPay>false</ns1:AutoPay>
# <ns1:Batch>Batch1</ns1:Batch>
# <!-- Usually you will want BillCycleDay to be the same as when the subscription starts-->
#    <ns1:BillCycleDay>1</ns1:BillCycleDay>
# <!-- If you plan to set to set the BillCycleDay to 0, you must set the BcdSettingOption to 'AutoSet'  -->
# <ns2:BcdSettingOption>ManualSet</ns2:BcdSettingOption>
#    <ns1:CrmId>SFDC-1230273269317</ns1:CrmId>
# <ns1:Currency>USD</ns1:Currency>
#    <ns1:CustomerServiceRepName>CSR Dude</ns1:CustomerServiceRepName>
# <ns1:Name>Company XYZ, Inc.</ns1:Name>
# <ns1:PaymentTerm>Due Upon Receipt</ns1:PaymentTerm>
#    <ns1:PurchaseOrderNumber>PO-1230273269317</ns1:PurchaseOrderNumber>
# <ns1:SalesRepName>Sales Person</ns1:SalesRepName>
#   </ns2:Account>
# <ns2:PaymentMethod>
# <ns1:CreditCardAddress1>123 Main</ns1:CreditCardAddress1>
#    <ns1:CreditCardCity>San Francisco</ns1:CreditCardCity>
# <ns1:CreditCardCountry>United States</ns1:CreditCardCountry
#    <ns1:CreditCardExpirationMonth>1</ns1:CreditCardExpirationMonth>
# <ns1:CreditCardExpirationYear>2011</ns1:CreditCardExpirationYear>
#    <ns1:CreditCardHolderName>Test Name</ns1:CreditCardHolderName>
# <!-- Using test MasterCard number -->
# <ns1:CreditCardNumber>5105105105105100</ns1:CreditCardNumber>
#    <ns1:CreditCardPostalCode>94109</ns1:CreditCardPostalCode>
# <ns1:CreditCardState>California</ns1:CreditCardState>
#    <ns1:CreditCardType>MasterCard</ns1:CreditCardType>
# <ns1:Type>CreditCard</ns1:Type>
#   </ns2:PaymentMethod>
# <ns2:BillToContact>
# <ns1:Address1>123 Main</ns1:Address1>
#    <ns1:Address2>APT 1</ns1:Address2>
# <ns1:City>San Francisco</ns1:City>
#    <ns1:Country>United States</ns1:Country>
# <ns1:FirstName>Erik</ns1:FirstName>
#    <ns1:LastName>Nordstrom</ns1:LastName>
# <ns1:PostalCode>94109</ns1:PostalCode>
#    <ns1:State>California</ns1:State>
# <ns1:WorkEmail>test@email.com</ns1:WorkEmail>
#    <ns1:WorkPhone>4155551212</ns1:WorkPhone>
# </ns2:BillToContact>
#   <ns2:SubscribeOptions>
#    <ns2:GenerateInvoice>true</ns2:GenerateInvoice>
# <ns2:ProcessPayments>true</ns2:ProcessPayments>
#   </ns2:SubscribeOptions>
# <ns2:SubscriptionData>
# <ns2:Subscription>
# <ns1:AutoRenew>true</ns1:AutoRenew>
# <!-- See Working With Dates   - All datetimes are converted to GMT-08:00 -->
#     <ns1:ContractAcceptanceDate>2009-07-03</ns1:ContractAcceptanceDate>
# <ns1:ContractEffectiveDate>2009-07-03</ns1:ContractEffectiveDate>
#     <ns1:InitialTerm>12</ns1:InitialTerm>
# <ns1:Name>A-S00000020090703080755</ns1:Name>
#     <ns1:RenewalTerm>12</ns1:RenewalTerm>
# <ns1:ServiceActivationDate>2009-07-03</ns1:ServiceActivationDate>
#     <ns1:TermStartDate>2009-07-03</ns1:TermStartDate>
# </ns2:Subscription>
#    <ns2:RatePlanData>
#     <ns2:RatePlan>
#      <ns1:ProductRatePlanId>4028e6991f863ecb011fb8b7904141a6</ns1:ProductRatePlanId>
# <!-- No need for RatePlanCharges unless you want to specifically override the default prices, quantities and/or description-->
#     </ns2:RatePlan>
# </ns2:RatePlanData>
#   </ns2:SubscriptionData>
# </ns2:subscribes>
# </ns2:subscribe>
# rubocop:enable Metrics/LineLength
