<?php

$_provides['pluginClasses'] = array(
        'jojo_plugin_jojo_cart_checkout_userbased' => 'jojo Cart - User Based Checkout',
        'jojo_plugin_jojo_cart_checkout_userbased_edit' => 'jojo Cart - User Based Checkout: Edit Address',
        );


Jojo::registerURI("cart/checkout/edit/[id:integer]", 'jojo_plugin_jojo_cart_checkout_userbased_edit'); // "cart/checkout/edit/3"
Jojo::registerURI("cart/checkout/delete/[id:integer]", 'jojo_plugin_jojo_cart_checkout_userbased_delete'); // "cart/checkout/delete/3"


/* empty and refill the cart on user login to update pricing */
Jojo::addHook('action_after_login', 'action_after_login', 'jojo_cart_checkout_userbased');
Jojo::addHook('action_after_logout', 'action_after_logout', 'jojo_cart_checkout_userbased');



$_options[] = array(
    'id'          => 'freight_options',
    'category'    => 'Cart - Shipping',
    'label'       => 'Freight Options',
    'description' => 'Freight options to display during checkout',
    'type'        => 'checkbox',
    'default'     => 'Standard',
    'options'     => 'Standard,Quote,Forwarder',
    'plugin'      => 'jojo_cart_checkout_userbased'
);

$_options[] = array(
    'id'          => 'freight_description',
    'category'    => 'Cart - Shipping',
    'label'       => 'Freight Text',
    'description' => 'A description to display when freight is 0',
    'type'        => 'text',
    'default'     => 'Free',
    'options'     => '',
    'plugin'      => 'jojo_cart_checkout_userbased'
);

$_options[] = array(
    'id'          => 'freight_favouritesonly',
    'category'    => 'Cart - Shipping',
    'label'       => 'Ship to \'favourite\' countries only',
    'description' => 'Shipping destination form will only display countries ticked as favourite (shipping charges should still be set as NA for other regions for saved user addresses).',
    'type'        => 'radio',
    'default'     => 'no',
    'options'     => 'yes,no'
);

