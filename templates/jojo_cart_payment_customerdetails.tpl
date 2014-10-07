<div id ="cart-customerdetails">
    <h2>##Customer Details## <a class="btn btn-default btn-small pull-right" href="cart/checkout">##Change Shipping / Billing details##</a></h2>
    <div class="row">
        <div class="col-sm-6">
            <h5>##Shipping Address##</h5>
            <p>{$fields.shipping_firstname} {$fields.shipping_lastname}<br />
            {if $fields.shipping_company}{$fields.shipping_company}<br/>{/if}
            {if $fields.shipping_address1}{$fields.shipping_address1}<br/>{/if}
            {if $fields.shipping_address2}{$fields.shipping_address2}<br/>{/if}
            {if $fields.shipping_suburb}{$fields.shipping_suburb}<br/>{/if}
            {if $fields.shipping_city}{$fields.shipping_city}<br/>{/if}
            {if $fields.shipping_state}{$fields.shipping_state}{/if} {$fields.shipping_postcode}<br/>
            {foreach from=$countries item=country}{if !$found && $country.code|strtoupper==$fields.shipping_country}{$country.name}<br/>{/if}{/foreach}
            {if $fields.shipping_phone}{$fields.shipping_phone}<br/>{/if}
            {if $fields.shipping_email}{$fields.shipping_email}{/if}
            </p>
        </div>
        <div class="col-sm-6">
            <h5>##Billing Address##</h5>
            <p>{$fields.billing_firstname} {$fields.billing_lastname}<br />
            {if $fields.billing_company}{$fields.billing_company}<br/>{/if}
            {if $fields.billing_address1}{$fields.billing_address1}<br/>{/if}
            {if $fields.billing_address2}{$fields.billing_address2}<br/>{/if}
            {if $fields.billing_suburb}{$fields.billing_suburb}<br/>{/if}
            {if $fields.billing_city}{$fields.billing_city}<br/>{/if}
            {if $fields.billing_state}{$fields.billing_state}{/if} {$fields.billing_postcode}<br/>
            {foreach from=$countries item=country}{if !$found && $country.code|strtoupper==$fields.billing_country}{$country.name}<br/>{/if}{/foreach}
            {if $fields.billing_phone}{$fields.billing_phone}<br/>{/if}
            {if $fields.billing_email}{$fields.billing_email}{/if}
            </p>
        </div>
    </div>
</div>
