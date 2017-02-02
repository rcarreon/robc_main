/*  CMS FUNCTIONS */
function getCookie(c_name)
	{
	if (document.cookie.length>0)
	  {
	  c_start=document.cookie.indexOf(c_name + "=");
	  if (c_start!=-1)
	    {
	    c_start=c_start + c_name.length+1;
	    c_end=document.cookie.indexOf(";",c_start);
	    if (c_end==-1) c_end=document.cookie.length;
	    return unescape(document.cookie.substring(c_start,c_end));
	    }
	  }
	return "";
	}

	function setCookie(c_name,value,expiredays)
	{
	var exdate=new Date();
	exdate.setDate(exdate.getDate()+expiredays);
	document.cookie=c_name+ "=" +escape(value)+
	((expiredays==null) ? "" : ";expires="+exdate.toUTCString());
	}
var CMS = {
	getChannels : function (){
		objDate = new Date();
		timestamp = objDate.getTime();
		var url  = 'get_channels.php?partner_id=' + PARTNER_ID +'&t=' + timestamp;
		xmlhttp = CMS.createXmlHttp();
		xmlhttp.open('GET', url, false);
		xmlhttp.send(null);
		document.write(xmlhttp.responseText);
	},
	getBitRate : function (){
		objDate = new Date();
		timestamp = objDate.getTime();
		var url  = 'get_bitrate.php?partner_id=' + PARTNER_ID +'&t=' + timestamp;
		xmlhttp = CMS.createXmlHttp();
		xmlhttp.open('GET', url, false);
		xmlhttp.send(null);
		document.write(xmlhttp.responseText);

	},
	createXmlHttp : function(){
		var xmlhttp = null;
		if(window.XMLHttpRequest){
			xmlhttp = new XMLHttpRequest();
		}else if(window.ActiveXObject){
			try{
				xmlhttp = new ActiveXObject('Msxml2.XMLHTTP');
			}catch(e){
				try{
					xmlhttp = new ActiveXObject('Microsoft.XMLHTTP');
				}catch(e){}
			}
		}
		return xmlhttp;
	}
};
/*  USER INTERFACE FUNCTIONS */
var UI = {
	current_file_index:0,
	current_mode:'',
	file_details : function(){
		UI.current_mode = 'add';
		div_video_details = document.getElementById('video_details');
		div_video_details.style.display = 'block';
		//Read from cookie
		var cookieRememberConversation = getCookie('SBremememberConversion');
		if (cookieRememberConversation!=null && cookieRememberConversation!="" && cookieRememberConversation!="off")
		  {
			var SBbitrate = getCookie('SBbitrate');
			var SBconvertTo = getCookie('SBconvertTo');
			document.getElementById('bitrate').selectedIndex = SBbitrate-1;
			//Fast tweak to get input radio button selected
			var inputs = document.getElementsByTagName ('input');
			  if (inputs) {
			    for (var i = 0; i < inputs.length; i++) {
			      if (inputs[i].type == 'radio' && inputs[i].name == 'convert_to')
			      {
			        if(inputs[i].value==SBconvertTo)
			        {
			        	inputs[i].checked = true;
			        }
			      }
			    }
			  }
			document.getElementById('remember_me').checked = true;
		  }
		else
		{
			//Cookie isn't set, so crate default selection
			var inputs = document.getElementsByTagName ('input');
			  if (inputs) {
			    for (var i = 0; i < inputs.length; i++) {
			      if (inputs[i].type == 'radio' && inputs[i].name == 'convert_to')
			      {
			    	  //select h264 by default
			        if(inputs[i].value==1)
			        {
			        	inputs[i].checked = true;
			        }
			      }
			    }
			  }
		}
		
		UI.validation();
	},
	hide_details : function(){
		document.getElementById('video_details').style.display = 'none';
		
		if(FILES[UI.current_file_index]['state'] == 'edit'){
			FILES[UI.current_file_index]['state'] = 'ready';
		}
	},
	show_conversion_options : function(){
		document.getElementById('bitrate').disabled= false;
		document.getElementById('remember_me').disabled= false;
		document.getElementById('compression_text').style.color = '';
		document.getElementById('compression_flv').style.color = '';
		document.getElementById('compression_h264').style.color = '';
		document.getElementById('compression_bitrate').style.color = '';
		document.getElementById('compression_remember').style.color = '';
		var inputs = document.getElementsByTagName ('input');
		  if (inputs) {
		    for (var i = 0; i < inputs.length; i++) {
		      if (inputs[i].type == 'radio' && inputs[i].name == 'convert_to')
		      {
		        inputs[i].disabled = false;
		      }
		    }
		  }
		
	},
	hide_conversion_options : function(){
		
		document.getElementById('bitrate').disabled= true;
		document.getElementById('remember_me').disabled= true;
		document.getElementById('compression_text').style.color = '#dbdbdb';
		document.getElementById('compression_flv').style.color = '#dbdbdb';
		document.getElementById('compression_h264').style.color = '#dbdbdb';
		document.getElementById('compression_bitrate').style.color = '#dbdbdb';
		document.getElementById('compression_remember').style.color = '#dbdbdb';
		var inputs = document.getElementsByTagName ('input');
		  if (inputs) {
		    for (var i = 0; i < inputs.length; i++) {
		      if (inputs[i].type == 'radio' && inputs[i].name == 'convert_to')
		      {
		        inputs[i].disabled = true;
		      }
		    }
		  }
		
	},
	//This method is called on close button of upload form, we need to do pop() from FILES array, so it does not remember previous file!!!
	reset_and_remove_details : function(){
		
		UI.hide_details();
		UI.reset_details();
		if(UI.current_mode=='add')
		{
			FILES.pop();
		}
	},
	reset_details : function(){
		document.getElementById('title').value='';
		document.getElementById('channel').options[0].selected=true;
		document.getElementById('bitrate').options[0].selected=true;
		//document.getElementById('convert_to').value='';
		document.getElementById('activationDate').value = currDate;
		document.getElementById('publish_date_button1').innerHTML = currDate;
		UI.updateSelected(1, 0);
		document.getElementById('tags').value='';
		document.getElementById('description').value='';
		document.getElementById('flag_agegate').options[0].selected=true;
		//document.getElementById('flag_agegate').value='';	
		document.getElementById('buttonAddMore').disabled=true;
		document.getElementById('buttonStartUpload').disabled=true;	
		//Enable conversion options, they will be disabled in checkFileExtension function if .flv file is uploading
		UI.show_conversion_options();
	},
	validation : function() {
		if(document.getElementById('title').value==''){
			UI.disable_submit_buttons();
			return false;
		}
		else if(document.getElementById('tags').value==''){
			UI.disable_submit_buttons();
			return false;
		}
		else if(document.getElementById('description').value==''){
			UI.disable_submit_buttons();
			return false;
		}
		UI.enable_submit_buttons();
		
	},
	showSelected : function() {		
		var selObj = document.getElementById('select_video_status');	
		var selIndex = selObj.selectedIndex;
	
		return selObj.options[selIndex].value;
	},
	updateSelected : function(value2Select, date) {	
		var sel = document.getElementById("select_video_status");
		var opts = sel.options;
		for (var i = 0; i < opts.length; i++) {
		    if (value2Select == 1) {
				//publish pending
		        if (opts[i].value == 1) {
		            opts[i].selected = true;
		        } 
		    } else if (value2Select == 2) {
		        if (opts[i].value == 2) {
		            opts[i].selected = true;
		            opts[i].innerHTML = "Publish on a " + date;
		        }
		    } else if (value2Select == 3) {
				//publish pending
				if (opts[i].value == 3) {
		            opts[i].selected = true;
		        }
			}
		}
	},
	disable_submit_buttons : function() {
		document.getElementById('buttonAddMore').disabled = true;
		document.getElementById('buttonAddMore').style.backgroundImage = "url('img/addfile_disabled.png')";
		document.getElementById('buttonAddMore').style.backgroundRepeat = "no-repeat";
		document.getElementById('buttonAddMore').style.cursor = "hand";
		document.getElementById('buttonStartUpload').disabled = true;
		document.getElementById('buttonStartUpload').style.backgroundImage = "url('img/startupload_disabled.png')";
		document.getElementById('buttonStartUpload').style.backgroundRepeat = "no-repeat";
		document.getElementById('buttonStartUpload').style.cursor = "hand";
	},	
	enable_submit_buttons : function() {
		document.getElementById('buttonAddMore').disabled=false;
		document.getElementById('buttonAddMore').style.backgroundImage="url('img/pop_add_another.png')";
		document.getElementById('buttonAddMore').style.backgroundRepeat="no-repeat";
		document.getElementById('buttonAddMore').style.cursor = "hand";
		
		document.getElementById('buttonStartUpload').disabled=false;
		document.getElementById('buttonStartUpload').style.backgroundImage="url('img/pop_start_upload.png')";
		document.getElementById('buttonStartUpload').style.backgroundRepeat="no-repeat";
		document.getElementById('buttonStartUpload').style.cursor = "hand";	
	},
	checkFileExtension : function(name) {
		var allowed = false;
		var ext = name.split('.').pop();
		for(var i=0; i<ALLOWED_FILES.length; i++){
			
			if(ALLOWED_FILES[i].toLowerCase() == '.'+ ext.toLowerCase()){
				//Extension is flv, disable converting options
				if('.'+ ext.toLowerCase()=='.flv')
				{
					UI.hide_conversion_options();
					MAX_FILE_SIZE = MAX_FLV_FILE_SIZE;
				}
				else
				{
					MAX_FILE_SIZE = MAX_NONFLV_FILE_SIZE;
				}
				allowed = true;
				break;
			}
		}
		// allowed?alert('allowed'):alert('not allowed');
		return allowed;
	},
	display_error : function(error_msg) {
		// if (error_msg.length > 40) {
		// error_msg = error_msg.substring(0,40)+'  '+ error_msg.substring(40,error_msg.length); 
		// }
		document.getElementById('error_msg_placeholder').innerHTML = error_msg;
		document.getElementById('error_msg').style.display = 'block';
		//new Effect.Shake('error_msg', {duration:0.5, distance:5});
	},
	gears_install : function() {
		document.getElementById('install_gears').style.display = 'block';
	}
};
/*  FILE UPLOAD FUNCTIONS */
var FILE = {
	last_file_index:0,
	next_in_queue:0,
	last_chunk:0,
	last_part_size:0,
	upload_in_progress:0,
	tryRetryAttempt:false,
	maxRetryAttempts:3,
	retryAttempt:0,
	pause:false,
	retry_upload:null,
	add:function(){
		var desktop = google.gears.factory.create('beta.desktop');
		var fileOptions = {singleFile:true, filter:ALLOWED_FILES};
		desktop.openFiles(this.__get, fileOptions);
	},
	pauseFiles: function (){
		if(FILE.last_chunk!=1)
		{
		FILE.pause = true;
		document.getElementById('stop_upload').style.display = 'none';
		document.getElementById('start_upload').style.display = '';
		UI.display_error("Stopping. <br />Please wait.");
		}
		else
		{
			UI.display_error("You cannot pause upload at this stage of the process.");
			setTimeout("$('error_msg').hide()",3000);
			
		}
	},
	__get:function (files){
		// for(var i=0; i<files.length; i++){ 		Reserved for future use. Now we select one by one file.
		// }
		
		try{
			
			var i = 0; // Because we use single file 
			var input ={ title			: null,
						 channel		: 0,
						 bitrate		: 0,
						 activationDate	: currDate,
						 publishOption	: 1,
						 tags			: null,
						 description	: null,
						 flag_agegate	: 0,
						 convert_to	    : 0,
						 name 			: files[i].name, 
						 blob 			: files[i].blob, 
						 size 			: files[i].blob.length, 
						 uploaded 		: 0, //bytes
						 current_part	: 0, 
						 // total_parts	: parseInt(files[i].blob.length/CHUNK_SIZE) + ((files[i].blob.length%CHUNK_SIZE)/(files[i].blob.length%CHUNK_SIZE)),  
						 // Logic above was wrong if file size was devided with chank and remainder was 0 kb, then we will have this situation 0/0 = NaN
						 total_parts	: (parseInt(files[i].blob.length/CHUNK_SIZE) + parseInt(files[i].blob.length%CHUNK_SIZE!=0 ? 1 : 0)), 
						 state 			: 'ready' }; //completed, deleted, paused, editing, saving, sending
			
			//First we ask is file flv and is it in allowed file types array
			
			if(UI.checkFileExtension(files[i].name)){
				//After we asked for file extension, we now know MAX_FILE_SIZE (it is different value for flv and for non-flv files) defined in partners section
				//Now MAX_FILE_SIZE can be max_upload_size or max_FLV_upload_size right?
				//check file size
				if(files[i].blob.length < MAX_FILE_SIZE) {
					//If we passed file size question, add file to array
					//add file at the end of array FILES
					FILES.push(input);
					UI.file_details();
					
				}else {
					UI.display_error('File is too large. <br .> Max '+ parseInt(MAX_FILE_SIZE/(1024*1024)) + 'MB');
				}
				
			}
			else {
				UI.display_error('File '+files[i].name+' is not allowed.');
			}
			
			//check file size - deprected
		/*	if(files[i].blob.length < MAX_FILE_SIZE) {
				//check extension
				if(UI.checkFileExtension(files[i].name)){
					//add file at the end of array FILES
					FILES.push(input);
					UI.file_details();
					
				}else {
					UI.display_error('File '+files[i].name+' is not allowed.');
				}
			}else {
				UI.display_error('File is too large. <br .> Max '+ parseInt(MAX_FILE_SIZE/(1024*1024)) + 'MB');
			}
			*/
			
		}catch(err) {}

		
	},
	edit : function(id) {
		document.getElementById('error_msg').style.display = 'none';
		if(FILES[id]['state'] != 'sending') {
			FILES[id]['state'] = 'edit';
			UI.current_mode = 'edit';
			UI.enable_submit_buttons();
			UI.current_file_index = id;
			document.getElementById('title').value = FILES[id]['title'];
			document.getElementById('channel').value = FILES[id]['channel'];
			document.getElementById('bitrate').value = FILES[id]['bitrate'];
			document.getElementById('activationDate').value = FILES[id]['activationDate'];
			UI.updateSelected(FILES[id]['publishOption'], FILES[id]['activationDate']);
			
			if(FILES[id]['activationDate'] != ''){
				document.getElementById('publish_date_button1').innerHTML  = FILES[id]['activationDate'];
			}else {
				document.getElementById('publish_date_button1').innerHTML  = 'N/A';
			}
				
			document.getElementById('tags').value = FILES[id]['tags'];
			document.getElementById('description').value = FILES[id]['description'];
			//if(FILES[id]['adult'] == 1) { document.getElementById('adult').checked = true;}
			//if(FILES[id]['flag_agegate'] != 0) { document.getElementById('adult').selectedIndex = FILES[id]['flag_agegate'];}
			document.getElementById('flag_agegate').selectedIndex = FILES[id]['flag_agegate'];
			//document.getElementById('convert_to').selectedIndex = FILES[id]['convert_to'];
			
			//show popup
			div_video_details = document.getElementById('video_details');
			div_video_details.style.display = 'block';
			
			//save 
			FILES[UI.current_file_index]['title'] = document.getElementById('title').value;
			FILES[UI.current_file_index]['channel'] = document.getElementById('channel').value;
			FILES[UI.current_file_index]['bitrate'] = document.getElementById('bitrate').value;
			FILES[UI.current_file_index]['activationDate'] = document.getElementById('activationDate').value;
			FILES[UI.current_file_index]['publishOption'] = UI.showSelected();
			FILES[UI.current_file_index]['tags'] = document.getElementById('tags').value;
			FILES[UI.current_file_index]['description'] = document.getElementById('description').value;
			//if(document.getElementById('adult').checked){ video_adult = 1; } else { video_adult = 0;}
			FILES[UI.current_file_index]['flag_agegate'] = document.getElementById('flag_agegate').value;
			FILES[UI.current_file_index]['convert_to'] = FILE.find_radioButton_value('convert_to');
		}else {
			UI.display_error("Can't edit while upload in progress.");
		}
		
	},
	remove : function (id) {
		if(FILES[id]['state'] != 'sending') {
			UI.current_file_index = id;
			FILES[UI.current_file_index].state = 'deleted';
			document.getElementById('queue_element_'+UI.current_file_index).style.display = 'none';
		}else {
			UI.display_error("Can't remove while upload in progress.");
		}
	},
	remove_all : function() {
		var answer = confirm('Are you sure you want to remove all videos?');
		if (answer){
			for(x in FILES){
				if(FILES[x]['state'] != undefined && FILES[x]['state'] != 'sending'){
					FILES[x]['state'] = 'deleted';
					document.getElementById('queue_element_'+x).style.display = 'none';
				}
			}
		}
	},
	find_radioButton_value : function(radioName){
		
		var chosen = 0;
		var inputs = document.getElementsByTagName ('input');
		  if (inputs) {
		    for (var i = 0; i < inputs.length; i++) {
		      if (inputs[i].type == 'radio' && inputs[i].name == radioName)
		      {
		        if(inputs[i].checked){ chosen = inputs[i].value; break;}
		      }
		    }
		  }
		  return chosen;
	},
	save_details : function(){
		var file_id = FILE.last_file_index;
		FILES[file_id]['title'] = document.getElementById('title').value;
		FILES[file_id]['channel'] = document.getElementById('channel').value;
		FILES[file_id]['bitrate'] = document.getElementById('bitrate').value;
		FILES[file_id]['activationDate'] = document.getElementById('activationDate').value;
		FILES[file_id]['publishOption'] = UI.showSelected();
		FILES[file_id]['tags'] = document.getElementById('tags').value;
		FILES[file_id]['description'] = document.getElementById('description').value;
		//if(document.getElementById('adult').checked){ video_adult = 1; } else { video_adult = 0;}
		//FILES[file_id]['adult'] = video_adult;
		FILES[file_id]['flag_agegate'] = document.getElementById('flag_agegate').value;
		
		FILES[file_id]['convert_to'] = FILE.find_radioButton_value('convert_to');

		if(FILES[file_id]['state'] == 'edit'){
			FILES[file_id]['state'] = 'ready';
		}
		if(document.getElementById('remember_me').checked==true || document.getElementById('remember_me').checked=='true')
		{
			setCookie('SBremememberConversion', 'on',7);
			setCookie('SBbitrate', FILES[file_id]['bitrate'],7);
			setCookie('SBconvertTo', FILES[file_id]['convert_to'],7);
		}
		else
		{
			setCookie('SBremememberConversion', 'off',7);
		}
		
	},
	edit_details : function(){
		var file_id = UI.current_file_index;
		FILES[file_id]['title'] = document.getElementById('title').value;
		FILES[file_id]['channel'] = document.getElementById('channel').value;
		FILES[file_id]['bitrate'] = document.getElementById('bitrate').value;
		FILES[file_id]['activationDate'] = document.getElementById('activationDate').value;
		FILES[file_id]['publishOption'] = UI.showSelected();
		FILES[file_id]['tags'] = document.getElementById('tags').value;
		FILES[file_id]['description'] = document.getElementById('description').value;
		//if(document.getElementById('adult').checked){ video_adult = 1; } else { video_adult = 0;}
		//FILES[file_id]['adult'] = video_adult;
		FILES[file_id]['flag_agegate'] = document.getElementById('flag_agegate').value;
		FILES[file_id]['convert_to'] = FILE.find_radioButton_value('convert_to');

		
		if(FILES[file_id]['state'] == 'edit'){
			FILES[file_id]['state'] = 'ready';
		}
		
		//update in main div
		document.getElementById('video_title_'+UI.current_file_index).innerHTML = FILES[file_id]['title'].substr(0,25);
	},
	init_upload : function(){
		if(UI.current_mode == 'add'){
			FILE.save_details();
			UI.hide_details();
			UI.reset_details();
			FILE.createElementDiv();
		}
		if(UI.current_mode == 'edit'){
			FILE.edit_details();
			UI.hide_details();
			UI.reset_details();		
		}
		FILE.start_upload();
	},
	add_to_queue : function(){
		if(UI.current_mode == 'add'){
			FILE.save_details();
			UI.hide_details();
			UI.reset_details();
			FILE.createElementDiv();
		}
		if(UI.current_mode == 'edit'){
			FILE.edit_details();
			UI.hide_details();
			UI.reset_details();		
		}
	},
	progress: function(file_index, progress){
		var div_width = 440;
		var width_p = ((parseInt(FILES[file_index]['uploaded']) + progress) / FILES[file_index]['size']) * div_width;
		document.getElementById('progressBar_'+file_index).style.width = width_p + 'px';
		percent_loaded =(((parseInt(FILES[file_index]['uploaded']) + progress) / FILES[file_index]['size'])*100).toFixed(1);
				
		document.getElementById('currentPercent_'+file_index).style.display = 'inline';
		document.getElementById('currentStatus_'+file_index).style.display = 'none';
		document.getElementById('currentPercent_'+file_index).innerHTML = percent_loaded + '%';
		
	},
	send : function(file_index){	
		if(FILES[file_index]['state'] == 'editing'){
			UI.display_error("Editing in progress.");
			return false;
		}
		FILE.upload_in_progress = 1;
		//hide edit and remove option when upload start
		document.getElementById('editFile_'+file_index).style.display = 'none';
		document.getElementById('removeFile_'+file_index).style.display = 'none';
		//var request_started = (new Date()).getTime(); // sluzi za merenje vremena koje ce proci dok se ovaj chunk uploaduje - ako je upload trajao previse dugo, smanjiti chunk size
		//alert("Saljem:"+(FILES[file_index].current_part+1)+"/"+FILES[file_index].total_parts);
		if(FILES[file_index].current_part+1 >= FILES[file_index].total_parts){
		//if(FILES[file_index]['size']-FILES[file_index]['uploaded'] <= CHUNK_SIZE){
			//Last part
			FILE.last_chunk = 1;
			FILE.last_part_size  = FILES[file_index]['size'] - FILES[file_index]['uploaded'];
			var slice = FILES[file_index].blob.slice(FILES[file_index].current_part*CHUNK_SIZE, FILES[file_index]['size']-FILES[file_index]['uploaded']);
			
		}else{
			FILE.last_chunk = 0;
			FILE.last_part_size  = 0;
			var slice = FILES[file_index].blob.slice(FILES[file_index].current_part*CHUNK_SIZE, CHUNK_SIZE);
		}	
		var httpUploadRequest = google.gears.factory.create("beta.httprequest");
		var fileURI = 'handle_upload.php?retryAttempt='+FILE.retryAttempt+'&sid='+SID+'&fid='+file_index+'&current_part='+FILES[file_index]['current_part']+'&total_parts='+FILES[file_index]['total_parts']+'&last='+FILE.last_chunk +'&total_size='+FILES[file_index]['size']+'&last_part_size='+FILE.last_part_size +'&partnerId=' + escape(PARTNER_ID)+'&fileName=' + escape(FILES[file_index]['name'].replace(/\s/g,''));
	
		httpUploadRequest.open("POST", fileURI);
		
		httpUploadRequest.setRequestHeader('Content-Range', 'bytes '+FILES[file_index]['uploaded']+'-'+slice.length+'/'+FILES[file_index]['size']);
		//httpUploadRequest.setRequestHeader('Content-Length',slice.length);
		
		httpUploadRequest.upload.onprogress = function(progress){
			FILE.progress(file_index, progress.loaded);
		};
		
		httpUploadRequest.onreadystatechange = function(){
			if(httpUploadRequest.readyState == 4){
				try{
					if(FILE.pause){
						httpUploadRequest.status = null;
					}else{
						if(httpUploadRequest.status == 200){
							
						
							if(httpUploadRequest.getResponseHeader('X-COMPLETE') == 'ERROR'){
								//huge error occured?
								UI.display_error(httpUploadRequest.getResponseHeader('X-RETURN'));
								FILES[file_index]['state'] = 'deleted';
								document.getElementById('currentPercent_'+file_index).style.display = 'none';
								document.getElementById('currentStatus_'+file_index).style.display = 'inline';
								document.getElementById('currentStatus_'+file_index).innerHTML = FILES[file_index]['state'];
								document.getElementById('editFile_'+file_index).style.display = 'none';
								document.getElementById('removeFile_'+file_index).style.display = '';
								document.getElementById('stop_upload').style.display = 'none';
								document.getElementById('start_upload').style.display = '';
								FILE.upload_in_progress = 0;
								FILE.upload();
							}
							//File size of the saved chunk isn't same as the allowed chunk size 256*1024 -> checkout handle_upload.php
							
							else if(httpUploadRequest.getResponseHeader('X-COMPLETE') == 'ERROR-CHUNK')
							{
								/*var c = (httpUploadRequest.getResponseHeader('X-CHUNK');
								c=c+1;
								alert("Treba da se ponovi chunk:"+c);
								*/
								if(FILE.retryAttempt<FILE.maxRetryAttempts)
								{
									FILE.retryAttempt++;
									FILE.tryRetryAttempt = true;
									throw new Exception();
								}
								else
								{
									
									FILES[file_index]['state'] = 'deleted';
									FILE.upload_in_progress = 0;
									document.getElementById('currentPercent_'+file_index).style.display = 'none';
									document.getElementById('currentStatus_'+file_index).style.display = 'inline';
									document.getElementById('currentStatus_'+file_index).innerHTML = FILES[file_index]['state'];
									document.getElementById('editFile_'+file_index).style.display = 'none';
									document.getElementById('removeFile_'+file_index).style.display = '';
									document.getElementById('stop_upload').style.display = 'none';
									document.getElementById('start_upload').style.display = '';
									UI.display_error(httpUploadRequest.getResponseHeader('X-RETURN'));
									FILE.upload();
									
								}
								
							}
							else{
								//Chunk passed retries, set retryAttempts on 0
								FILE.retryAttempt = 0;
								FILE.tryRetryAttempt = false;
								if(FILES[file_index].current_part >= parseInt(FILES[file_index].total_parts-1)){
									//completed
									FILE.complete(file_index);
								}else{
									FILES[file_index].current_part++;
								}
								FILES[file_index]['uploaded'] += CHUNK_SIZE;
								FILE.upload();
							}
							
						}
						
					}
				}
				catch(ex){				
					FILE.upload_in_progress = 0;
					if(FILE.pause){
						UI.display_error("Upload paused. <br />Press 'Start Upload' to resume.");						
					}else if(FILE.retry_upload == null && FILE.pause == false && FILE.tryRetryAttempt==true){
						//Retry chunk on 30 secs
						FILE.retry_upload = setInterval("FILE.delayed_retry();", 30000);
						UI.display_error(httpUploadRequest.getResponseHeader('X-RETURN'));
						setTimeout("$('error_msg').hide()",5000);
						
					}else{
						UI.display_error("Network connection problem. <br />Press 'Start Upload' to resume.");
					}
					
					document.getElementById('stop_upload').style.display = 'none';
					document.getElementById('start_upload').style.display = '';
					//alert('Error: '+ex+'\nLast send chunk: ' + FILES[file_index].current_part )
					//Chunk is lost try to retry upload
					//retry upload every 30 sec
					
					//retry upload every 30 sec
					if(FILE.tryRetryAttempt!=true && FILE.retry_upload == null && FILE.pause == false){
						FILE.retry_upload = setInterval("FILE.delayed_retry();", 30000);
					}
				}
			}
		};
		
		httpUploadRequest.send(slice);
	},
	delayed_retry : function(){
		if(FILE.upload_in_progress == 0){
			clearInterval(FILE.retry_upload);
			FILE.retry_upload = null;
			FILE.start_upload();
		}
	},
	complete : function(file_index) {
		FILES[file_index]['state'] = 'saving';
		document.getElementById('currentPercent_'+file_index).style.display = 'none';
		document.getElementById('currentStatus_'+file_index).style.display = 'inline';
		document.getElementById('currentStatus_'+file_index).innerHTML = FILES[file_index]['state'];
		
		objDate = new Date();
		timestamp = objDate.getTime();
		var url  = 'complete.php?sid=' + encodeURIComponent(SID) +'&fid='+encodeURIComponent(file_index)+'&file=' + encodeURIComponent(FILES[file_index]['name']);
			url += '&file_size='+encodeURIComponent(FILES[file_index]['size'])+'&tags='+encodeURIComponent(FILES[file_index]['tags']);
			url += '&title='+encodeURIComponent(FILES[file_index]['title'])+'&blurb='+encodeURIComponent(FILES[file_index]['description']);
			//url += '&adult='+encodeURIComponent(FILES[file_index]['adult'])+'&channel='+encodeURIComponent(FILES[file_index]['channel']);
			url += '&flag_agegate='+encodeURIComponent(FILES[file_index]['flag_agegate'])+'&channel='+encodeURIComponent(FILES[file_index]['channel']);
			url += '&partner_id='+PARTNER_ID+'&t=' + timestamp;
			url += '&uid='+encodeURIComponent(USER_ID);
			url += '&upload_mode='+encodeURIComponent(UPLOAD_MODE);
			url += '&total_parts='+FILES[file_index]['total_parts'];
			url += '&convert_to='+FILES[file_index]['convert_to'];
			url += '&bitrate='+encodeURIComponent(FILES[file_index]['bitrate']);
			url += '&activationDate='+encodeURIComponent(FILES[file_index]['activationDate']);
		xmlhttp = CMS.createXmlHttp();
		xmlhttp.onreadystatechange = function(){
			if(xmlhttp.readyState == 4){
				if(xmlhttp.status == 200){
					FILE.upload_in_progress = 0;
					if(xmlhttp.getResponseHeader('X-COMPLETE') == 'TOO_BIG'){
						FILES[file_index]['state'] = 'deleted';
						document.getElementById('currentPercent_'+file_index).style.display = 'none';
						document.getElementById('currentStatus_'+file_index).style.display = 'inline';
						document.getElementById('currentStatus_'+file_index).innerHTML = FILES[file_index]['state'];
						document.getElementById('editFile_'+file_index).style.display = 'none';
						document.getElementById('removeFile_'+file_index).style.display = '';
						UI.display_error(xmlhttp.getResponseHeader('X-RETURN'));
					}else if(xmlhttp.getResponseHeader('X-COMPLETE') == 'ERROR'){
						FILES[file_index]['state'] = 'deleted';
						document.getElementById('currentPercent_'+file_index).style.display = 'none';
						document.getElementById('currentStatus_'+file_index).style.display = 'inline';
						document.getElementById('currentStatus_'+file_index).innerHTML = FILES[file_index]['state'];
						document.getElementById('editFile_'+file_index).style.display = 'none';
						document.getElementById('removeFile_'+file_index).style.display = '';
						UI.display_error(xmlhttp.responseText);
					}else {
						FILES[file_index]['state'] = 'completed';
						document.getElementById('currentPercent_'+file_index).style.display = 'none';
						document.getElementById('currentStatus_'+file_index).style.display = 'inline';
						//setTimeout("document.getElementById('queue_element_"+file_index+"').style.display = 'none';", 10000);
						//$('queue_element_'+file_index).morph('background:#008bba; color:#ffffff;');
						Effect.SwitchOff('queue_element_'+file_index);
						document.getElementById('currentStatus_'+file_index).innerHTML = FILES[file_index]['state'];
						FILE.next_in_queue++;
						if(typeof FILES[FILE.next_in_queue] == 'object'){
							FILE.start_upload();
						}else {
							FILE.stop_upload();
						}
					}
				}
			}
		};
		xmlhttp.open('GET', url, true);
		xmlhttp.send(null);
		
	},
	createElementDiv : function() {
		var div = document.createElement('div');
		div.id = 'queue_element_'+FILE.last_file_index;
		div.className = 'fileInQueue';
		var html = '';
			html += '<div class="progressBar" id="progressBar_'+FILE.last_file_index+'"></div>';
			html += '<div class="queueElementInfoBar" id="queueElementInfoBar_'+FILE.last_file_index+'">';
			html += '<div style="float:left;width:180px;margin-right:5px;padding-left:5px;" id="video_title_'+FILE.last_file_index+'">'+FILES[FILE.last_file_index]['title'].substr(0,25)+'</div>';
			html += '<div style="float:left;width:100px;" title="'+FILES[FILE.last_file_index]['name']+'">'+FILES[FILE.last_file_index]['name'].substr(0,14)+'</div>';
			html += '<div id="currentStatus_'+FILE.last_file_index+'" style="float:left;width:55px;">'+FILES[FILE.last_file_index]['state']+'</div>';
			html += '<div id="currentPercent_'+FILE.last_file_index+'" style="position:relative;top:0px;font-weight:bold;font-size:14px;width:55px;margin-right:0px;display:none;margin-left:15px;">10%</div>';
			html += '&nbsp; <div id="editFile_'+FILE.last_file_index+'" class="editFile" onclick="FILE.edit('+FILE.last_file_index+')"><img style="margin-left:30px;position:relative;top:-2px;margin-right:5px;" src="img/ico_edit.gif" /></div>';
			html += '<div id="removeFile_'+FILE.last_file_index+'" class="removeFile" onclick="FILE.remove('+FILE.last_file_index+')"><img style="position:relative;top:-2px;" src="img/ico_delete.gif" /></div>';
			html += '<br clear="all" />';			
			html += '</div>';
			
			div.innerHTML = html;
			document.getElementById('queue_element').appendChild(div);
			
			//UI.current_file_index++;
			FILE.last_file_index++;
			UI.current_file_index = FILE.last_file_index;
	},
	start_upload : function() {
		FILE.pause = false;
		document.getElementById('stop_upload').style.display = '';
		document.getElementById('start_upload').style.display = 'none';

		document.getElementById('error_msg').style.display = 'none';
		//setInterval("FILE.upload();", 200);
		if(FILE.upload_in_progress == 0) {
			FILE.upload();
		}else {
			//UI.display_error("Upload in progress.");
		}
	},
	stop_upload : function() {
		FILE.pause = false;
		document.getElementById('start_upload').style.display = '';
		document.getElementById('stop_upload').style.display = 'none';
		document.getElementById('error_msg').style.display = 'none';
	},
	upload : function(){
		x = FILE.next_in_queue;
		if(typeof FILES[x] == 'object'){
			//alert(FILES[x]['state']);
			if(FILES[x]['state'] == 'deleted'){
				FILE.next_in_queue++;
			}
			if(FILES[x]['state'] == 'ready' || FILES[x]['state'] == 'sending'){
				FILES[x]['state'] = 'sending';
				document.getElementById('currentStatus_'+x).innerHTML = FILES[x]['state'];
				FILE.send(x);
			}
		}else {
			//UI.display_error("Nothing to upload.");
		}
	},
	change_chunk_size : function(file_size) {
		alert(file_size);
		
	}
};

/*
window.onbeforeunload = function() {
	return '';
};
*/

(function(){
	// preload images
	var imgs = new Array('addfile_disabled.png',
				'addfile.png',
				'buttons.gif',
				'buttons.png',
				'cancel_btn.png',
				'close_video_preview.png',
				'error-box-1.png',
				'error-box-2.png',
				'error-box-3.png',
				'pop_add_another.png',
				'pop_start_upload.png',
				'popup1.gif',
				'popup1.png',
				'popup2.png',
				'popup3.png',
				'startupload_disabled.png',
				'upload_bottom_3.jpg',
				'upload_bottom_info.jpg',
				'upload_bottom.jpg',
				'upload_top.jpg');

	for(var i=0; i<imgs.length; i++){
		eval('foo'+i+' = new Image()');
		eval('foo'+i+'.src = "img/'+imgs[i]+'"');
	}
	/*
	//check for gears
	if (!window.google || !google.gears) {
		var message = escape('Please install this application for a fast and reliable upload experience with the SpringBoard platform.');
		UI.gears_install();
		//top.location.href = "http://gears.google.com/?action=install&message=" +message+"&return=http://cms.springboard.gorillanation.com/admin/videos/my_videos";
	}
	*/
	
})();