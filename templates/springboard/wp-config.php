<?php


// Springboard wordpress dev config file

/**
 * The base configurations of the WordPress.
 *
 * This file has the following configurations: MySQL settings, Table Prefix,
 * Secret Keys, WordPress Language, and ABSPATH. You can find more information
 * by visiting {@link http://codex.wordpress.org/Editing_wp-config.php Editing
 * wp-config.php} Codex page. You can get the MySQL settings from your web host.
 *
 * This file is used by the wp-config.php creation script during the
 * installation. You don't have to use the web site, you can just copy this file
 * to "wp-config.php" and fill in the values.
 *
 * @package WordPress
 */

// ** MySQL settings - You can get this info from your web host ** //
/** The name of the database for WordPress */
define('DB_NAME_W', 'wordpress');
define('DB_USER_W', 'sbv_wp_rw');
define('DB_PASSWORD_W', '<%= wpWritePassword %>');
define('DB_HOST_W', '<%= wpWriteVip %>');

define('DB_NAME_R', 'wordpress');
define('DB_USER_R', 'sbv_wp_rw');
define('DB_PASSWORD_R', '<%= wpReadPassword %>');
define('DB_HOST_R', '<%= wpReadVip %>');

/*
define('DB_NAME', 'wordpress');
define('DB_USER', 'sbv_wp_w');
define('DB_PASSWORD', 'VakqfHBe');
define('DB_HOST', 'vip-sqlrw-wp.sbv.stg.lax.gnmedia.net');
*/


/** Database Charset to use in creating database tables. */
define('DB_CHARSET', 'utf8');

/** The Database Collate type. Don't change this if in doubt. */
define('DB_COLLATE', '');

/**#@+
 * Authentication Unique Keys and Salts.
 *
 * Change these to different unique phrases!
 * You can generate these using the {@link https://api.wordpress.org/secret-key/1.1/salt/ WordPress.org secret-key service}
 * You can change these at any point in time to invalidate all existing cookies. This will force all users to have to log in again.
 *
 * @since 2.6.0
 */
define('AUTH_KEY',         'DvbU/$/~)OH7;i_hCn@,|^bu6r iNnIR1z+(*&5Bg$f7 H:528br57CJ]q{IbWBT');
define('SECURE_AUTH_KEY',  'edU6$o6UOqm9bSoOoIeN0mPLeI(u7#}q{u:pZ|L9(,Yw_lp/pdfP|%G=-w55#*g^');
define('LOGGED_IN_KEY',    'GMK^C^K?eK]AV#0#d(XVg4lcrDl><cJ](LFwF7@{[s{j)^(X2i;iJ2+t][a)APgB');
define('NONCE_KEY',        'pP+CuxwtpDaq,#Erxz:!:-O0t~tWb,DK]sdHdXyC6UCMK&)g_<x&MIwd8xi?++CG');
define('AUTH_SALT',        'C!GXdzig>EqzX!p,.Y`Y_XhGvi}5oj.@Jo`Ko1|gKN!AZI1k=U>@DDA%.8EYL=c!');
define('SECURE_AUTH_SALT', 'Yb{-;e6N|)47a~=Goan#iNvP;y0b<CAgn-k1{[KKx)G`Ev/voR;+NTl^w:&)qj]a');
define('LOGGED_IN_SALT',   'NAth#EaS9yun*WmUK5<B+-*$A+Iodd{|z<k^+&l^c_H49,Cc;|:{(ic~<> LW,kf');
define('NONCE_SALT',       '3tc-Holb-58-<sNf~?r$TJ[0A+eC&j~k45$qv&e=RCh+ev=l=H2H)*np9hY8y!VQ');
/**#@-*/

/**
 * WordPress Database Table prefix.
 *
 * You can have multiple installations in one database if you give each a unique
 * prefix. Only numbers, letters, and underscores please!
 */
$table_prefix  = 'wp_';

/**
 * WordPress Localized Language, defaults to English.
 *
 * Change this to localize WordPress. A corresponding MO file for the chosen
 * language must be installed to wp-content/languages. For example, install
 * de_DE.mo to wp-content/languages and set WPLANG to 'de_DE' to enable German
 * language support.
 */
define('WPLANG', '');

/**
 * For developers: WordPress debugging mode.
 *
 * Change this to true to enable the display of notices during development.
 * It is strongly recommended that plugin and theme developers use WP_DEBUG
 * in their development environments.
 */
define('WP_DEBUG', false);

/* That's all, stop editing! Happy blogging. */

/** Absolute path to the WordPress directory. */
if ( !defined('ABSPATH') )
	define('ABSPATH', dirname(__FILE__) . '/');

/** Sets up WordPress vars and included files. */
require_once(ABSPATH . 'wp-settings.php');
