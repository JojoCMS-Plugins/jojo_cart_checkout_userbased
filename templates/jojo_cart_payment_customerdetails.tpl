<h2>Customer Details</h2>
<div id ="cart-customerdetails">
    <div style="float: left; width: 50%; clear: left;">
        <strong>Shipping Address</strong><br/>
        {$fields.shipping_firstname} {$fields.shipping_lastname}<br />
        {if $fields.shipping_address1}{$fields.shipping_address1}<br/>{/if}
        {if $fields.shipping_address2}{$fields.shipping_address2}<br/>{/if}
        {if $fields.shipping_suburb}{$fields.shipping_suburb}<br/>{/if}
        {if $fields.shipping_city}{$fields.shipping_city}<br/>{/if}
        {if $fields.shipping_state}{$fields.shipping_state}{/if} {$fields.shipping_postcode}<br/>
        {section name=c loop=$countries}{if !$found && $countries[c].code|strtoupper==$fields.shipping_country}{$countries[c].name}{/if}{/section}
    </div>   
    <div style="float: left; width: 45%;">
        <strong>Billing Address</strong><br/>
        {$fields.billing_firstname} {$fields.billing_lastname} {if $fields.billing_email}&lt;{$fields.billing_email}&gt;{/if}<br />
        {if $fields.billing_address1}{$fields.billing_address1}<br/>{/if}
        {if $fields.billing_address2}{$fields.billing_address2}<br/>{/if}
        {if $fields.billing_suburb}{$fields.billing_suburb}<br/>{/if}
        {if $fields.billing_city}{$fields.billing_city}<br/>{/if}
        {if $fields.billing_state}{$fields.billing_state}{/if} {$fields.billing_postcode}<br/>
        {section name=c loop=$countries}{if !$found && $countries[c].code|strtoupper==$fields.billing_country}{$countries[c].name}{/if}{/section}
    </div>    
    <div style="clear: both;"></div>
</div>
<p><a class="cart-button" href="cart/checkout">Change Shipping / Billing details</a></p>
