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
                        {section name=c loop=$countries}{if !$found && $countries[c].code|strtoupper==$address.country && $countries[c].special==1}{$countries[c].name}{/if}{/section}</br>
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
                <input type="text" size="20" name="new[firstname]" id="new_firstname" value="{$fields.new_firstname}" /> *<br />
    {if $errors.new_firstname}<span class="error">{$errors.new_firstname}</span><br/>{/if}

                <label for="new_lastname">Last name</label>
                <input type="text" size="20" name="new[lastname]" id="new_lastname" value="{$fields.new_lastname}" /> *<br />
    {if $errors.new_lastname}<span class="error">{$errors.new_lastname}</span><br/>{/if}

                <label for="new_company">Company Name</label>
                <input type="text" size="30" name="new[company]" id="new_company" value="{$fields.new_company}" /><br />
    {if $errors.new_company}<span class="error">{$errors.new_company}</span><br/>{/if}

                <label for="new_email">Email</label>
                <input type="text" size="30" name="new[email]" id="new_email" value="{$fields.new_email}" /> *<br />
    {if $errors.new_email}<span class="error">{$errors.new_email}</span><br/>{/if}

                <label for="new_country">Country</label>
                <select size="1" name="new[country]" id="new_country" onchange="updateCountry($(this).val(), 'new');">
                {assign var=found value=false}{section name=c loop=$countries}
                    <option value="{$countries[c].code|strtoupper}"{if !$found && $countries[c].code|strtoupper==$fields.shipping_country} selected="selected"{assign var=found value=true}{/if}>{$countries[c].name}</option>
                {/section}
                </select> *<br />
    {if $errors.new_country}<span class="error">{$errors.new_country}</span><br/>{/if}

                <label for="new_state">State</label>
                <input type="text" size="20" name="new[state]" id="new_state" value="{$fields.new_state}" /><br />
    {if $errors.new_state}<span class="error">{$errors.new_state}</span><br/>{/if}

                <label for="new_address1">Address 1</label>
                <input type="text" size="30" name="new[address1]" id="new_address1" value="{$fields.new_address1}" /> *<br />
    {if $errors.new_address1}<span class="error">{$errors.new_address1}</span><br/>{/if}

                <label for="new_address2">Address 2</label>
                <input type="text" size="30" name="new[address2]" id="new_address2" value="{$fields.new_address2}" /><br />
    {if $errors.new_address2}<span class="error">{$errors.new_address2}</span><br/>{/if}

                <label for="new_suburb">Suburb</label>
                <input type="text" size="20" name="new[suburb]" id="new_suburb" value="{$fields.new_suburb}" /><br />
    {if $errors.new_suburb}<span class="error">{$errors.new_suburb}</span><br/>{/if}

                <label for="new_city">City</label>
                <input type="text" size="20" name="new[city]" id="new_city" value="{$fields.new_city}" /> *<br />
    {if $errors.new_city}<span class="error">{$errors.new_city}</span><br/>{/if}

                <label for="new_postcode">Postcode</label>
                <input type="text" size="10" name="new[postcode]" id="new_postcode" value="{$fields.new_postcode}" /> *<br />
    {if $errors.new_postcode}<span class="error">{$errors.new_postcode}</span><br/>{/if}

                </p>
    {if $freightoptions}
                <h4>Shipping Option</h4>
                <p>
          {section name=f loop=$freightoptions}
            {if $freightoptions[f]=='Standard'}
                 <input type="radio" name="new[freight_method]" onchange="$('#new_freightforwarding').hide();" id="new_freight_method_standard" value="standard" {if $fields.new_freight_method == 'standard'}checked="checked"{/if}/><label style="margin-left: 10px; width: auto" for="new_freight_method_standard">Your shipping provider</label><br/>
            {/if}
            {if $freightoptions[f]=='Quote'}
                 <input type="radio" name="new[freight_method]" onchange="$('#new_freightforwarding').hide();" id="new_freight_method_quote" value="quote" {if $fields.new_freight_method == 'quote'}checked="checked"{/if}/><label style="margin-left: 10px; width: auto" for="new_freight_method_quote">Provide me with a freight quote</label><br/>
            {/if}
            {if $freightoptions[f]=='Forwarder'}
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
          {/section}
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
                <input type="text" size="20" name="shipping_firstname" id="shipping_firstname" value="{$fields.shipping_firstname}" /> *<br />
    {if $errors.shipping_firstname}<span class="error">{$errors.shipping_firstname}</span><br/>{/if}

                <label for="shipping_lastname">Last name</label>
                <input type="text" size="20" name="shipping_lastname" id="shipping_lastname" value="{$fields.shipping_lastname}" /> *<br />
    {if $errors.shipping_lastname}<span class="error">{$errors.shipping_lastname}</span><br/>{/if}

                <label for="shipping_company">Company Name</label>
                <input type="text" size="30" name="shipping_company" id="shipping_company" value="{$fields.shipping_company}" /><br />
    {if $errors.shipping_company}<span class="error">{$errors.shipping_company}</span><br/>{/if}

                <label for="shipping_email">Email</label>
                <input type="text" size="30" name="shipping_email" id="shipping_email" value="{$fields.shipping_email}" /> *<br />
    {if $errors.shipping_email}<span class="error">{$errors.shipping_email}</span><br/>{/if}

                <label for="shipping_country">Country</label>
                <select size="1" name="shipping_country" id="shipping_country" onchange="updateCountry($(this).val(), 'shipping');">
    {assign var=found value=false}{section name=c loop=$countries}
                    <option value="{$countries[c].code|strtoupper}"{if !$found && $countries[c].code|strtoupper==$fields.shipping_country } selected="selected"{assign var=found value=true}{/if}>{$countries[c].name}</option>
    {/section}
                </select> *<br />
    {if $errors.shipping_country}<span class="error">{$errors.shipping_country}</span><br/>{/if}

                <label for="shipping_state">State</label>
                <input type="text" size="20" name="shipping_state" id="shipping_state" value="{$fields.shipping_state}" /><br />
    {if $errors.shipping_state}<span class="error">{$errors.shipping_state}</span><br/>{/if}

                <label for="shipping_address1">Address 1</label>
                <input type="text" size="30" name="shipping_address1" id="shipping_address1" value="{$fields.shipping_address1}" /> *<br />
    {if $errors.shipping_address1}<span class="error">{$errors.shipping_address1}</span><br/>{/if}

                <label for="shipping_address2">Address 2</label>
                <input type="text" size="30" name="shipping_address2" id="shipping_address2" value="{$fields.shipping_address2}" /><br />
    {if $errors.shipping_address2}<span class="error">{$errors.shipping_address2}</span><br/>{/if}

                <label for="shipping_suburb">Suburb</label>
                <input type="text" size="20" name="shipping_suburb" id="shipping_suburb" value="{$fields.shipping_suburb}" /><br />
    {if $errors.shipping_suburb}<span class="error">{$errors.shipping_suburb}</span><br/>{/if}

                <label for="shipping_city">City</label>
                <input type="text" size="20" name="shipping_city" id="shipping_city" value="{$fields.shipping_city}" /> *<br />
    {if $errors.shipping_city}<span class="error">{$errors.shipping_city}</span><br/>{/if}

                <label for="shipping_postcode">Postcode</label>
                <input type="text" size="10" name="shipping_postcode" id="shipping_postcode" value="{$fields.shipping_postcode}" /> *<br />
    {if $errors.shipping_postcode}<span class="error">{$errors.shipping_postcode}</span><br/>{/if}


    {if $freightoptions}
                <h4>Shipping Option</h4>
                <p>
          {section name=f loop=$freightoptions}
            {if $freightoptions[f]=='Standard'}
                 <input type="radio" name="new[freight_method]" onchange="$('#new_freightforwarding').hide();" id="new_freight_method_standard" value="standard" {if $fields.new_freight_method == 'standard'}checked="checked"{/if}/><label style="margin-left: 10px; width: auto" for="new_freight_method_standard">Your shipping provider</label><br/>
            {/if}
            {if $freightoptions[f]=='Quote'}
                 <input type="radio" name="new[freight_method]" onchange="$('#new_freightforwarding').hide();" id="new_freight_method_quote" value="quote" {if $fields.new_freight_method == 'quote'}checked="checked"{/if}/><label style="margin-left: 10px; width: auto" for="new_freight_method_quote">Provide me with a freight quote</label><br/>
            {/if}
            {if $freightoptions[f]=='Forwarder'}
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
          {/section}
     {/if}

            </div>

            <div style="float: left; width: 450px;">
                <h3>Billing Address</h3>

                <input type="checkbox" value="same" id="same_as_shipping" onchange="if ($(this).attr('checked')) copyShippingToBilling();"/>
                <label for="same_as_shipping">Same as my shipping address</label><br />

                <label for="billing_firstname">First name</label>
                <input type="text" size="20" name="billing_firstname" id="billing_firstname" value="{$fields.billing_firstname}" /> *<br />
    {if $errors.billing_firstname}<span class="error">{$errors.billing_firstname}</span><br/>{/if}

                <label for="billing_lastname">Last name</label>
                <input type="text" size="20" name="billing_lastname" id="billing_lastname" value="{$fields.billing_lastname}" /> *<br />
    {if $errors.billing_lastname}<span class="error">{$errors.billing_lastname}</span><br/>{/if}

                <label for="billing_company">Company Name</label>
                <input type="text" size="30" name="billing_company" id="billing_company" value="{$fields.billing_company}" /><br />
    {if $errors.billing_company}<span class="error">{$errors.billing_company}</span><br/>{/if}

                <label for="billing_email">Email</label>
                <input type="text" size="30" name="billing_email" id="billing_email" value="{$fields.billing_email}" /> *<br />
    {if $errors.billing_email}<span class="error">{$errors.billing_email}</span><br/>{/if}

                <label for="billing_country">Country</label>
                <select size="1" name="billing_country" id="billing_country" onchange="updateCountry($(this).val(), 'billing');">
    {assign var=found value=false}{section name=c loop=$countries}
                    <option value="{$countries[c].code|strtoupper}"{if !$found && $countries[c].code|strtoupper==$fields.billing_country} selected="selected"{assign var=found value=true}{/if}>{$countries[c].name}</option>
    {/section}
                </select> *<br />
    {if $errors.billing_country}<span class="error">{$errors.billing_country}</span><br/>{/if}

                <label for="billing_state">State</label>
                <input type="text" size="20" name="billing_state" id="billing_state" value="{$fields.billing_state}" /><br />
    {if $errors.billing_state}<span class="error">{$errors.billing_state}</span><br/>{/if}

                <label for="billing_address1">Address 1</label>
                <input type="text" size="30" name="billing_address1" id="billing_address1" value="{$fields.billing_address1}" /> *<br />
    {if $errors.billing_address1}<span class="error">{$errors.billing_address1}</span><br/>{/if}

                <label for="billing_address2">Address 2</label>
                <input type="text" size="30" name="billing_address2" id="billing_address2" value="{$fields.billing_address2}" /><br />
    {if $errors.billing_address2}<span class="error">{$errors.billing_address2}</span><br/>{/if}

                <label for="billing_suburb">Suburb</label>
                <input type="text" size="20" name="billing_suburb" id="billing_suburb" value="{$fields.billing_suburb}" /><br />
    {if $errors.billing_suburb}<span class="error">{$errors.billing_suburb}</span><br/>{/if}

                <label for="billing_city">City</label>
                <input type="text" size="20" name="billing_city" id="billing_city" value="{$fields.billing_city}" /> *<br />
    {if $errors.billing_city}<span class="error">{$errors.billing_city}</span><br/>{/if}

                <label for="billing_postcode">Postcode</label>
                <input type="text" size="10" name="billing_postcode" id="billing_postcode" value="{$fields.billing_postcode}" /> *<br />
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