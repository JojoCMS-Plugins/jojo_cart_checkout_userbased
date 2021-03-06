$(document).ready(function(){
    if ($('#billing_country').val()) {
        updateCountry($('#billing_country').val(),  'billing');
    }
    if ($('#shipping_country').val()) {
        updateCountry($('#shipping_country').val(), 'shipping');
    }
    $('#billing_country').change(function(){
        updateCountry($(this).val(),  'billing');
    });
    $('#shipping_country').change(function(){
        updateCountry($(this).val(),  'shipping');
    });

});

function updateCountry(country, section) {
    if (!country) {
        return;
    }
    $.getJSON(secureurl + '/json/jojo_cart_country_hasstates.php', {c: country}, function(data) {
            if (data) {
                $('#' + section + '_state').removeAttr('disabled');
                updateCountryStates(country, section);
            } else {
                $('#' + section + '_state').attr('disabled', 'disabled');
            }
            updateCountryCities(country, section);
    });
}

function updateCountryCities(country, section) {
    $.getJSON(secureurl + '/json/jojo_cart_country_cities.php', {c: country}, function(data) {
            target = $('#' + section + '_city');
            if (!data.length) {
                var textbox = document.createElement('input');
                $(textbox).prop('type', 'text');
               $(textbox).attr('id', target.attr('id'));
                $(textbox).attr('name', target.attr('name'));
                $(textbox).addClass('form-control input text');
                if (target.val()) {
                    $(textbox).val(target.val());
                }
                target.replaceWith(textbox);
            } else {
                var selectbox = document.createElement('select');
                $(selectbox).attr('id', target.attr('id'));
                $(selectbox).attr('name', target.attr('name'));
                $(selectbox).addClass('form-control select');
                option = new Option('', '');
                selectbox.options.add(option);
                for (i = 0; i < data.length; i++) {
                    option = new Option(data[i], data[i]);
                    selectbox.options.add(option);
                }
                if (target.val()) {
                    $(selectbox).val(target.val());
                }
                target.replaceWith(selectbox);
            }
    });
}

function updateStateCities(country, state, section) {
    if (!country || !state) {
        return;
    }
    $.getJSON(secureurl + '/json/jojo_cart_state_cities.php', {c: country, s: state}, function(data) {
            target = $('#' + section + '_city');
            if (!data.length) {
                var textbox = document.createElement('input');
                $(textbox).prop('type', 'text');
                $(textbox).attr('id', target.attr('id'));
                $(textbox).attr('name', target.attr('name'));
                $(textbox).addClass('form-control input text');
                if (target.val()) {
                    $(textbox).val(target.val());
                }
                target.replaceWith(textbox);
            } else {
                var selectbox = document.createElement('select');
                $(selectbox).attr('id', target.attr('id'));
                $(selectbox).attr('name', target.attr('name'));
                $(selectbox).addClass('form-control select');
                option = new Option('', '');
                selectbox.options.add(option);
                for (i = 0; i < data.length; i++) {
                    option = new Option(data[i], data[i]);
                    selectbox.options.add(option);
                }
                if (target.val()) {
                    $(selectbox).val(target.val());
                }
                target.replaceWith(selectbox);
            }
    });
}

function updateCountryStates(country, section) {
    $.getJSON(secureurl + '/json/jojo_cart_country_states.php', {c: country}, function(data) {
            target = $('#' + section + '_state');
            if (!data.length) {
                var textbox = document.createElement('input');
                $(textbox).prop('type', 'text');
               $(textbox).attr('id', target.attr('id'));
                $(textbox).attr('name', target.attr('name'));
                $(textbox).addClass('form-control input text');
                if (target[0].tagName == 'INPUT' && target.val()) {
                    $(textbox).val(target.val());
                }
                target.replaceWith(textbox);
            } else {
                var selectbox = document.createElement('select');
                $(selectbox).attr('id', target.attr('id'));
                $(selectbox).attr('name', target.attr('name'));
                $(selectbox).addClass('form-control select');
                option = new Option('', '');
                selectbox.options.add(option);
                for (i = 0; i < data.length; i++) {
                    option = new Option(data[i]['state'], data[i]['statecode']);
                    selectbox.options.add(option);
                }
                $(selectbox).bind('change', function() {updateStateCities(country, $(this).val(), section);});
                if (target.val()) {
                    $(selectbox).val(target.val());
                }
                target.replaceWith(selectbox);
                updateStateCities(country, $(selectbox).val(), section)
            }

            target = $('#' + section + '_city');
            var textbox = document.createElement('input');
            $(textbox).prop('type', 'text');
            $(textbox).attr('id', target.attr('id'));
            $(textbox).attr('name', target.attr('name'));
            $(textbox).addClass('form-control input text');
            if (target.val()) {
                $(textbox).val(target.val());
            }
            target.replaceWith(textbox);
    });
}

function copyShippingToBilling() {
    $('#billing_firstname').val($('#shipping_firstname').val());
    $('#billing_lastname').val($('#shipping_lastname').val());
    $('#billing_email').val($('#shipping_email').val());
    $('#billing_address1').val($('#shipping_address1').val());
    $('#billing_address2').val($('#shipping_address2').val());
    $('#billing_suburb').val($('#shipping_suburb').val());
    $('#billing_city').val($('#shipping_city').val());
    $('#billing_state').val($('#shipping_state').val());
    $('#billing_postcode').val($('#shipping_postcode').val());
    $('#billing_country').val($('#shipping_country').val());
    $('#billing_phone').val($('#shipping_phone').val());
    updateCountry($('#billing_country').val(), 'billing');
}