<?php
  
  // database setup
  $config['dbtype'] = 'maxsql';
  $config['dbhost'] = 'vip-sqlrw-gr.ao.prd.lax.gnmedia.net';
  $config['dbuname'] = 'gamrev_rw';
  $config['dbname'] = 'gamerevolution';
  $config['dbpass'] = '<%= grproddbpass %>';
  $config['maildbname'] = "gr_mail";
  $config['maildbconn'] = 0;

  $config['doc_root_dir'] = '/app/shared/docroots/gamerevolution.com/htdocs/';
  $config['rel_path_to_cron_script'] = "admin_files/cron";

  // $config['cron_job_results_recipients'] = "sysadmins@gorillanation.com duke@gamerevolution.com";
  $config['cron_job_results_recipients'] = "duke@gamerevolution.com";

  // Server run scripts don't have superglobal $_SERVER so we assume they are localhost
  if (!isset($_SERVER['SERVER_ADDR']) || (empty($_SERVER['SERVER_ADDR']) ) ){
	$_SERVER['SERVER_ADDR'] = "127.0.0.1";
  }
  
  // security for cron scripts
  $config['serverIP'] = '127.0.0.1'; 
  
  // options: development, staging, production
  $config['deploy_mode'] = 'production'; 

  // recaptcha private key
  $config['recaptcha_privatekey'] = '6LePrMoSAAAAACBE5iVER2wyiRvph5u03yjVXTWp'; 
  
  // true or false
  $config['display_ads'] = true;

  // base url of old pre-dynamic GR site 
  // to be used for redirects when graphics or other 
  // media links in articles are not found
  $config['archive_base_url'] = "http://www.gamerevolution.com";

  // the gr admin can use this email address to create new 
  // member accounts -- without the need 
  // to use a unique email address.
  $config['admin_email'] = "info@gamerevolution.com";

  // CDN server -- used for images and goodies folder 
  $config['cdn_server'] = 'http://media.gamerevolution.com';
  
  // Show new report card and star-rating system for articles with this id and newer
  $config['new_report_card_from_id'] = 61524;
  
  // This option provides basic caching control. 
  // When true, pages that call init_cache() will 
  // draw on cached db result sets.  
  $config['db_cache'] = true;        
  $config['db_cache_seconds'] = 300;        
   
  if ( !empty($_SERVER['SERVER_NAME']) && $_SERVER['SERVER_NAME'] == 'admin.gamerevolution.com' )
  {
        $config['server_beta'] = 1;
        $config['display_ads'] = false;
        $config['db_cache'] = false;
        $config['db_cache_seconds'] = 0;
  }
  
 // Placed here because doc_root_dir variable can be different
  $config['path_to_cron_script'] = $config['doc_root_dir'].$config['rel_path_to_cron_script'];


  // Set the server_beta variable for Smarty : Navid
  function set_smarty_server_beta_variable ($template) {
	global $config;
  	$template->assign('server_beta', $config['server_beta'] );
	return true;
  }

   
?>
