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

class jojo_plugin_jojo_cart_checkout_userbased_delete extends JOJO_Plugin
{
    function _getContent()
    {
        /* Delete addresses */
        $id = Jojo::getFormData('id', false);
        jojo_plugin_jojo_cart_checkout_userbased::deleteAddress($id);
        Jojo::redirect(_SITEURL . '/cart/checkout/');
    }

    function getCorrectUrl()
    {
        return _SITEURL . '/' . $_GET['uri'];
    }
}
