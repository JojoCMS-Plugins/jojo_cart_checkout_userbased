
Customer Details
================

Shipping Address
  {$fields.shipping_firstname} {$fields.shipping_lastname}
{if $fields.shipping_address1}  {$fields.shipping_address1}
{/if}
{if $fields.shipping_address2}  {$fields.shipping_address2}
{/if}
{if $fields.shipping_suburb}  {$fields.shipping_suburb}
{/if}
{if $fields.shipping_city}  {$fields.shipping_city}
{/if}
{if $fields.shipping_state}  {$fields.shipping_state}
{/if}
{if $fields.shipping_postcode}  {$fields.shipping_postcode}
{/if}
{section name=c loop=$countries}{if $countries[c].code|strtoupper==$fields.shipping_country}  {$countries[c].name}{/if}{/section}

{if $fields.shipping_freight_method == 'forwarding'}
  Using {$fields.shipping_freight_company} for freight forwarding
  Account Number: {$fields.shipping_freight_accountno}
  Order Number: {$fields.shipping_freight_ordernumber}
{/if}

Billing Address
  {$fields.billing_firstname} {$fields.billing_lastname} {if $fields.billing_email}<{$fields.billing_email}>{/if}

{if $fields.billing_address1}  {$fields.billing_address1}
{/if}
{if $fields.billing_address2}  {$fields.billing_address2}
{/if}
{if $fields.billing_suburb}  {$fields.billing_suburb}
{/if}
{if $fields.billing_city}  {$fields.billing_city}
{/if}
{if $fields.billing_state}  {$fields.billing_state}
{/if}
{if $fields.billing_postcode}  {$fields.billing_postcode}
{/if}
{section name=c loop=$countries}{if $countries[c].code|strtoupper==$fields.billing_country}  {$countries[c].name}{/if}{/section}
