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

<form method="post" action="cart/checkout/edit/">
    <input type="hidden" name="id" value="{$address_id}" />
    <div class="box contact-form">
        <div id="newaddress" style="clear:left; {if count($addressbook)}display: none;{/if}">
            <h3>Edit Address</h3>

            <p>
                <label for="new_firstname">First name</label>
                <input type="text" size="20" name="new[firstname]" id="new_firstname" value="{$fields.firstname}" /> *<br />
    {if $errors.new_firstname}<span class="error">{$errors.new_firstname}</span><br/>{/if}

                <label for="new_lastname">Last name</label>
                <input type="text" size="20" name="new[lastname]" id="new_lastname" value="{$fields.lastname}" /> *<br />
    {if $errors.new_lastname}<span class="error">{$errors.new_lastname}</span><br/>{/if}

                <label for="new_company">Company Name</label>
                <input type="text" size="30" name="new[company]" id="new_company" value="{$fields.company}" /><br />
    {if $errors.new_company}<span class="error">{$errors.new_company}</span><br/>{/if}

                <label for="new_email">Email</label>
                <input type="text" size="30" name="new[email]" id="new_email" value="{$fields.email}" /> *<br />
    {if $errors.new_email}<span class="error">{$errors.new_email}</span><br/>{/if}

                <label for="new_country">Country</label>
                <select size="1" name="new[country]" id="new_country" onchange="updateCountry($(this).val(), 'new');">
                {assign var=found value=false}{foreach from=$countries item=c}
                    <option value="{$c.code|strtoupper}"{if !$found && $c.code|strtoupper==$fields.country} selected="selected"{assign var=found value=true}{/if}>{$c.name}</option>
                {/foreach}
                </select> *<br />
    {if $errors.new_country}<span class="error">{$errors.new_country}</span><br/>{/if}

                <label for="new_state">State</label>
                <input type="text" size="20" name="new[state]" id="new_state" value="{$fields.state}" /><br />
    {if $errors.new_state}<span class="error">{$errors.new_state}</span><br/>{/if}

                <label for="new_address1">Address 1</label>
                <input type="text" size="30" name="new[address1]" id="new_address1" value="{$fields.address1}" /> *<br />
    {if $errors.new_address1}<span class="error">{$errors.new_address1}</span><br/>{/if}

                <label for="new_address2">Address 2</label>
                <input type="text" size="30" name="new[address2]" id="new_address2" value="{$fields.address2}" /><br />
    {if $errors.new_address2}<span class="error">{$errors.new_address2}</span><br/>{/if}

                <label for="new_suburb">Suburb</label>
                <input type="text" size="20" name="new[suburb]" id="new_suburb" value="{$fields.suburb}" /><br />
    {if $errors.new_suburb}<span class="error">{$errors.new_suburb}</span><br/>{/if}

                <label for="new_city">City</label>
                <input type="text" size="20" name="new[city]" id="new_city" value="{$fields.city}" /> *<br />
    {if $errors.new_city}<span class="error">{$errors.new_city}</span><br/>{/if}

                <label for="new_postcode">Postcode</label>
                <input type="text" size="10" name="new[postcode]" id="new_postcode" value="{$fields.postcode}" /> *<br />
    {if $errors.new_postcode}<span class="error">{$errors.new_postcode}</span><br/>{/if}

            </p>
{if $freightoptions}
            <h4>Shipping Option</h4>
            <p>
      {foreach from=$freightoptions item=f}
        {if $f=='Standard'}
             <input type="radio" name="new[freight_method]" onchange="$('#new_freightforwarding').hide();" id="new_freight_method_standard" value="standard" {if $fields.new_freight_method == 'standard'}checked="checked"{/if}/><label style="margin-left: 10px; width: auto" for="new_freight_method_standard">Your shipping provider</label><br/>
        {/if}
        {if $f=='Quote'}
             <input type="radio" name="new[freight_method]" onchange="$('#new_freightforwarding').hide();" id="new_freight_method_quote" value="quote" {if $fields.new_freight_method == 'quote'}checked="checked"{/if}/><label style="margin-left: 10px; width: auto" for="new_freight_method_quote">Provide me with a freight quote</label><br/>
        {/if}
        {if $f=='Forwarder'}
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
                <input type="submit" name="save" class="button" value="Save"/>
                <input type="submit" name="cancel" class="button" value="Cancel"/>
            </p>
        </div>
    </div>
</form>
</div>

<script type='text/javascript'>{literal}
    updateCountry($('#new_country').val(),  'country');
{/literal}</script>
