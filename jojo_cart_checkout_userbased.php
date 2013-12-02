<?php
/**
 *                    Jojo CMS
 *                ================
 *
 * Copyright 2008 Harvey Kane <code@ragepank.com>
 * Copyright 2008 JojoCMS
 *
 * See the enclosed file license.txt for license information (LGPL). If you
 * did not receive this file, see http://www.fsf.org/copyleft/lgpl.html.
 *
 * @author  Harvey Kane <code@ragepank.com>
 * @author  Mike Cochrane <mikec@mikenz.geek.nz>
 * @license http://www.fsf.org/copyleft/lgpl.html GNU Lesser General Public License
 * @link    http://www.jojocms.org JojoCMS
 */

class jojo_plugin_jojo_cart_checkout_userbased extends JOJO_Plugin
{
    public static function getAddressBook()
    {
        global $_USERID;
        if (!$_USERID) {
            return array();
        }
        $row = Jojo::selectRow('SELECT checkout_addressbook FROM {user} WHERE userid = ?', $_USERID);
        if (!$row || !$row['checkout_addressbook']) {
            return array();
        }

        $data = unserialize($row['checkout_addressbook']);
        return isset($data['addressbook']) ? $data['addressbook'] : array();
    }

    public static function saveAddress($id, $details)
    {
        global $_USERID;
        if (!$_USERID) {
            return false;
        }
        $row = Jojo::selectRow('SELECT checkout_addressbook FROM {user} WHERE userid = ?', $_USERID);
        if ($row && $row['checkout_addressbook']) {
            $data = unserialize($row['checkout_addressbook']);
        } else {
            $data = array();
        }
        $data['addressbook'] = isset($data['addressbook']) ? $data['addressbook'] : array();

        /* Check all the fields are set */
        $fields = array('firstname', 'lastname', 'company', 'email', 'address1',
                        'address2', 'suburb', 'city', 'postcode', 'country');
        foreach($fields as $field) {
            $details[$field] = str_replace("\r\n", "\n", isset($details[$field]) ? $details[$field] : '');
        }

        /* Store it in the addressbook array */
        if ($id !== false && $id) {
            $data['addressbook'][$id] = $details;
        } else {
            $id = count($data['addressbook']) ? max(array_keys($data['addressbook'])) + 1 : 1;
            $data['addressbook'][$id] = $details;
        }

        /* Save it into the database */
        Jojo::updateQuery('UPDATE {user} SET checkout_addressbook = ? WHERE userid = ?', array(serialize($data), $_USERID));

        /* Return the id of the address book entry */
        return $id;
    }

    public static function deleteAddress($id)
    {
        global $_USERID;
        if (!$_USERID) {
            return false;
        }
        $row = Jojo::selectRow('SELECT checkout_addressbook FROM {user} WHERE userid = ?', $_USERID);
        if ($row && $row['checkout_addressbook']) {
            $data = unserialize($row['checkout_addressbook']);
        } else {
            $data = array();
        }
        $data['addressbook'] = isset($data['addressbook']) ? $data['addressbook'] : array();
        unset($data['addressbook'][$id]);

        /* Save it into the database */
        Jojo::updateQuery('UPDATE {user} SET checkout_addressbook = ? WHERE userid = ?', array(serialize($data), $_USERID));
    }

    function _getContent()
    {
        global $smarty, $_USERID, $_hooks;

        /* Get the cart array */
        $cart = call_user_func(array(Jojo_Cart_Class, 'getCart'));
        $smarty->assign('token', $cart->token);

        /* Build list of countries for UI */
        $countries = array();
        $select = array();
        $countries = Jojo::selectQuery("SELECT cc.countrycode as code, cc.name, cc.hasstates, 1 as special FROM {cart_country} as cc WHERE special = 'yes' ORDER BY name");
         /* Limit shipping countries to favourited only */
        if (Jojo::getOption('freight_favouritesonly', 'no')=='yes') {
            $smarty->assign('shippingcountries', $countries);
            if (count($countries)==1) {
                /* Check if State field is needed if only one country */
                $smarty->assign('shippingnostates', (boolean)(isset($countries[0]['hasstates']) && $countries[0]['hasstates'] == 'no'));
            }
        }
        if ($countries) {
            $countries = array_merge($countries, array(array('code' => '', 'name' => '----------')));
        }
        $countries = array_merge($countries, Jojo::selectQuery("SELECT cc.countrycode as code, cc.name, 0 as special FROM {cart_country} as cc ORDER BY name"));
        $countries = array_merge(array(array('code' => '', 'name' => 'Select country')), $countries); 
        $smarty->assign('countries', $countries);

         /* Check for generic login account (doesn't get an addressbook)*/
        if ($_USERID) {
            $user = Jojo::SelectRow("SELECT * FROM {user} WHERE userid =?", array($_USERID));
            $genericuser = ($user['generic']=='yes') ? true : false;
            $smarty->assign('genericuser', $genericuser);
            if (!$genericuser) {
                $smarty->assign('user', $user);
            }
        }

      /* get available freight types (specified in options)*/
        if (Jojo::getOption('freight_options', 'Standard')!='Standard') {
            $freightoptions = explode(',', Jojo::getOption('freight_options', 'Standard'));
            $smarty->assign('freightoptions', $freightoptions);
        }

        /* Add button pressed? */
        if (Jojo::getFormData('add')) {
            /* Save the new address */
            $new = Jojo::getFormData('new', array());


            /* Check for required fields */
            $requiredFields = array(
                'firstname' => 'Please enter your first name.',
                'lastname' => 'Please enter your last name.',
                'email' => 'Please enter your email address.',
                'address1' => 'Please enter your billing address.',
                'city' => 'Please enter your billing city.',
                'postcode' => 'Please enter your post code.',
                'country' => 'Please select your country.'
            );
            $errors = array();
            foreach($requiredFields as $name => $errorMsg) {
                if (!$new[$name]) {
                    $errors['new_' . $name] = $errorMsg;
                }
            }
            if (!empty($new['Email']) && !Jojo::checkEmailFormat($new['Email'])) {
                $errors[] = 'Please enter a valid email address.';
            }

            $name= $new['firstname'].' '.$new['lastname'];
            if(strlen($name)>35) $errors[] = 'Please a firstname/lastname combination with max 35 characters please';


            if (count($errors)) {
                /* There were errors, let the user fix them */
                foreach ($new as $k => $v) {
                    $cart->fields['new_' . $k] = $v;
                }

                $smarty->assign('errors', $errors);
                $content = array();
                $smarty->assign('fields', $cart->fields);
                $smarty->assign('addressbook', self::getAddressBook());
                $content['content']    = $smarty->fetch('jojo_cart_checkout_userbased.tpl');
                return $content;
            }

            /* Remove temp fields as we've saved them now */
            foreach($cart->fields as $k => $v) {
                if (substr($k, 0, 4) == 'new_') {
                    unset($cart->fields[$k]);
                }
            }

            /* Saving changes to an existing address? */
            if (isset($new['id'])) {
                $id = (strlen($new['id'])) ? $new['id'] : false;
                unset($new['id']);
            }
            self::saveAddress($id, $new);
        }

        /* Continue button not pressed */
        if (!Jojo::getFormData('continue')) {
            $content = array();
            $smarty->assign('addressbook', self::getAddressBook());
            $smarty->assign('fields', $cart->fields);
            $content['content']    = $smarty->fetch('jojo_cart_checkout_userbased.tpl');
            return $content;
        }


        if ($_USERID && !$genericuser) {
            if (!Jojo::getFormData('shipping') || !Jojo::getFormData('billing')) {
                $content = array();
                $smarty->assign('errors', array('Select a Billing and Shipping Address'));
                $smarty->assign('addressbook', self::getAddressBook());
                $content['content']    = $smarty->fetch('jojo_cart_checkout_userbased.tpl');
                return $content;
            }

            $addressbook = self::getAddressBook();
            foreach ($addressbook[Jojo::getFormData('shipping')] as $k => $v) {
                $cart->fields['shipping_' . $k] = $v;
              }
            foreach ($addressbook[Jojo::getFormData('billing')] as $k => $v) {
                $cart->fields['billing_' . $k] = $v;
            }
            /* Set the shipping region in the cart */
            $shippingRegion = self::locationToRegion($cart->fields['shipping_country'],
                                                     $cart->fields['shipping_state'],
                                                     $cart->fields['shipping_city']);
            call_user_func(array(Jojo_Cart_Class, 'setShippingRegion'), $shippingRegion);

            call_user_func(array(Jojo_Cart_Class, 'saveCart'));


            Jojo::redirect(_SECUREURL . '/cart/shipping/');


        } else {
            /* Get form values */
            $fields = array('billing_firstname', 'billing_lastname',
                'billing_email', 'billing_phone', 'billing_address1', 'billing_address2',
                'billing_suburb', 'billing_city', 'billing_state',
                'billing_postcode', 'billing_country', 'shipping_firstname',
                'shipping_lastname', 'shipping_email', 'shipping_phone', 'shipping_address1',
                'shipping_company', 'billing_company',
                'shipping_address2', 'shipping_suburb', 'shipping_city',
                'shipping_state', 'shipping_postcode', 'shipping_country',
                'shipping_freight_method', 'shipping_freight_company',
                'shipping_freight_accountno', 'shipping_freight_ordernumber');
            foreach($fields as $name) {
                $cart->fields[$name] = Jojo::getFormData($name, false);
            }
            call_user_func(array(Jojo_Cart_Class, 'saveCart'));

            /* Check for required fields */
            $requiredFields = array(
                'billing_firstname' => 'Please enter your first name.',
                'billing_lastname' => 'Please enter your last name.',
                'billing_email' => 'Please enter your email address.',
                'billing_address1' => 'Please enter your billing address.',
                'billing_city' => 'Please enter your billing city.',
                'billing_postcode' => 'Please enter your post code.',
                'billing_country' => 'Please select your country.',
                'shipping_firstname' => 'Please enter your first name.',
                'shipping_lastname' => 'Please enter your last name.',
                'shipping_email' => 'Please enter your email address.',
                'shipping_address1' => 'Please enter your shipping address.',
                'shipping_city' => 'Please enter your shipping city.',
                'shipping_postcode' => 'Please enter your post code.',
                'shipping_country' => 'Please select your country.',
            );
                if ($cart->fields['shipping_freight_method'] == 'forwarding') {
                    $requiredFields['shipping_freight_company'] = 'Please enter the name of your freight forwarder.';
                }

            $errors = array();
            foreach($requiredFields as $name => $errorMsg) {
                if (!$cart->fields[$name]) {
                    $errors[$name] = $errorMsg;
                }
            }

             if (!empty($cart->fields['billing_email']) && !Jojo::checkEmailFormat($cart->fields['billing_email'])) {
                $errors['billing_email'] = 'Please enter a valid email address.';
            }
            if (!empty($cart->fields['shipping_email']) && !Jojo::checkEmailFormat($cart->fields['shipping_email'])) {
                $errors['shipping_email'] = 'Please enter a valid email address.';
            }

            if (count($errors)) {
                /* There were errors, let the user fix them */
                $smarty->assign('errors', $errors);
                $content = array();
                $smarty->assign('fields', $cart->fields);
                $content['content']    = $smarty->fetch('jojo_cart_checkout_userbased.tpl');
                return $content;
            }

            /* Set the shipping region in the cart */
            $shippingRegion = self::locationToRegion($cart->fields['shipping_country'],
                                                     $cart->fields['shipping_state'],
                                                     $cart->fields['shipping_city']);
            call_user_func(array(Jojo_Cart_Class, 'setShippingRegion'), $shippingRegion);

            Jojo::redirect(_SECUREURL . '/cart/shipping/');
        }
    }

    /**
     * Convert the user shipping details to a freight region
     */
    private static function locationToRegion($country, $state, $city)
    {
        /* Try match city, state, country */
        $res = Jojo::selectRow('SELECT * FROM {cart_city} WHERE countrycode = ? AND statecode = ? and city = ?', array($country, $state, $city));
        if ($res && $res['region']) {
            return $res['region'];
        }

        /* Try match state and country */
        $res = Jojo::selectRow('SELECT * FROM {cart_state} WHERE countrycode = ? AND statecode = ?', array($country, $state));
        if ($res && $res['region']) {
            return $res['region'];
        }

        /* Try match country */
        $res = Jojo::selectRow('SELECT * FROM {cart_country} WHERE countrycode = ?', array($country));
        if ($res && $res['region']) {
            return $res['region'];
        }

        return '';
    }

/* empty and refill the cart on user login to update pricing */
    static function action_after_login()
    {
        $cart = call_user_func(array(Jojo_Cart_Class, 'getCart'));
        $products = $cart->items;
        unset($cart->items);

        foreach($products as $i => $p) {
            $code = $p['id'];
            $quantity = $p['quantity'];
            call_user_func(array(Jojo_Cart_Class, 'setQuantity'), $code, $quantity);
        }
        $_SESSION['loggingin'] = false;
        return true;
    }

/* empty the cart on user logout */
    static function action_after_logout()
    {
        call_user_func(array(Jojo_Cart_Class, 'emptyCart'));
        $_SESSION['loggingout'] = false;
        return true;
    }


    function getCorrectUrl()
    {
        return _SECUREURL.'/cart/checkout/';
    }
}
