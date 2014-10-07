<?php
/**
 *                    Jojo CMS
 *                ================
 *
 * Copyright 2008 Harvey Kane <code@ragepank.com>
 * Copyright 2008 Michael Holt <code@gardyneholt.co.nz>
 *
 * See the enclosed file license.txt for license information (LGPL). If you
 * did not receive this file, see http://www.fsf.org/copyleft/lgpl.html.
 *
 * @author  Harvey Kane <code@ragepank.com>
 * @license http://www.fsf.org/copyleft/lgpl.html GNU Lesser General Public License
 * @link    http://www.jojocms.org JojoCMS
 */

// Shopping Cart Checkout
$data = Jojo::selectRow("SELECT pageid FROM {page} WHERE pg_link = ?", array('jojo_plugin_jojo_cart_checkout_userbased'));
if (!$data) {
   echo "Adding <b>Shopping Cart Checkout</b> Page to menu<br />";
   Jojo::insertQuery('INSERT INTO {page} SET pg_title = ?, pg_url = ?, pg_link = ?, pg_order = ?, pg_index = ?, pg_followto = ?, pg_contentcache = ?, pg_mainnav = ?, pg_xmlsitemapnav = ?, pg_footernav = ?',
        array("Shopping Cart Checkout", "cart/checkout", "jojo_plugin_jojo_cart_checkout_userbased", 0, "no", "no", "no", "no", "no", "no"));
}

// Shopping Cart Checkout Edit Address
$data = Jojo::selectRow("SELECT pageid FROM {page} WHERE pg_link = ?", array('jojo_plugin_jojo_cart_checkout_userbased_edit'));
if (!$data) {
   echo "Adding <b>Shopping Cart Checkout Edit Address</b> Page to menu<br />";
   Jojo::insertQuery('INSERT INTO {page} SET pg_title = ?, pg_url = ?, pg_link = ?, pg_order = ?, pg_index = ?, pg_followto = ?, pg_contentcache = ?, pg_mainnav = ?, pg_xmlsitemapnav = ?, pg_footernav = ?',
        array("Edit Address", "cart/checkout/edit", "jojo_plugin_jojo_cart_checkout_userbased_edit", 0, "no", "no", "no", "no", "no", "no"));
}

// Shopping Cart Checkout Delete Address
$data = Jojo::selectRow("SELECT pageid FROM {page} WHERE pg_link = ?", array('jojo_plugin_jojo_cart_checkout_userbased_delete'));
if (!$data) {
   echo "Adding <b>Shopping Cart Checkout Delete Address</b> Page to menu<br />";
   Jojo::insertQuery('INSERT INTO {page} SET pg_title = ?, pg_url = ?, pg_link = ?, pg_order = ?, pg_index = ?, pg_followto = ?, pg_contentcache = ?, pg_mainnav = ?, pg_xmlsitemapnav = ?, pg_footernav = ?',
        array("Delete Address", "cart/checkout/delete", "jojo_plugin_jojo_cart_checkout_userbased_delete", 0, "no", "no", "no", "no", "no", "no"));
}

