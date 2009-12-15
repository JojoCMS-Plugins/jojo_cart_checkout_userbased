{if $cartisempty}
    <h3>No items to check out!</h3>
    <p>Your shopping cart is empty, please add iems to your cart before proceeding to the checkout.</p>
    {jojoHook hook="jojo_cart_empty"}
{else}

{if $loggedIn && !$genericuser }
    <div class="jojo_cart">
    {include file="jojo_cart_test_mode.tpl"}

    {if $errors}
        <div class="errors">
            <p>Please correct the following errors before continuing</p>
            <ul>
            {foreach from=$errors key=key item=errorMsg}
            {if is_numeric($key)}
              <li>{$errorMsg}</li>
            {/if}
            {/foreach}
            </ul>
        </div>
    {/if}

    <div class="box contact-form">
        <form method="post" action="cart/checkout/">
            <div id="shippingaddress">
                <h3>Shipping Address</h3>
    {foreach from=$addressbook key=id item=address name=address}
                <div style="float:left;"><p>
                    <input id="shipping_{$id}" type="radio" name="shipping" value="{$id}" {if $smarty.foreach.address.first}checked{/if} />
                    <label for="shipping_{$id}" style="margin-left: 10px; text-align: left; border: 1px solid white; padding: 5px;">
                        {if $address.firstname}{$address.firstname} {if $address.lastname}{$address.lastname}{/if}{if $address.email}<br />{$address.email}{/if}<br/>{/if}
                        {if $address.company}{$address.company}<br/>{/if}
                        {if $address.address1}{$address.address1}<br/>{/if}
                        {if $address.address2}{$address.address2}<br/>{/if}
                        {if $address.suburb}{$address.suburb}<br/>{/if}
                        {if $address.city}{$address.city}<br/>{/if}
                        {if $address.state}{$address.state}{/if} {$address.postcode}<br/>
                        {foreach from=$countries item=country}{if !$found && $country.code|strtoupper==$address.country && $country.special==1}{$country.name}{/if}{/foreach}</br>
    {if $address.freight_method == 'forwarding'}
                        <em>Using {$address.freight_company} for freight forwarding</em><br/>
    {/if}
                        <span class="addressbuttons" style="float:right; clear: both;">
                            <a class="cart-button" href="cart/checkout/edit/{$id}">Edit</a>
                            <a class="cart-button" href="cart/checkout/delete/{$id}" onclick="return confirm('Permanently delete this address?');">Delete</a>
                        </span>
                    </label>
                </p></div>
    {foreachelse}
                <p><em>You have no addresses in your addressbook, please add one below</em></p>
    {/foreach}
            </div>

            <div id="billingaddress" style="clear: both; padding-top: 10px;">
                <h3>Billing Address</h3>
    {foreach from=$addressbook key=id item=address name=address}
                <p style="float:left">
                    <input id="billing_{$id}" type="radio" name="billing" value="{$id}" {if $smarty.foreach.address.first}checked{/if} />
                    <label for="billing_{$id}" style="margin-left: 10px; text-align: left; border: 1px solid white; padding: 5px;">
                         {if $address.firstname}{$address.firstname} {if $address.lastname}{$address.lastname}{/if}{if $address.email}<br />{$address.email}{/if}<br/>{/if}
                        {if $address.company}{$address.company}<br/>{/if}
                        {if $address.address1}{$address.address1}<br/>{/if}
                        {if $address.address2}{$address.address2}<br/>{/if}
                        {if $address.suburb}{$address.suburb}<br/>{/if}
                        {if $address.city}{$address.city}<br/>{/if}
                        {if $address.state}{$address.state}{/if} {$address.postcode}<br/>
                        {section name=c loop=$countries}{if !$found && $countries[c].code|strtoupper==$address.country && $countries[c].special==1 }{$countries[c].name}{/if}{/section}</br>
                        <a class="addressbuttons cart-button" style="float:right" href="cart/checkout/edit/{$id}">Edit</a>
                    </label>
                </p>
    {foreachelse}
                <p><em>You have no addresses in your addressbook, please add one below</em></p>
    {/foreach}
            </div>

    {if count($addressbook)}
            <p style="clear: both;"><input type="submit" name="continue" value="Continue" class="button" /></p>
    {/if}
        </form>

    {if count($addressbook)}
        <p style="clear: both;"><a  class="cart-button" href="#" onclick="$('#newaddress').show(); $(this).hide(); return false;">Add new address</a></p>
    {/if}

        <div id="newaddress" style="clear:left; {if count($addressbook)}display: none;{/if}">
            <form method="post" action="cart/checkout/">
                <h3>Add Address</h3>

                <p>
                <label for="new_firstname">First name</label>
                <input type="text" size="20" name="new[firstname]" id="new_firstname" value="{if $fields.new_firstname}{$fields.new_firstname}{/if}" /> *<br />
    {if $errors.new_firstname}<span class="error">{$errors.new_firstname}</span><br/>{/if}

                <label for="new_lastname">Last name</label>
                <input type="text" size="20" name="new[lastname]" id="new_lastname" value="{if $fields.new_lastname}{$fields.new_lastname}{/if}" /> *<br />
    {if $errors.new_lastname}<span class="error">{$errors.new_lastname}</span><br/>{/if}

                <label for="new_company">Company Name</label>
                <input type="text" size="30" name="new[company]" id="new_company" value="{if $fields.new_company}{$fields.new_company}{/if}" /><br />
    {if $errors.new_company}<span class="error">{$errors.new_company}</span><br/>{/if}

                <label for="new_email">Email</label>
                <input type="text" size="30" name="new[email]" id="new_email" value="{if $fields.new_email}{$fields.new_email}{/if}" /> *<br />
    {if $errors.new_email}<span class="error">{$errors.new_email}</span><br/>{/if}

                <label for="new_country">Country</label>
                <select size="1" name="new[country]" id="new_country" onchange="updateCountry($(this).val(), 'new');">
                {assign var=found value=false}{foreach from=$countries item=country}
                    <option value="{$country.code|strtoupper}"{if !$found && $country.code|strtoupper==$fields.shipping_country} selected="selected"{assign var=found value=true}{/if}>{$country.name}</option>
                {/foreach}
                </select> *<br />
    {if $errors.new_country}<span class="error">{$errors.new_country}</span><br/>{/if}

                <label for="new_state">State</label>
                <input type="text" size="20" name="new[state]" id="new_state" value="{if $fields.new_state}{$fields.new_state}{/if}" /><br />
    {if $errors.new_state}<span class="error">{$errors.new_state}</span><br/>{/if}

                <label for="new_address1">Address 1</label>
                <input type="text" size="30" name="new[address1]" id="new_address1" value="{if $fields.new_address1}{$fields.new_address1}{/if}" /> *<br />
    {if $errors.new_address1}<span class="error">{$errors.new_address1}</span><br/>{/if}

                <label for="new_address2">Address 2</label>
                <input type="text" size="30" name="new[address2]" id="new_address2" value="{if $fields.new_address2}{$fields.new_address2}{/if}" /><br />
    {if $errors.new_address2}<span class="error">{$errors.new_address2}</span><br/>{/if}

                <label for="new_suburb">Suburb</label>
                <input type="text" size="20" name="new[suburb]" id="new_suburb" value="{if $fields.new_suburb}{$fields.new_suburb}{/if}" /><br />
    {if $errors.new_suburb}<span class="error">{$errors.new_suburb}</span><br/>{/if}

                <label for="new_city">City</label>
                <input type="text" size="20" name="new[city]" id="new_city" value="{if $fields.new_city}{$fields.new_city}{/if}" /> *<br />
    {if $errors.new_city}<span class="error">{$errors.new_city}</span><br/>{/if}

                <label for="new_postcode">Postcode</label>
                <input type="text" size="10" name="new[postcode]" id="new_postcode" value="{if $fields.new_postcode}{$fields.new_postcode}{/if}" /> *<br />
    {if $errors.new_postcode}<span class="error">{$errors.new_postcode}</span><br/>{/if}

                </p>
    {if $freightoptions}
                <h4>Shipping Option</h4>
                <p>
          {foreach from=$freightoptions item=fo}
            {if $fo=='Standard'}
                 <input type="radio" name="new[freight_method]" onchange="$('#new_freightforwarding').hide();" id="new_freight_method_standard" value="standard" {if $fields.new_freight_method == 'standard'}checked="checked"{/if}/><label style="margin-left: 10px; width: auto" for="new_freight_method_standard">Your shipping provider</label><br/>
            {/if}
            {if $fo=='Quote'}
                 <input type="radio" name="new[freight_method]" onchange="$('#new_freightforwarding').hide();" id="new_freight_method_quote" value="quote" {if $fields.new_freight_method == 'quote'}checked="checked"{/if}/><label style="margin-left: 10px; width: auto" for="new_freight_method_quote">Provide me with a freight quote</label><br/>
            {/if}
            {if $fo=='Forwarder'}
                <input type="radio" name="new[freight_method]" onchange="$('#new_freightforwarding').show();" id="new_freight_method_forwarding" value="forwarding" {if $fields.new_freight_method == 'forwarding'}checked="checked"{/if}/><label style="margin-left: 10px; width: auto" for="new_freight_method_forwarding">Use my freight forwarder</label><br/>
                </p>
                <p id="new_freightforwarding" {if $fields.new_freight_method != 'forwarding'}style="display:none"{/if}>
                    <label for="new_freight_company">Freight Company</label>
                    <input type="text" size="20" name="new[freight_company]" id="new_freight_company" value="{if isset($fields.new_freight_company)}{$fields.new_freight_company}{elseif $loggedIn}{$userrecord.us_firstname}{/if}" /><br />
    {if $errors.new_freight_company}<span class="error">{$errors.new_freight_company}</span><br/>{/if}

                    <label for="new_freight_accountno">Account Number</label>
                    <input type="text" size="20" name="new[freight_accountno]" id="new_freight_accountno" value="{$fields.new_freight_accountno}" /><br />
    {if $errors.new_freight_accountno}<span class="error">{$errors.new_freight_accountno}</span><br/>{/if}

                    <label for="new_freight_ordernumber">Order Number</label>
                    <input type="text" size="20" name="new[freight_ordernumber]" id="new_freight_ordernumber" value="{$fields.new_freight_ordernumber}" /><br />
    {if $errors.new_freight_ordernumber}<span class="error">{$errors.new_freight_ordernumber}</span><br/>{/if}
                </p>
             {/if}
          {/foreach}
     {/if}
               <p>
                    <br style="clear: both"/>
                    <input type="submit" class="button" name="add" value="Add"/>
                </p>
            </form>
        </div>
    </div>
    </div>
{else}
    <div class="jojo_cart">
    {include file="jojo_cart_test_mode.tpl"}

    {if $errors}
        <div class="errors">
            <p>Please correct the following errors before continuing</p>
            <ul>
                {foreach from=$errors key=key item=errorMsg}
                {if is_numeric($key)}
                  <li>{$errorMsg}</li>
                {/if}
                {/foreach}
            </ul>
        </div>
    {/if}

    <form method="post" action="cart/checkout/">
        <div class="box contact-form">
            <div style="float: left; width: 450px;">
                <h3>Shipping Address</h3>

                <label for="shipping_firstname">First name</label>
                <input type="text" size="20" name="shipping_firstname" id="shipping_firstname" value="{if $fields.shipping_firstname}{$fields.shipping_firstname}{/if}" /> *<br />
    {if $errors.shipping_firstname}<span class="error">{$errors.shipping_firstname}</span><br/>{/if}

                <label for="shipping_lastname">Last name</label>
                <input type="text" size="20" name="shipping_lastname" id="shipping_lastname" value="{if $fields.shipping_lastname}{$fields.shipping_lastname}{/if}" /> *<br />
    {if $errors.shipping_lastname}<span class="error">{$errors.shipping_lastname}</span><br/>{/if}

                <label for="shipping_company">Company Name</label>
                <input type="text" size="30" name="shipping_company" id="shipping_company" value="{if $fields.shipping_company}{$fields.shipping_company}{/if}" /><br />
    {if $errors.shipping_company}<span class="error">{$errors.shipping_company}</span><br/>{/if}

                <label for="shipping_email">Email</label>
                <input type="text" size="30" name="shipping_email" id="shipping_email" value="{if $fields.shipping_email}{$fields.shipping_email}{/if}" /> *<br />
    {if $errors.shipping_email}<span class="error">{$errors.shipping_email}</span><br/>{/if}

                <label for="shipping_country">Country</label>
                <select size="1" name="shipping_country" id="shipping_country" onchange="updateCountry($(this).val(), 'shipping');">
    {assign var=found value=false}{foreach from=$countries item=country}
                    <option value="{$country.code|strtoupper}"{if !$found && $country.code|strtoupper==$fields.shipping_country } selected="selected"{assign var=found value=true}{/if}>{$country.name}</option>
    {/foreach}
                </select> *<br />
    {if $errors.shipping_country}<span class="error">{$errors.shipping_country}</span><br/>{/if}

                <label for="shipping_state">State</label>
                <input type="text" size="20" name="shipping_state" id="shipping_state" value="{if $fields.shipping_state}{$fields.shipping_state}{/if}" /><br />
    {if $errors.shipping_state}<span class="error">{$errors.shipping_state}</span><br/>{/if}

                <label for="shipping_address1">Address 1</label>
                <input type="text" size="30" name="shipping_address1" id="shipping_address1" value="{if $fields.shipping_address1}{$fields.shipping_address1}{/if}" /> *<br />
    {if $errors.shipping_address1}<span class="error">{$errors.shipping_address1}</span><br/>{/if}

                <label for="shipping_address2">Address 2</label>
                <input type="text" size="30" name="shipping_address2" id="shipping_address2" value="{if $fields.shipping_address2}{$fields.shipping_address2}{/if}" /><br />
    {if $errors.shipping_address2}<span class="error">{$errors.shipping_address2}</span><br/>{/if}

                <label for="shipping_suburb">Suburb</label>
                <input type="text" size="20" name="shipping_suburb" id="shipping_suburb" value="{if $fields.shipping_suburb}{$fields.shipping_suburb}{/if}" /><br />
    {if $errors.shipping_suburb}<span class="error">{$errors.shipping_suburb}</span><br/>{/if}

                <label for="shipping_city">City</label>
                <input type="text" size="20" name="shipping_city" id="shipping_city" value="{if $fields.shipping_city}{$fields.shipping_city}{/if}" /> *<br />
    {if $errors.shipping_city}<span class="error">{$errors.shipping_city}</span><br/>{/if}

                <label for="shipping_postcode">Postcode</label>
                <input type="text" size="10" name="shipping_postcode" id="shipping_postcode" value="{if $fields.shipping_postcode}{$fields.shipping_postcode}{/if}" /> *<br />
    {if $errors.shipping_postcode}<span class="error">{$errors.shipping_postcode}</span><br/>{/if}


    {if $freightoptions}
                <h4>Shipping Option</h4>
                <p>
          {foreach from=$freightoptions item=fo}
            {if $fo=='Standard'}
                 <input type="radio" name="new[freight_method]" onchange="$('#new_freightforwarding').hide();" id="new_freight_method_standard" value="standard" {if $fields.new_freight_method == 'standard'}checked="checked"{/if}/><label style="margin-left: 10px; width: auto" for="new_freight_method_standard">Your shipping provider</label><br/>
            {/if}
            {if $fo=='Quote'}
                 <input type="radio" name="new[freight_method]" onchange="$('#new_freightforwarding').hide();" id="new_freight_method_quote" value="quote" {if $fields.new_freight_method == 'quote'}checked="checked"{/if}/><label style="margin-left: 10px; width: auto" for="new_freight_method_quote">Provide me with a freight quote</label><br/>
            {/if}
            {if $fo=='Forwarder'}
                    <input type="radio" name="new[freight_method]" onchange="$('#new_freightforwarding').show();" id="new_freight_method_forwarding" value="forwarding" {if $fields.new_freight_method == 'forwarding'}checked="checked"{/if}/><label style="margin-left: 10px; width: auto" for="new_freight_method_forwarding">Use my freight forwarder</label><br/>
                </p>
                <p id="new_freightforwarding" {if $fields.new_freight_method != 'forwarding'}style="display:none"{/if}>
                    <label for="new_freight_company">Freight Company</label>
                    <input type="text" size="20" name="new[freight_company]" id="new_freight_company" value="{if isset($fields.new_freight_company)}{$fields.new_freight_company}{elseif $loggedIn}{$userrecord.us_firstname}{/if}" /><br />
    {if $errors.new_freight_company}<span class="error">{$errors.new_freight_company}</span><br/>{/if}

                    <label for="new_freight_accountno">Account Number</label>
                    <input type="text" size="20" name="new[freight_accountno]" id="new_freight_accountno" value="{if $fields.new_freight_accountno}{$fields.new_freight_accountno}{/if}" /><br />
    {if $errors.new_freight_accountno}<span class="error">{$errors.new_freight_accountno}</span><br/>{/if}

                    <label for="new_freight_ordernumber">Order Number</label>
                    <input type="text" size="20" name="new[freight_ordernumber]" id="new_freight_ordernumber" value="{if $fields.new_freight_ordernumber}{$fields.new_freight_ordernumber}{/if}" /><br />
    {if $errors.new_freight_ordernumber}<span class="error">{$errors.new_freight_ordernumber}</span><br/>{/if}
                </p>
             {/if}
          {/foreach}
     {/if}

            </div>

            <div style="float: left; width: 450px;">
                <h3>Billing Address</h3>

                <input type="checkbox" value="same" id="same_as_shipping" onchange="if ($(this).attr('checked')) copyShippingToBilling();"/>
                <label for="same_as_shipping">Same as my shipping address</label><br />

                <label for="billing_firstname">First name</label>
                <input type="text" size="20" name="billing_firstname" id="billing_firstname" value="{if $fields.billing_firstname}{$fields.billing_firstname}{/if}" /> *<br />
    {if $errors.billing_firstname}<span class="error">{$errors.billing_firstname}</span><br/>{/if}

                <label for="billing_lastname">Last name</label>
                <input type="text" size="20" name="billing_lastname" id="billing_lastname" value="{if $fields.billing_lastname}{$fields.billing_lastname}{/if}" /> *<br />
    {if $errors.billing_lastname}<span class="error">{$errors.billing_lastname}</span><br/>{/if}

                <label for="billing_company">Company Name</label>
                <input type="text" size="30" name="billing_company" id="billing_company" value="{if $fields.billing_company}{$fields.billing_company}{/if}" /><br />
    {if $errors.billing_company}<span class="error">{$errors.billing_company}</span><br/>{/if}

                <label for="billing_email">Email</label>
                <input type="text" size="30" name="billing_email" id="billing_email" value="{if $fields.billing_email}{$fields.billing_email}{/if}" /> *<br />
    {if $errors.billing_email}<span class="error">{$errors.billing_email}</span><br/>{/if}

                <label for="billing_country">Country</label>
                <select size="1" name="billing_country" id="billing_country" onchange="updateCountry($(this).val(), 'billing');">
    {assign var=found value=false}{foreach from=$countries item=country}
                    <option value="{$country.code|strtoupper}"{if !$found && $country.code|strtoupper==$fields.billing_country} selected="selected"{assign var=found value=true}{/if}>{$country.name}</option>
    {/foreach}
                </select> *<br />
    {if $errors.billing_country}<span class="error">{$errors.billing_country}</span><br/>{/if}

                <label for="billing_state">State</label>
                <input type="text" size="20" name="billing_state" id="billing_state" value="{if $fields.billing_state}{$fields.billing_state}{/if}" /><br />
    {if $errors.billing_state}<span class="error">{$errors.billing_state}</span><br/>{/if}

                <label for="billing_address1">Address 1</label>
                <input type="text" size="30" name="billing_address1" id="billing_address1" value="{if $fields.billing_address1}{$fields.billing_address1}{/if}" /> *<br />
    {if $errors.billing_address1}<span class="error">{$errors.billing_address1}</span><br/>{/if}

                <label for="billing_address2">Address 2</label>
                <input type="text" size="30" name="billing_address2" id="billing_address2" value="{if $fields.billing_address2}{$fields.billing_address2}{/if}" /><br />
    {if $errors.billing_address2}<span class="error">{$errors.billing_address2}</span><br/>{/if}

                <label for="billing_suburb">Suburb</label>
                <input type="text" size="20" name="billing_suburb" id="billing_suburb" value="{if $fields.billing_suburb}{$fields.billing_suburb}{/if}" /><br />
    {if $errors.billing_suburb}<span class="error">{$errors.billing_suburb}</span><br/>{/if}

                <label for="billing_city">City</label>
                <input type="text" size="20" name="billing_city" id="billing_city" value="{if $fields.billing_city}{$fields.billing_city}{/if}" /> *<br />
    {if $errors.billing_city}<span class="error">{$errors.billing_city}</span><br/>{/if}

                <label for="billing_postcode">Postcode</label>
                <input type="text" size="10" name="billing_postcode" id="billing_postcode" value="{if $fields.billing_postcode}{$fields.billing_postcode}{/if}" /> *<br />
    {if $errors.billing_postcode}<span class="error">{$errors.billing_postcode}</span><br/>{/if}

    {jojoHook hook="jojo_cart_extra_fields"}
            </div>
            <p>
                <br style="clear: both"/>
                <input type="submit" class="button" name="continue" value="Continue"/>
            </p>
        </div>
    </form>
    </div>


    <script type='text/javascript'>{literal}
        updateCountry($('#billing_country').val(),  'billing');
        updateCountry($('#shipping_country').val(), 'shipping');
        updateCountry($('#new_country').val(), 'new');
    {/literal}</script>
{/if}
{/if}