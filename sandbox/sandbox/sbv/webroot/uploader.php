<?php 
	include 'settings.php';
	$sid = md5(uniqid(rand()));
	$debug_mode = false;
?>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<link rel="stylesheet" type="text/css" href="css/style.css" />
	<script>
	

	function checkCookie()
	{
	username=getCookie('username');
	if (username!=null && username!="")
	  {
	  alert('Welcome again '+username+'!');
	  }
	else
	  {
	  username=prompt('Please enter your name:',"");
	  if (username!=null && username!="")
	    {
	    setCookie('username',username,365);
	    }
	  }
	}
	</script>
	</head>
	<body onload="checkCookie">

	<div id="pleasewait" style="margin:auto;margin-top:100px;text-align:center;width:100%;color:667788;font-weight:bold;">please wait ...<br /><img src="/img/ajax_loader.gif" /></div>
	<script>
		window.onload = function(){
			document.getElementById('pleasewait').style.display = 'none';
			document.getElementById('uploader').style.display = 'block';
		}
	</script>
	<script type="text/javascript" src="js/gears_init.js"></script>
	<script type="text/javascript" src="js/gears_uploader.js"></script>
	<!-- scriptaculous  -->
	<script type="text/javascript" src="js/scriptaculous/prototype.js"></script>
	<script type="text/javascript" src="js/scriptaculous/scriptaculous.js"></script>
	<script type="text/javascript" src="js/scriptaculous/unittest.js"></script>
	
	
	<!-- paths for JS Calendar  -->
	<link rel="stylesheet" type="text/css" media="all" href="/js/jscalendar-1.0/calendar-win2k-cold-1.css" 	title="win2k-cold-1" />
	<script type="text/javascript" src="js/jscalendar-1.0/calendar.js"></script>
	<script type="text/javascript" src="js/jscalendar-1.0/lang/calendar-en.js"></script>
	<script type="text/javascript" src="js/jscalendar-1.0/calendar-setup.js"></script>
	<!-- end JS calendar -->	
	
	<?php 
		//find max file size for current partner
		$partner_id = mysql_escape_string(trim($_GET['partner_id']));
		/*$sqlUploadTierId = "SELECT upload_tiers.max_file_size AS upload_file_size FROM upload_tiers 
							LEFT JOIN partner_configuration ON partner_configuration.upload_tier_id = upload_tiers.id
							WHERE partner_configuration.id = '$partner_id'";
		*/
		
		
		$sqlUploadTierId = "SELECT UT.max_file_size as upload_file_size, UTT.max_file_size as upload_flv_size
							FROM partner_configuration 
							LEFT JOIN upload_tiers as UT ON partner_configuration.upload_tier_id = UT.id 
							LEFT JOIN upload_tiers as UTT ON partner_configuration.upload_flv_id = UTT.id 
							WHERE partner_configuration.id = '$partner_id'";
		$uploadTierId = mysql_query($sqlUploadTierId, $central_db);
		if ($row = mysql_fetch_assoc($uploadTierId)) {
			$partnerMaxFileSize = $row['upload_file_size'];
			$partnerMaxFlvFileSize = $row['upload_flv_size'];
			
		}
		if(!isset($partnerMaxFileSize) || !$partnerMaxFileSize || $partnerMaxFileSize == 0){
			$partnerMaxFileSize = 100;
			$partnerMaxFlvFileSize = 100;
		}
	?>
	
	<script>
		var FILES = [];
		var PARTNER_ID = '<?php echo mysql_escape_string(trim($_GET['partner_id'])); ?>';
		var SID = '<?php echo $sid; ?>';
		var DOMAIN = '<?php echo $_GET['domain']; ?>';
		
		var USER_ID = '<?php echo mysql_escape_string(trim($_GET['uid'])); ?>';
		var UPLOAD_MODE = '<?php echo mysql_escape_string(trim($_GET['upload_mode'])); ?>';
				
		var arrFiles = new Array();
		var currentFile = 0;
		var nextFile = 1;
		
		var interval = null;
		var uploadState = 'ready';
		var allowedFiles = '.mpeg,.mpg,.mov,.moov,.flv,.rm,.mp4,.wmv,.avi,.divx,.3gp,.3gpp,.amv,.mpe,.asf,.ogm,.ogv,.ovx,.m4v';
		var ALLOWED_FILES = allowedFiles.split(',');
		var currDate = '<?php echo date('Y-m-d') ?>';
		
		var CHUNK_SIZE = 512 * 1024;
		//By default we setup max_file_size value, if flv is uploaded we overwrite it with MAX_FLV_FILE_SIZE
		var MAX_NONFLV_FILE_SIZE = <?php echo (int) $partnerMaxFileSize;?> * 1024 * 1024;
		var MAX_FILE_SIZE = MAX_NONFLV_FILE_SIZE;
		var MAX_FLV_FILE_SIZE = <?php echo (int) $partnerMaxFlvFileSize;?> * 1024 * 1024;
	</script>
	
	
	<?php if($debug_mode) {?>
		<input type="button" onclick="console.dir(FILES);console.debug('upload status: '+FILE.upload_in_progress);console.debug('next_in_queue status: '+FILE.next_in_queue)" value="DEBUG" />
		<input type="button" onclick="FILE.pauseFiles();" value="Reset and stop..." />
	<?php } ?>
	
	<div id="uploader" style="background-color:#eeefff;height: 260px; width: 460px;display:none;">
		<div class="uploader_top">
			<div id="add_file">
				<img style="cursor:pointer;position:relative;top:2px;" src="img/add_new_file.jpg" onclick="FILE.add();" />
			</div>
			<br clear="all" />
		</div>
		<div class="uploader_middle_container">
			<div id="queue_element" class="uploader_middle"></div>
		</div>
		<div class="uploader_bottom">
			<span style="margin-left:25px;vertical-align:top;"><a class="link" target="_top" href="<?php echo $_GET['domain']; ?>">View uploaded files</a></span> 
			<img id="start_upload" style="margin-left:23px;cursor:pointer;" src="img/stop_upload_button.jpg" onclick="FILE.start_upload();" />
			<img id="stop_upload" style="display:none;margin-left:23px;cursor:pointer;" src="img/stop_upload_button2.jpg" onclick="FILE.pauseFiles();" />
			<span style="margin-left:10px;vertical-align:top;"><a class="link" href="javascript:void(0);" onClick="FILE.remove_all();">Remove all</a></span> 
			<span style="margin-left:10px;vertical-align:top;"><a target="show_log" class="link" href="show_user_log.php?sid=<?php echo $_GET['partner_id'] . '_' . $sid?>">View log</a></span> 
		</div>
		<div class="uploader_bottom_info"></div>
		<div class="uploader_bottom_3"></div>		
	</div>
	
	<!-- load images -->
	<div style="display:none">
		<img src="img/error-box.png"/>
	</div>
	
	
	<!-- start for video details-->
	<div class="frame1" id="video_details">	
		<div id="pop" style="">
			<input type="hidden" id="editmode" value="" />
			<input type="hidden" id="editid" value="" />
			
			<div class="pop_top"><span style="cursor:pointer;" onClick="UI.reset_and_remove_details();" title="Close"><img style="margin-top:6px; margin-left:230px;" src="img/cancel_btn.png"/></span></div>
			<div class="pop_middle_container">
				<div class="pop_middle">
					<!-- content for popup-->	
					<table width="435" border="0" cellspacing="0" cellpadding="3" align="center" style="margin-top:15px;">
					  <tr>
					    <td width="94" class="name">Channel</td>
					    <td width="341" colspan="3"><select class="popup" id="channel" style="width:175px; float:left;" autocomplete="off"> 
							<script>CMS.getChannels();</script>
						</select></td>
					  </tr>
					  <tr>
					    <td class="name">Title *</td>
					    <td colspan="3"><input class="popup"id="title" onKeyUp="UI.validation();" onBlur="UI.validation();" style="width:340px; float:left;" autocomplete="off" type="text" value=""/></td>
					  </tr>
					  <tr>
					    <td class="name">Tags *</td>
					    <td colspan="3"><input class="popup"id="tags" onBlur="UI.validation();" onKeyUp="UI.validation();" style="width:340px; float:left;" autocomplete="off" type="text" value=""/>
						</td>
					  </tr>
					  <tr>
					    <td class="name">Description *</td>
					    <td colspan="3"><input class="popup"id="description" onBlur="UI.validation();" onKeyUp="UI.validation();" style="width:340px; float:left;" autocomplete="off" type="text" value=""/></td>
					  </tr>
					  <tr>
					    <td class="name">Age gate </td>
					    <td colspan="3"><select name="flag_agegate" id="flag_agegate">
		                   	<?
		                   	    foreach($ageGate as $k=>$v)
		                   	    {
		                   	        ?>
		                   	        <option value="<?=$k?>"><?=$v?></option>
		                   	        <?
		                   	    }
		                   	?>
                   			</select></td>
					  </tr>
					  <tr>
					    <td class="name" width="100">Publish status </td>
					    <td width="160"><select class="popup" onchange="OnVideoStateChange(this);" name="select_video_status" style="width:160px;" id="select_video_status" autocomplete="off">
						   <option value="3" >Publish pending</option>
						   <option value="1" SELECTED>Published</option>
						   <option value="2" id="optionPublishedDate">Publish on a date </option>
						</select>
						</td>
					    <td class="name" width="80" align="right">Publish Date</td>
						<td width="95">
							<div id="publish_date_button1" style="color:#990000;float:left;font-size:11px;text-decoration:underline;"><?php echo date('Y-m-d') ?></div>
						   <input type="button" name="publish_date_button2" id="publish_date_button2" style="visibility:hidden; width:10px; height:10px; overflow:hidden;" value="hidden button"  />
						   <input type="hidden" name="activationDate" id="activationDate" value="<?php echo date('Y-m-d') ?>"/>  
							<div id="timeZoneMsg" class="singlerow" style="display:none;color:#666666;height:13px;">
							* Publish date is set according to server time (Pacific Standard Time).
							</div>
						</td>
					  </tr>
					</table>	
					<!-- Bitrate part start -->
					<table width="435" border="0" cellspacing="0" cellpadding="4" align="center" style="margin-top:10px;margin-bottom:10px;">
					   <tr>
					    <td width="235" class="border_top">
					    	<table width="235" border="0" cellspacing="0" cellpadding="2" >
					    		<tr>
					    			<td width="80" class="name"><span id="compression_text">Compression</span></td>
				
					    			<td align="left">
					    				<label class="name" id="compression_h264"><input type="radio" name="convert_to" value="1"  style="border:none;"/> H.264</label>
					    				<label class="name" id="compression_flv"><input type="radio" name="convert_to" value="0" style="border:none;"/> VP6</label>&nbsp;
					    			</td>
					    		</tr>
					    		<tr>
					    			<td class="name"><span id="compression_bitrate">Bit Rate</span></td>
					    			<td align="left">
					    			<select class="popup" id="bitrate" style="margin-left:5px;width:93px; float:left;" autocomplete="off"> 
									<script>CMS.getBitRate();</script>
									</select>
									</td>
					    		</tr>
					    	</table>
					    </td>
					    <td width="200" class="border_top">
					    <table width="100%" border="0" cellspacing="0" cellpadding="2" >
					    		<tr>
					    			<td class="title_text"><input type="checkbox" name="remember_me"  style="border:none;" id="remember_me" /> <span id="compression_remember">Remember my<br/>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;conversion settings</span></td>
					    		</tr>
					    	</table>
					    </td>
					  </tr>
					  <tr>
					  	<td colspan="2" class="flv_info">Conversion settings only available for non-flv files (not encoded as VP6).</td>
					  </tr>
					</table>	
					
					<!-- Bitrate part end -->
					
					<div class="singlerow" style="text-align:center; margin-left:15px">
						<input class="pop_button_add" id="buttonAddMore" type="button" disabled="true" onClick="FILE.add_to_queue();" value="" />
						<input class="pop_button_upload" id="buttonStartUpload" disabled="true" type="button" value="" onClick="FILE.init_upload();" />
					</div>
					<!-- end for content popup-->
				</div>
			</div>
			<div class="pop_bottom"></div>
		</div>
	</div>
	<!-- end forvideo details-->
	
	<!-- start for error popup-->	
	<div id="error_msg" class="error">
		<div style="background-image:url(img/error-box-1.png);background-repeat:no-repeat;text-align:left; color:#ffffff; height:20px;padding-top:2px;padding-left:2px;padding-right:2px;">
			<span style="float:left;margin-top:2px;margin-left:7px;">Error</span>
			<span style="float:right"><img title="Close" style="margin-right:6px;margin-top:3px;cursor:pointer;" onClick="document.getElementById('error_msg').style.display = 'none';" src="img/close_video_preview.png" /></span>
		</div>
		<div id="error_msg_placeholder" style="background-image:url(img/error-box-2.png);background-repeat:repeat-y;padding:5px;padding-left:15px;padding-right:15px;">error message</div>
		<div style="background-image:url(img/error-box-3.png);background-repeat:no-repeat;height:9px;"></div>
	</div>
	<!-- end for error popup-->
	
	
	<!-- start for hidden iframe-->
	<iframe name="show_log" style="display:none"></iframe>
	<!-- end for hidden iframe-->
	
	<div id="install_gears" style="display:none;" class="gears_style">
		<div class="gears_message">To use the uploader you need to enable Google Gears Support.</div>
		<div style="margin-top:50px;">
		<a  class="gears_url" target="_blank" href="http://gears.google.com/?action=install&message=Please%20install%20this%20application%20for%20a%20fast%20and%20reliable%20upload%20experience%20with%20the%20SpringBoard%20platform.&return=">Click here to <br />install Google Gears</a><br/>
		<img src="img/google_gears.png" style="border:0;" />
		</div>
		
	</div>
	
	<script type="text/javascript">
    var today = new Date();
    var dateToShow = "<?php echo date('Y-m-d') ?>";
    
    function UpdatePublishedDateObjects(cal) { 
	//document.getElementById("timeZoneMsg").style.display = "block";
    	var date = cal.date;
     
    	var now = new Date();
    	now.setHours('00');
		now.setMinutes('00');
		now.setSeconds('00');

		var after_today = date - now;
     
    	var clickButton = document.getElementById("publish_date_button1");
     
     	/*var ddY = date.getFullYear();
     	var ddM = date.getMonth(); ddM=ddM<10?"0"+ddM:ddM;
     	var ddD = date.getDate(); ddD=ddD<10?"0"+ddD:ddD;
     	var dd = parseInt(ddY+ddM+ddD);
     
	     var nnY = now.getFullYear();
	     var nnM = now.getMonth(); nnM=nnM<10?"0"+nnM:nnM;
	     var nnD = now.getDate(); nnD=nnD<10?"0"+nnD:nnD;
	     var nn = parseInt(nnY+nnM+nnD);*/
     
     	// limit to dates after today
     	/*if(dd<nn){
      		var prevValue = clickButton.innerHTML.replace(/^[\s\t\r\n]+|[\s\t\r\n]+$/g,"");
      		prevValue = prevValue.match(/^\d+-\d+-\d+$/)?prevValue:"";
      		cal.params.inputField.value = prevValue;
     	}*/
    	if(after_today < 0 && after_today < -1000){
			var prevValue = clickButton.innerHTML.replace(/^[\s\t\r\n]+|[\s\t\r\n]+$/g,"");
			prevValue = prevValue.match(/^\d+-\d+-\d+$/)?prevValue:"";
			cal.params.inputField.value = prevValue;
		} else { 
      		// update calendar button text
      		clickButton.innerHTML = date.print("%Y-%m-%d");
      
      		// update video status select-box
      		var sel = document.getElementById("select_video_status");
      		var opts = sel.options;
      
     	 	//var value2Select = (dd==nn)?1:2;
      		for(var i=0; i<opts.length; i++) {
       			/*if(value2Select==1) {
        			if(opts[i].value==1) {
         				opts[i].selected = true;
         				document.getElementById("optionPublishedDate").innerHTML = "on date";
        			} else {
         				opts[i].selected = false;
        			}
       			} else if(value2Select==2) {*/
        			if(opts[i].value==2) {
         				opts[i].selected = true;
         				opts[i].innerHTML = "Publish on "+date.print("%Y-%m-%d");
         				//opts[i].innerHTML = "on ";
        			} /*else {
         				opts[i].selected = false;
        			}
       			}*/
      		}
     	}
    }
    
    function OnVideoStateChange(select){
	if(select.value == 2) {
		//document.getElementById("timeZoneMsg").style.display = "block";
	}else {
		document.getElementById("timeZoneMsg").style.display = "none";
	}
     var input = document.getElementById("activationDate");
     var display = document.getElementById("publish_date_button1");
     if(select.value==2){
      var btn = document.getElementById("publish_date_button2");
      btn.click();
     }else if(select.value==1){
      var str = today.getFullYear()+"-";
      var m = today.getMonth()+1; m = m<10?"0"+m:m;
      str += m+"-";
      var d = today.getDate(); d=d<10?"0"+d:d;
      str += d;
      input.value = str;
      display.innerHTML = str;
      document.getElementById("optionPublishedDate").innerHTML = "Publish on a date";
     }else{
      input.value = "";
      display.innerHTML = "N/A";
      document.getElementById("optionPublishedDate").innerHTML = "Publish on a date";
     }
    }
    Calendar.setup({
     inputField : "activationDate",   // id of the input field
     button  : "publish_date_button1",
     eventName : "click",
     date  : dateToShow,
     ifFormat : "%Y-%m-%d",   // format of the input field
     range  : Array(today.getFullYear(),today.getFullYear()+3),
     showsTime : false,
     onUpdate : UpdatePublishedDateObjects
    });
    Calendar.setup({
     inputField : "activationDate",   // id of the input field
     button  : "publish_date_button2",
     eventName : "click",
     date  : dateToShow,
     ifFormat : "%Y-%m-%d",   // format of the input field
     range  : Array(today.getFullYear(),today.getFullYear()+3),
     showsTime : false,
     onUpdate : UpdatePublishedDateObjects
    });
   </script>
	
	<script>	
		//check for gears
		if (!window.google || !google.gears) {
			UI.gears_install();
			//top.location.href = "http://gears.google.com/?action=install&message=" +message+"&return=http://cms.springboard.gorillanation.com/admin/videos/my_videos";
		}
	</script>
	
	</body>
</html>
