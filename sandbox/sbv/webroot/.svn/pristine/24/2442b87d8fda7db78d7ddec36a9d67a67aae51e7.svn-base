/*  CMS FUNCTIONS */
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
		UI.validation();
	},
	hide_details : function(){
		document.getElementById('video_details').style.display = 'none';
		
		if(FILES[UI.current_file_index]['state'] == 'edit'){
			FILES[UI.current_file_index]['state'] = 'ready';
		}
	},
	reset_details : function(){
		document.getElementById('title').value='';
		document.getElementById('channel').value='';
		document.getElementById('tags').value='';
		document.getElementById('description').value='';
		document.getElementById('adult').checked=false;	
		document.getElementById('buttonAddMore').disabled=true;
		document.getElementById('buttonStartUpload').disabled=true;	
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
				allowed = true;
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
	},
	showStopButton : function(){
		document.getElementById('video_details').style.display = 'none';
		
		if(FILES[UI.current_file_index]['state'] == 'edit'){
			FILES[UI.current_file_index]['state'] = 'ready';
		}
	}
};
/*  FILE UPLOAD FUNCTIONS */
var FILE = {
	last_file_index:0,
	next_in_queue:0,
	last_chunk:0,
	last_part_size:0,
	upload_in_progress:0,
	stop_upload:0,
	retry_upload:null,
	add:function(){
		var desktop = google.gears.factory.create('beta.desktop');
		var fileOptions = {singleFile:true, filter:ALLOWED_FILES};
		desktop.openFiles(this.__get, fileOptions);
	},
	resetFiles: function(){
		FILE.last_file_index = 0;
		FILE.next_in_queue = 0;
		FILE.last_chunk = 0;
		FILE.last_part_size = 0;
		FILE.upload_in_progress = 0;
		FILE.retry_upload = null;
		UI.current_file_index = 0;
		//FILE.stop_upload = 0;
		
		for(x in FILES){
			if(FILES[x]['state'] != undefined){
				if(FILES[x]['state'] != 'completed' && FILES[x]['state'] !='deleted'){
					FILES[x]['uploaded'] = 0;
					FILES[x]['current_part'] = 0;
					FILES[x]['state'] = 'ready';
					document.getElementById('progressBar_'+x).style.width = '0px';
					document.getElementById('currentPercent_'+x).innerHTML = '0%';
					document.getElementById('currentPercent_'+x).style.display = 'none';
					document.getElementById('currentStatus_'+x).innerHTML = FILES[x]['state'];
					document.getElementById('currentStatus_'+x).style.display = 'inline';
					document.getElementById('editFile_'+x).style.display = 'inline';
					document.getElementById('removeFile_'+x).style.display = 'inline';
				}
			}
		}		
		document.getElementById('stop_upload').style.display = 'none';
		document.getElementById('start_upload').style.display = '';
		
		console.debug('FILE.stop_upload: '+FILE.stop_upload);
	
	},
	stopAll: function(){
		FILE.stop_upload = 1;
		FILE.resetFiles();
		console.debug('stopAll');
	},
	__get:function (files){
		// for(var i=0; i<files.length; i++){ 		Reserved for future use. Now we select one by one file.
		// }
		
		try{
			var i = 0; // Because we use single file 
			var input ={ title		: null,
						 channel	: 0,
						 tags		: null,
						 description: null,
						 adult		: 0,
						 name 		: files[i].name, 
						 blob 		: files[i].blob, 
						 size 		: files[i].blob.length, 
						 uploaded 	: 0, //bytes
						 current_part: 0, 
						 total_parts: parseInt(files[i].blob.length/CHUNK_SIZE) + ((files[i].blob.length%CHUNK_SIZE)/(files[i].blob.length%CHUNK_SIZE)), 
						 state 		: 'ready' }; //completed, deleted, paused, editing, saving, sending
			//check file size
			if(files[i].blob.length < MAX_FILE_SIZE) {
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
			document.getElementById('tags').value = FILES[id]['tags'];
			document.getElementById('description').value = FILES[id]['description'];
			if(FILES[id]['adult'] == 1) { document.getElementById('adult').checked = true;}
			
			//show popup
			div_video_details = document.getElementById('video_details');
			div_video_details.style.display = 'block';
			
			//save 
			FILES[UI.current_file_index]['title'] = document.getElementById('title').value;
			FILES[UI.current_file_index]['channel'] = document.getElementById('channel').value;
			FILES[UI.current_file_index]['tags'] = document.getElementById('tags').value;
			FILES[UI.current_file_index]['description'] = document.getElementById('description').value;
			if(document.getElementById('adult').checked){ video_adult = 1; } else { video_adult = 0;}
			FILES[UI.current_file_index]['adult'] = video_adult;
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
	save_details : function(){
		var file_id = FILE.last_file_index;
		FILES[file_id]['title'] = document.getElementById('title').value;
		FILES[file_id]['channel'] = document.getElementById('channel').value;
		FILES[file_id]['tags'] = document.getElementById('tags').value;
		FILES[file_id]['description'] = document.getElementById('description').value;
		if(document.getElementById('adult').checked){ video_adult = 1; } else { video_adult = 0;}
		FILES[file_id]['adult'] = video_adult;
		
		if(FILES[file_id]['state'] == 'edit'){
			FILES[file_id]['state'] = 'ready';
		}
		
	},
	edit_details : function(){
		var file_id = UI.current_file_index;
		FILES[file_id]['title'] = document.getElementById('title').value;
		FILES[file_id]['channel'] = document.getElementById('channel').value;
		FILES[file_id]['tags'] = document.getElementById('tags').value;
		FILES[file_id]['description'] = document.getElementById('description').value;
		if(document.getElementById('adult').checked){ video_adult = 1; } else { video_adult = 0;}
		FILES[file_id]['adult'] = video_adult;
		
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
	show_start_upload : function() {
		document.getElementById('start_upload').style.display = '';
		document.getElementById('stop_upload').style.display = 'none';
	},
	progress: function(file_index, progress){
		if(FILE.stop_upload == 1){
			FILE.resetFiles();
			return false;
		}
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
		//stop upload
		if(FILE.stop_upload == 1){
			FILE.resetFiles();
			return false;
		}
		
		FILE.upload_in_progress = 1;
		
		//hide edit and remove option when upload start
		document.getElementById('editFile_'+file_index).style.display = 'none';
		document.getElementById('removeFile_'+file_index).style.display = 'none';
		//var request_started = (new Date()).getTime(); // sluzi za merenje vremena koje ce proci dok se ovaj chunk uploaduje - ako je upload trajao previse dugo, smanjiti chunk size
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
		var fileURI = 'handle_upload.php?sid='+SID+'&fid='+file_index+'&current_part='+FILES[file_index]['current_part']+'&total_parts='+FILES[file_index]['total_parts']+'&last='+FILE.last_chunk +'&total_size='+FILES[file_index]['size']+'&last_part_size='+FILE.last_part_size;
		httpUploadRequest.open("POST", fileURI);
		httpUploadRequest.upload.onprogress = function(progress){
			if(FILE.stop_upload == 1){
				FILE.resetFiles();
				httpUploadRequest.upload.onprogress = null;
				return false;
			}
			FILE.progress(file_index, progress.loaded);
		};
		httpUploadRequest.onreadystatechange = function(){
			//stop upload
			if(FILE.stop_upload == 1){
				FILE.resetFiles();
				httpUploadRequest.onreadystatechange = null;
				return false;
			}
			if(httpUploadRequest.readyState == 4){
				try{
					if(httpUploadRequest.status == 200){
						//alert('1');
						//var request_completed = (new Date()).getTime(); // sluzi za merenje vremena koje ce proci dok se ovaj chunk uploaduje - ako je upload trajao previse dugo, smanjiti chunk size
						//console.debug((request_completed - request_started)/1000);
						//alert(httpUploadRequest.getResponseHeader('X-COMPLETE'));
						if(httpUploadRequest.getResponseHeader('X-COMPLETE') == 'ERROR'){
							UI.display_error(httpUploadRequest.getResponseHeader('X-RETURN'));
							FILES[file_index]['state'] = 'deleted';
							FILE.upload_in_progress = 0;
							FILE.upload();
						}else{
							if(FILES[file_index].current_part >= parseInt(FILES[file_index].total_parts-1)){
								//completed
								FILE.complete(file_index);
							}else{
								FILES[file_index].current_part++;
							}
							FILES[file_index]['uploaded'] += CHUNK_SIZE;
							FILE.upload();
							//alert('Response: '+ httpUploadRequest.responseText);
						}
						
					}
				}catch(ex){	
					if(FILE.stop_upload == 1){
						FILE.resetFiles();
						return false;
					}
					FILE.upload_in_progress = 0;
					UI.display_error("Network connection problem. <br />Press 'Start Upload' to resume.");
					document.getElementById('start_upload').style.display = '';
					document.getElementById('stop_upload').style.display = 'none';
					//alert('Error: '+ex+'\nLast send chunk: ' + FILES[file_index].current_part )
					
					//retry upload every 30 sec
					if(FILE.retry_upload == null && FILE.stop_upload == 0){
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
		var url  = 'complete.php?sid=' + escape(SID) +'&fid='+escape(file_index)+'&file=' + escape(FILES[file_index]['name'].replace(/\s/g,''));
			url += '&file_size='+escape(FILES[file_index]['size'])+'&tags='+escape(FILES[file_index]['tags']);
			url += '&title='+escape(FILES[file_index]['title'])+'&blurb='+escape(FILES[file_index]['description']);
			url += '&adult='+escape(FILES[file_index]['adult'])+'&channel='+escape(FILES[file_index]['channel']);
			url += '&partner_id='+PARTNER_ID+'&t=' + timestamp;
			url += '&uid='+escape(USER_ID);
			url += '&upload_mode='+escape(UPLOAD_MODE);
			url += '&total_parts='+FILES[file_index]['total_parts'];
		xmlhttp = CMS.createXmlHttp();
		xmlhttp.onreadystatechange = function(){
			if(xmlhttp.readyState == 4){
				if(xmlhttp.status == 200){
					FILE.upload_in_progress = 0;
					if(xmlhttp.getResponseHeader('X-COMPLETE') == 'ERROR'){
						FILES[file_index]['state'] = 'deleted';
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
			html += '<div style="float:left;width:85px;" title="'+FILES[FILE.last_file_index]['name']+'">'+FILES[FILE.last_file_index]['name'].substr(0,10)+'</div>';
			html += '<div id="currentStatus_'+FILE.last_file_index+'" style="float:left;width:55px;margin-left:15px;">'+FILES[FILE.last_file_index]['state']+'</div>';
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
		FILE.stop_upload = 0;
		document.getElementById('start_upload').style.display = 'none';
		document.getElementById('stop_upload').style.display = '';
		
		document.getElementById('error_msg').style.display = 'none';
		//setInterval("FILE.upload();", 200);
		if(FILE.upload_in_progress == 0) {
			FILE.upload();
		}else {
			UI.display_error("Upload in progress.");
		}

	},
	upload : function(){
		x = FILE.next_in_queue;
		if(typeof FILES[x] == 'object'){
			//alert(FILES[x]['state']);
			if(FILES[x]['state'] == 'deleted'){
				FILE.next_in_queue++;
			}
			if(FILES[x]['state'] == 'ready' || FILES[x]['state'] == 'sending'){
				//show stop button
				document.getElementById('start_upload').style.display = 'none';
				document.getElementById('stop_upload').style.display = '';
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