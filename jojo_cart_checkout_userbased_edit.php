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

class jojo_plugin_jojo_cart_checkout_userbased_edit extends JOJO_Plugin
{

    function _getContent()
    {
        /* Build list of countries for UI */
        $countries = array();
        $countries[] = array('code' => '', 'name' => 'Select country');
        $countries = array_merge($countries, Jojo::selectQuery("SELECT cc.countrycode as code, cc.name, 1 as special FROM {cart_country} as cc WHERE special = 'yes' ORDER BY name"));
        if (count($countries) > 1) {
            $countries[] = array('code' => '', 'name' => '----------');
        }
        $countries = array_merge($countries, Jojo::selectQuery("SELECT cc.countrycode as code, cc.name, 0 as special FROM {cart_country} as cc ORDER BY name"));

       /* get available freight types (specified in options)*/
        if (Jojo::getOption('freight_options', 'Standard')!='Standard') {
            $freightoptions = explode(',', Jojo::getOption('freight_options', 'Standard'));
            $smarty->assign('freightoptions', $freightoptions);
        }

        /* Cancel button pressed? */
        if (Jojo::getFormData('cancel')) {
            Jojo::redirect(_SITEURL . '/cart/checkout/');
        }

        /* Get addresses */
        $addressBook = jojo_plugin_jojo_cart_checkout_userbased::getAddressBook();
        $id = Jojo::getFormData('id', false);

        /* Address exists? */
        if (!isset($addressBook[$id])) {
            Jojo::redirect(_SITEURL . '/cart/checkout/');
        }

        /* Save button pressed? */
        if (Jojo::getFormData('save')) {
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
            if (!empty($new['email']) && !Jojo::checkEmailFormat($new['email'])) {
                $errors[] = 'Please enter a valid email address.';
            }

            $name= $new['firstname'].' '.$new['lastname'];
            if(strlen($name)>35) $errors[] = 'Please a firstname/lastname combination with max 35 characters please';

            if (count($errors)) {
                global $smarty;
                $smarty->assign('errors', $errors);
                $smarty->assign('address_id', $id);
                $smarty->assign('fields', $new);
                $smarty->assign('countries', $countries);

                $content = array();
                $content['title']      = 'Shipping and Billing Information';
                $content['content']    = $smarty->fetch('jojo_cart_checkout_userbased_edit.tpl');
                return $content;
            }

            jojo_plugin_jojo_cart_checkout_userbased::saveAddress($id, $new);
            Jojo::redirect(_SITEURL . '/cart/checkout/');
        }

        global $smarty;
        $smarty->assign('address_id', $id);
        $smarty->assign('fields', $addressBook[$id]);
        $smarty->assign('countries', $countries);
        $content = array();
        $content['title']      = 'Shipping and Billing Information';
        $content['content']    = $smarty->fetch('jojo_cart_checkout_userbased_edit.tpl');
        return $content;
    }

    function getCorrectUrl()
    {
        return _SITEURL . '/' . $_GET['uri'];
    }
}
