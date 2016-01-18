class Zuora::Models::Charge
  extend ValidationPredicates
  include SchemaModel

  schema :product_rate_plan_charge,
    product_rate_plan_charge_id: {
      type: String,
      doc: 'ID of a product rate-plan charge for
        this subscription.'
    },

    number: {
      type: String,
      doc: 'Unique number that identifies the charge.
          System-generated if not provided.',
      valid?: max_length(50)
    },

    description: {
      type: String,
      doc: 'Description of the charge.',
      valid?: max_length(500)
    },

    price: {
      type: Numeric, # currency,
      doc: 'Price for units in the subscription rate plan.'
    },

    tiers: {
      doc: 'Container for Volume, Tiered or Tiered
         with Overage charge models. Supports the
         following charge types:

         Recurring
         Usage-based',

      schema: [Zuora::Models::Tier],
      valid?: one_of(%w(Recurring Usage-based))
    },

    included_units: {
      doc: 'Specifies the number of units in the base set
       of units for this charge. Must be >=0.',
      valid?: min(0),
      type: Numeric # Long
    },

    overage_price: {
      doc: 'Price for units over the allowed amount.',
      type: Numeric # currency
    },

    list_price_base: {
      doc: 'The list price base for the product rate plan
        charge.',
      type: String,
      valid?: one_of(%w(Per_Billing_Period Per_Month Per_Week))
    },

    quantity: {
      required?: true,
      doc: 'Number of units. Must be >=0.',
      type: Numeric # decimal
    },

    discount_amount: {
      doc: 'Specifies the amount of fixed-amount discount.',
      type: Numeric
    },

    discount_percentage: {
      doc: 'Percentage of discount for a percentage discount.',
      type: Numeric
    },

    apply_discount_to: {
      doc: 'Specifies the type of charges that
you want a specific discount to apply to.',
      type: String,
      valid?: one_of(%w(
        ONETIME
        RECURRING
        USAGE
        ONETIMERECURRING
        ONETIMEUSAGE
        RECURRINGUSAGE
        ONETIMERECURRINGUSAG))

    },

    discount_level: {
      doc: 'Specifies if the discount applies to the product rate plan only,
        the entire subscription, or to any activity in the account.',
      type: String,
      valid?: one_of(%w(rateplan subscription account))
    },

    trigger_event: {
      doc: 'Specifies when to start billing the customer for the charge.',
      type: String,
      valid?: one_of(%w(UCE USA UCA USD))
    },

    trigger_date: {
      doc: 'Specifies when to start billing the customer for the charge.
         Required if the triggerEvent field is set to USD.',
      type: Date,
      required?: other_attr_eq(:trigger_event, 'USD')
    },

    end_date_condition: {
      type: String,
      doc: 'Defines when the charge ends after the charge trigger date.
If the subscription ends before the charge  end date, the charge
ends when the subscription ends. But if the subscription end date
is subsequently changed through a Renewal, or Terms and Conditions
amendment, the charge will end on the charge end date.
',
      valid?: one_of(%w(Subscription_End Fixed_Period Specific_End_Date))

    },

    up_to_periods_type: {
      doc: 'The period type used to define when the charge ends.
  You must use this field together with the upToPeriods
  field to specify the time period. This field is only applicable
 only when the endDateCondition field is set to Fixed_Period.

',
      type: String,
      valid?: one_of(%w(Billing_Periods Days Weeks Months Years))
    },

    up_to_periods: {
      type: Numeric,
      doc: 'You must use this field together with the upToPeriodsType field
to specify the time period.

 This field is only applicable only when the endDateCondition
 field is set to Fixed_Period.

 If the subscription end date is subsequently changed through a
Renewal, or Terms and Conditions amendment, the charge end date
  change accordingly up to the original period end.
'

    },

    specific_end_date: {
      doc: 'Defines when the charge ends after the charge trigger date.
       This field is only applicable when the endDateCondition field is
       set to Specific_End_Date.  If the subscription ends before the
       specific end date, the charge ends when the subscription ends.But if
       the subscription end date is subsequently changed through a Renewal, or
       Terms and Conditions amendment, the charge will end on the specific
       end date.',
      type: Date
    },

    billing_period: {
      doc: 'Billing period for the charge.The start day of the billing period
         is also called the bill cycle day (BCD).',
      valid?: one_of(%w(
        Month
        Quarter
        Semi_Annual
        Annual
        Eighteen_Months
        Two_Years
        Three_Years
        Five_Years
        Specific_Months
        Subscription_Term
        Week
        Specific_Weeks))
    },

    specific_billing_period: {
      doc: 'Specifies the number of month or week for the charges
         billing period.

         Required if you set the value of the billingPeriod field to
         Specific_Months or Specific_Weeks. The Specific_Weeks in the
         billingPeriod field is in Limited Availability.',
      type: Numeric
      # TODO: validation
    },

    billing_period_alignment: {
      doc: 'Aligns charges within the same subscription if multiple
          charges begin on different dates.',
      type: String,
      valid?: one_of(%w(AlignToCharge
                        AlignToSubscriptionStart
                        AlignToTermStart))
    },

    billing_timing: {
      doc: 'Billing timing for the charge for recurring charge types.
        Not available for one time, usage and discount charges.

        IN_ADVANCE (default)
        IN_ARREARS',
      type: String,
      valid?: one_of(%w(IN_ADVANCE IN_ARREARS))
    },

    rating_group: {
      type: String,
      valid?: one_of(%w(ByBillingPeriod
                        ByUsageStartDate
                        ByUsageRecord
                        ByUsageUpload)),
      doc: 'Specifies a rating group based on which usage records are rated.
        See Usages Rating by Group for more information.

        This feature is in Limited Availability.

        If you wish to have access to this feature, submit a request at
        Zuora Global Support.

        Values :

        ByBillingPeriod (default) : The rating is based on all the usages
                                    in a billing period.
        ByUsageStartDate : The rating is based on all the usages on
                           the same usage start date.
        ByUsageRecord : The rating is based on each usage record.
        ByUsageUpload : The rating is based on all the usages in a
                         uploaded usage file (.xls or.csv).

        Note :

        The ByBillingPeriod value can be applied for all charge models.
        The ByUsageStartDate, ByUsageRecord, and ByUsageUpload values can
        only be applied for per unit, volume pricing, and tiered pricing
        charge models.

        Use this field only for Usage charges.One-Time
        Charges and Recurring Charges return NULL.'
    },

    bill_cycle_type: {
      doc: 'Specifies how to determine the billing day for the charge.

        Set the BillCycleDay fieldwhen this field is set to
        SpecificDayofMonth.Set the weeklyBillCycleDay field when
        this field is set to SpecificDayOfWeek.',

      type: String,
      valid?: one_of(%w(DefaultFromCustomer SpecificDayofMonth
                        SubscriptionStartDay ChargeTriggerDay SpecificDayOfWeek))
    },

    bill_cycle_day: {
      doc: 'Sets the bill cycle day (BCD)
        for the charge.
        The BCD determines which day of the month customer is billed.',
      type: Numeric,
      valid?: -> (v) { (1..31).include? v }
    },

    number_of_periods: {
      doc: 'Specifies the number of periods to use when calculating charges
         in an overage smoothing charge model.',
      type: Numeric
    },

    overage_unused_units_credit_option: {
      doc: 'Determines whether to credit the customer with unused units of
            usage.',
      type: String,
      valid?: one_of(%w(NoCredit CreditBySpecificRate))
    },

    unused_units_credit_rates: {
      doc: 'Specifies the rate to credit a customer for unused units of usage.
        This field applies only for overage charge models when the
        OverageUnusedUnitsCreditOption field is set to CreditBySpecificRate.',

      type: Numeric # decimal
    },

    price_change_option: {
      type: String,
      valid?: one_of(%w(NoChange
                        SpecificPercentageValue
                        UseLatestProductCatalogPricing)),
      doc: 'Applies an automatic price change when a termed subscription is
       renewed.The Z-Billing Admin setting Enable Automatic Price Change
       When Subscriptions are Renewed? must be set to Yes to use this
       field. See Define Default Subscription Settings for more information
       on setting this option.

        NoChange (default)
        SpecificPercentageValue
        UseLatestProductCatalogPricing'
    },

    price_increase_percentage: {
      type: Numeric, # decimal
      valid?: -> (v) { v >= -100 && v <= 100 },
      doc: "Specifies the percentage to increase or decrease the price of a
        termed subscription's renewal. Required if you set the
        PriceChangeOption field to SpecificPercentageValue."
    },

    weekly_bill_cycle_day: {
      doc: 'Specifies which day of the week as the bill cycle day (BCD)
       for the charge',
      type: String,
      valid?: one_of(%w(Sunday
                        Monday
                        Tuesday
                        Wednesday
                        Thursday
                        Friday
                        Saturday))
    }
end
