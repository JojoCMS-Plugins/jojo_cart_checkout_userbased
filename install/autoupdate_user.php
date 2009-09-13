<?php
/**
 *                    Jojo CMS
 *                ================
 *
 * Copyright 2008 Jojo CMS
 *
 * See the enclosed file license.txt for license information (LGPL). If you
 * did not receive this file, see http://www.fsf.org/copyleft/lgpl.html.
 *
 * @author  Michael Cochrane <mikec@jojocms.org>
 * @license http://www.fsf.org/copyleft/lgpl.html GNU Lesser General Public License
 * @link    http://www.jojocms.org JojoCMS
 */

/* Details Tab */

// Checkout Addressbook Field
$default_fd['user']['checkout_addressbook'] = array(
        'fd_name' => "Checkout Addressbook",
        'fd_type' => "hidden",
        'fd_order' => "100",
        'fd_tabname' => "Details",
    );


// Generic Login (used by more than one user)
$default_fd['user']['generic'] = array(
        'fd_name' => "Generic Account",
        'fd_type' => "radio",
        'fd_default' => "no",
        'fd_order' => "100",
        'fd_tabname' => "Details",
    );

