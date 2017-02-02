<?php 

	session_start();
	error_reporting(E_ALL ^ E_NOTICE);
	ini_set('display_errors', 1);
	
	include 'settings.php';
	
	$pid = $_GET['pid'];
	$sid = $_GET['sid'];
	$uid = $_GET['uid'];
	
	echo $pid ."   ". $sid ."   ". $uid;
	
	$sqlChannels  = "SELECT * FROM channels ";
	$sqlChannels .= "WHERE site_id = '".$pid."' ORDER BY channel_name"; // WHERE parent_id = 0
	$arrChannels = mysql_query($sqlChannels) or die("can't execute query");
	
	$sqlBitRates = "SELECT * FROM bit_rate_tiers WHERE max_bit_rate!=0 AND max_bit_rate <= (SELECT max_bit_rate FROM bit_rate_tiers 
			LEFT JOIN partner_configuration ON partner_configuration.bitrate_tier_id = bit_rate_tiers.id
			WHERE partner_configuration.id = $pid)";
	$arrBitRates = mysql_query($sqlBitRates) or die("can't execute query");
	

?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<title>Upload test 2</title>
		
		<style type="text/css">
			body {
				font-family: Verdana, Arial, sans-serif;
				font-size: 90%;
			}

			h1,h2,h3,h4 {
				margin-top: 0px;
			}

			div.row {
				margin-bottom: 10px;
			}

			*:focus {
				outline: none;
			}

			.floatLeft {
				float: left;
			}

			.floatRight {
				float: right;
			}

			.clear {
				clear: both;
			}

			form {
				padding: 20px;
				border: 1px solid #cccccc;
				border-radius: 10px;
				-moz-border-radius: 10px;
				-webkit-box-shadow: 0 0 10px #ccc;
				-moz-box-shadow: 0 0 10px #ccc;
				box-shadow: 0 0 10px #ccc;
				width: 600px;
				margin: 20px auto;
				background-image: -moz-linear-gradient(top, #ffffff, #f2f2f2);
				background-image: -webkit-gradient(linear, left top, left bottom, from(#ffffff),to(#f2f2f2));
			}

			input, textarea {
				border: 1px solid #ccc;
				font-size: 13pt;
				padding: 5px 10px 5px 10px;
				border-radius: 10px;
				-moz-border-radius: 10px;
				-webkit-transition: all 0.5s ease-in-out;
				-moz-transition: all 0.5s ease-in-out;
				transition: all 0.5s ease-in-out;
			}

			input[type=button] {
				background-image: -moz-linear-gradient(top, #ffffff, #dfdfdf);
				background-image: -webkit-gradient(linear, left top, left bottom, from(#ffffff),
					to(#dfdfdf) );
			}

			input:focus {
				-webkit-box-shadow: 0 0 10px #ccc;
				-moz-box-shadow: 0 0 10px #ccc;
				box-shadow: 0 0 5px #ccc;
				-webkit-transform: scale(1.05);
				-moz-transform: scale(1.05);
				transform: scale(1.05);
			}
			
			textarea:focus {
				-webkit-box-shadow: 0 0 10px #ccc;
				-moz-box-shadow: 0 0 10px #ccc;
				box-shadow: 0 0 5px #ccc;
				-webkit-transform: scale(1.05);
				-moz-transform: scale(1.05);
				transform: scale(1.05);
			}

			#fileToUpload {
				width: 378px;
			}

			#progressIndicator {
				font-size: 10pt;
			}
			
			#fileInfo {
				font-size: 10pt;
				font-style: italic;
				color: #aaa;
				margin-top: 10px;
			}

			#progressBar {
				height: 14px;
				border: 1px solid #cccccc;
				display: none;
				border-radius: 10px;
				-moz-border-radius: 10px;
				background-image: -moz-linear-gradient(top, #66cc00, #4b9500);
				background-image: -webkit-gradient(linear, left top, left bottom, from(#66cc00), to(#4b9500));
			}

			#uploadResponse {
				margin-top: 10px;
				padding: 20px;
				overflow: hidden;
				display: none;
				border-radius: 10px;
				-moz-border-radius: 10px;
				border: 1px solid #ccc;
				box-shadow: 0 0 5px #ccc;
				background-image: -moz-linear-gradient(top, #ff9900, #c77801);
				background-image: -webkit-gradient(linear, left top, left bottom, from(#ff9900), to(#c77801));
			}
		</style>
		
		<script src="js/BrowserDetector.js" type="text/javascript"></script>

		<script type="text/javascript">

			var pid = <?=$pid?>;
			var sid = '<?=$sid?>';
			var uid = <?=$uid?>;
			
			function log(msg){if(console!=undefined)console.log(msg);}
			
			function el(id) {
			
				return document.getElementById(id);
			}

			//File object
	    	function oneFile(fileObject) {
	    		
	    		this.chunkNumber = Math.ceil(fileObject.size / 500000);
	    		this.currentChunk = 0;
	    		this.file = fileObject;
	    		this.status = 'added';
	    		this.resumeSize = 0;
	    		
	    		this.title = '';
	    		this.channel_id = '';
	    		this.tags = '';
	    		this.description = '';
	    		this.age_gate = '';
	    		this.publish_status = '';
	    		this.publish_date = '';
	    		this.conversion = '';
	    		this.bitrate = '';
	    	}
		
			var Html5Uploader = {
				
				bytesUploaded: 0,
				bytesTotal: 0,
				previousBytesLoaded: 0,
				intervalTimer: 0,
				
				filesArrayNew: [],
				current_index: 0,
				resumeChunk: 0,
				//self: this,
				
				xhr: new XMLHttpRequest(),

				addDetails: function() {
					log('addDetails');
					if(el('video_title').value == '') {
						alert('Title field is empty');
						el('video_title').focus();
						return false;
					}
					if(el('video_tags').value == '') {
						alert('Tags field is empty');
						el('video_tags').focus();
						return false;
					}
					if(el('video_description').value == '') {
						alert('Description field is empty');
						el('video_description').focus();
						return false;
					}
					if(el('publish_date').value == '') {
						alert('Publish date field is empty');
						el('publish_date').focus();
						return false;
					}
					var date_value = el('publish_date').value;
					var date_match = date_value.match(/^\d{4}-\d{2}-\d{2}$/gi);
					if(date_match == null) {
						alert('Publish date format is wrong');
						el('publish_date').focus();
						return false;
					}
					//alert(this.filesArrayNew.length);
					//alert(el('video_title').value);
					this.filesArrayNew[this.filesArrayNew.length - 1].title = escape(el('video_title').value);
					this.filesArrayNew[this.filesArrayNew.length - 1].channel_id = escape(el('channel_id').value);
					this.filesArrayNew[this.filesArrayNew.length - 1].tags = escape(el('video_tags').value);
					this.filesArrayNew[this.filesArrayNew.length - 1].description = escape(el('video_description').value);
					this.filesArrayNew[this.filesArrayNew.length - 1].age_gate = escape(el('video_flag_agegate').value);
					this.filesArrayNew[this.filesArrayNew.length - 1].publish_status = escape(el('publish_status').value);
					this.filesArrayNew[this.filesArrayNew.length - 1].publish_date = escape(el('publish_date').value);

					if(this.filesArrayNew[this.filesArrayNew.length - 1].file.type = "video/x-flv") {
						this.filesArrayNew[this.filesArrayNew.length - 1].conversion = '0';
						this.filesArrayNew[this.filesArrayNew.length - 1].bitrate = '1';
					} else {
						this.filesArrayNew[this.filesArrayNew.length - 1].conversion = escape(el('conversion').value);
						this.filesArrayNew[this.filesArrayNew.length - 1].bitrate = escape(el('bitrate').value);
					}

					el('uploadButton').disabled = false;
					el('select_video').style.display = '';
					el('video_details').style.display = 'none';
					resetForm();
					return false;
				},

				removeDetails: function() {
					log('removeDetails');

					el('fileForUpload_' + this.filesArrayNew.length).style.display = 'none';
					this.filesArrayNew.splice(this.filesArrayNew.length -1, 1);
					
					el('select_video').style.display = '';
					el('video_details').style.display = 'none';
					resetForm();
					return false;
				},
				
				fileSelected: function() {
					log('fileSelected');

					var file = el('fileToUpload').files[0];
					
					if (file) {
						//log(file.size);
						var fileSize = 0;
						if (file.size > 1024 * 1024)
							fileSize = (Math.round(file.size * 100 / (1024 * 1024)) / 100).toString() + 'MB';
						else
							fileSize = (Math.round(file.size * 100 / 1024) / 100).toString() + 'KB';
						el('fileInfo').style.display = 'block';
						//document.getElementById('fileName').innerHTML = 'Name: ' + file.name;
						//document.getElementById('fileSize').innerHTML = 'Size: ' + fileSize;
						//document.getElementById('fileType').innerHTML = 'Type: ' + file.type;
						var testObject = new oneFile(file);
						var arraySize = this.filesArrayNew.push(testObject);

						if(file.type == "video/x-flv") {
							el('conversion').disabled = true;
							el('bitrate').disabled = true;
						}
						
						var fileRow = document.createElement('div');
						fileRow.id = 'fileForUpload_' + arraySize;
						fileRow.innerHTML = 'Name: ' + file.name + '      ---      Size: ' + fileSize + '      ---      Type: ' + file.type;
						document.getElementById('fileInfo').appendChild(fileRow);
						el('select_video').style.display = 'none';
						el('video_details').style.display = '';
						
					}
				},
				
				uploadFile: function() {
					log('uploadFile');

					el('stopButton').disabled = false;
					el('pauseButton').disabled = false;
					el('resumeButton').disabled = false;
					
					if(this.filesArrayNew.length == 0) {
						alert('No files');
						return false;
					}
					
					if(this.filesArrayNew[this.current_index].status == 'paused') {
						this.handleResume();
					} else {

						//for transfer speed - Ne koristi se
						//previousBytesLoaded = 0;
						
						//Response div
						el('uploadResponse').style.display = 'none';
						
						//Progress div
						var progressBar = el('progressBar');
						//SET ONLY FOR FIRST CHUNK, IF UPLOAD IS NOT RESUMED
						if(this.filesArrayNew[this.current_index].currentChunk == 0 && this.filesArrayNew[this.current_index].resumeSize == 0) {
							progressBar.style.display = 'block';
							progressBar.style.width = '0px';
							
							//Percentage div
							el('progressNumber').innerHTML = '';
						}
						this.filesArrayNew[this.current_index].status = 'uploading';
						
						//fd.append("fileToUpload", filesArray[current_index].mozSlice(0, 500000));
						
						//
						
						//Set events
						this.xhr.upload.addEventListener("progress", this.uploadProgress, false);
						this.xhr.addEventListener("load", this.uploadComplete, false);
						this.xhr.addEventListener("error", this.uploadFailed, false);
						this.xhr.addEventListener("abort", this.uploadCanceled, false);
						
						//Set request params
						this.xhr.open("POST", "handle_upload_html5.php?pid=" +pid+ "&sid=" +sid+ "&fid=" +this.current_index);
						this.xhr.setRequestHeader("Cache-Control", "no-cache");
						this.xhr.setRequestHeader("X-File-Name", this.filesArrayNew[this.current_index].file.name);
						this.xhr.setRequestHeader("X-File-Size", this.filesArrayNew[this.current_index].file.size);
						this.xhr.setRequestHeader("X-File-Chunk-Number", this.filesArrayNew[this.current_index].chunkNumber);
						this.xhr.setRequestHeader("X-File-Chunk", this.filesArrayNew[this.current_index].currentChunk);
						this.xhr.setRequestHeader("X-File-Resume", this.resumeChunk);
						
						var startChunkPos = this.filesArrayNew[this.current_index].currentChunk * 500000;
						//IF RESUME
						if(this.resumeChunk == 1) {
							startChunkPos = parseInt(this.filesArrayNew[this.current_index].resumeSize) + (this.filesArrayNew[this.current_index].currentChunk * 500000);
						}
						var endChunkPos = startChunkPos + 500000;
						//LAST CHUNK
						if(this.filesArrayNew[this.current_index].currentChunk + 1 == this.filesArrayNew[this.current_index].chunkNumber) {
							endChunkPos = this.filesArrayNew[this.current_index].file.size;
						}
						//IF RESUME AND NOT LAST CHUNK
						if(this.resumeChunk == 1 && !(this.filesArrayNew[this.current_index].currentChunk + 1 == this.filesArrayNew[this.current_index].chunkNumber)) {
							endChunkPos = (this.filesArrayNew[this.current_index].currentChunk +1) * 500000;
						}
						
						if(BrowserDetect.browser == 'Firefox') {
							var chunk = this.filesArrayNew[this.current_index].file.mozSlice(startChunkPos, endChunkPos);
						} else if(BrowserDetect.browser == 'Chrome') {
							var chunk = this.filesArrayNew[this.current_index].file.webkitSlice(startChunkPos, endChunkPos);
						}
						this.xhr.setRequestHeader("X-File-Chunk-Size", (endChunkPos - startChunkPos));
						//xhr.send(fd);
						
						//Send chunk
						this.xhr.send(chunk);
		
						//update transfer speed
						//intervalTimer = setInterval(updateTransferSpeed, 500);
						//
					}
				},
				uploadProgress: function(evt) {
					log('uploadProgress');
					if (evt.lengthComputable) {

						//filesArrayNew[current_index].resumeSize
						if(Html5Uploader.filesArrayNew[Html5Uploader.current_index].resumeSize != 0) {
							//document.getElementById('fileLoaded').innerHTML = evt.loaded + ' + ' + filesArrayNew[current_index].resumeSize;
							Html5Uploader.bytesUploaded = evt.loaded + parseInt(Html5Uploader.filesArrayNew[Html5Uploader.current_index].resumeSize) + (Html5Uploader.filesArrayNew[Html5Uploader.current_index].currentChunk * 500000);
						} else {
							Html5Uploader.bytesUploaded = evt.loaded + Html5Uploader.filesArrayNew[Html5Uploader.current_index].currentChunk * 500000;	
						}
						
						//bytesTotal = evt.total;
						Html5Uploader.bytesTotal = Html5Uploader.filesArrayNew[Html5Uploader.current_index].file.size;
						
						el('fileLoaded').innerHTML = Html5Uploader.bytesUploaded;
						el('fileTotal').innerHTML = Html5Uploader.bytesTotal;
						//var percentComplete = Math.round(evt.loaded * 100 / evt.total);
						var percentComplete = Math.round(Html5Uploader.bytesUploaded * 100 / Html5Uploader.bytesTotal);
						var bytesTransfered = '';
						if (Html5Uploader.bytesUploaded > 1024*1024)
							bytesTransfered = (Math.round(Html5Uploader.bytesUploaded * 100/(1024*1024))/100).toString() + 'MB';
						else if (Html5Uploader.bytesUploaded > 1024)
							bytesTransfered = (Math.round(Html5Uploader.bytesUploaded * 100/1024)/100).toString() + 'KB';
						else
							bytesTransfered = (Math.round(Html5Uploader.bytesUploaded * 100)/100).toString() + 'Bytes';

						el('progressNumber').innerHTML = percentComplete.toString() + '%';
						el('progressBar').style.width = (percentComplete * 5.55).toString() + 'px';
						el('transferBytesInfo').innerHTML = bytesTransfered;
						
					} else {
						el('progressBar').innerHTML = 'unable to compute';
					}
				},
				uploadComplete: function(evt) {
					log('uploadComplete');
					log(Html5Uploader.xhr.responseText);
					var responseText = trim(Html5Uploader.xhr.responseText);
					if(responseText == 'SUCCESS') {
						if(Html5Uploader.filesArrayNew[Html5Uploader.current_index].currentChunk + 1 == Html5Uploader.filesArrayNew[Html5Uploader.current_index].chunkNumber) {
	
							//Fire complete.php
							var xhrTemp = new XMLHttpRequest();
	
							var get_request_url = "?channel="+Html5Uploader.filesArrayNew[Html5Uploader.current_index].channel_id;
							get_request_url += "&title=" + Html5Uploader.filesArrayNew[Html5Uploader.current_index].title;
							get_request_url += "&tags=" + Html5Uploader.filesArrayNew[Html5Uploader.current_index].tags;
							get_request_url += "&blurb=" + Html5Uploader.filesArrayNew[Html5Uploader.current_index].description;
							get_request_url += "&flag_agegate=" + Html5Uploader.filesArrayNew[Html5Uploader.current_index].age_gate;
							get_request_url += "&activationDate=" + Html5Uploader.filesArrayNew[Html5Uploader.current_index].publish_date;
							get_request_url += "&convert_to=" + Html5Uploader.filesArrayNew[Html5Uploader.current_index].conversion;
							get_request_url += "&bitrate=" + Html5Uploader.filesArrayNew[Html5Uploader.current_index].bitrate;
							get_request_url += "&upload_mode=site";
							get_request_url += "&file_size=" +Html5Uploader.filesArrayNew[Html5Uploader.current_index].file.size;
							get_request_url += "&file=" +Html5Uploader.filesArrayNew[Html5Uploader.current_index].file.name;
							get_request_url += "&partner_id="+pid;
							get_request_url += "&uid=" +uid;
							get_request_url += "&fid=" +Html5Uploader.current_index;
							get_request_url += "&sid=" +sid;
							
							/*xhrTemp.open("GET", "complete.php"+get_request_url);
							xhrTemp.setRequestHeader("Cache-Control", "no-cache");
							
							xhrTemp.send(null);*/
							//log(get_request_url);
	

							//Next File
							Html5Uploader.filesArrayNew[Html5Uploader.current_index].status = 'uploaded';
							Html5Uploader.filesArrayNew[Html5Uploader.current_index].resumeSize = 0;
							Html5Uploader.current_index++;
							
							//HACK FOR FF
							if(BrowserDetect.browser == 'Firefox') {
								el('progressNumber').innerHTML = '100%';
								el('progressBar').style.width = '555px';
							}
	
							
							
							//xhrTemp.addEventListener("load", this.setResumeSize, false);
							//evt.target.responseText;
							
							/*	
							String get_request_url = this.uploadPolicy.getGetURL();
							get_request_url += "&channel="+channel_id;
							get_request_url += "&title="+video_title;
							get_request_url += "&tags="+tags;
							get_request_url += "&blurb="+description;
							get_request_url += "&flag_agegate="+age_gate;
							get_request_url += "&activationDate="+activationDate;
							get_request_url += "&convert_to="+convert_to;
							get_request_url += "&bitrate="+bitrate;
							get_request_url += "&upload_mode=site";
							get_request_url += "&file_size=" +uploadedFile.getFileLength();
							get_request_url += "&file=" +file_name;
							get_request_url += "&partner_id=" +partner_id;
							get_request_url += "&uid=" +uid;
							get_request_url += "&fid=" +uploadedFile.GetFileId();
							get_request_url += "&sid=" +sid;
	
							*/
	
							
							
							
						} else {
							//Next chunk
							Html5Uploader.filesArrayNew[Html5Uploader.current_index].currentChunk++;
							Html5Uploader.filesArrayNew[Html5Uploader.current_index].resumeSize = 0;
						}
						
						//clearInterval(intervalTimer);
						var uploadResponse = el('uploadResponse');
						uploadResponse.innerHTML = evt.target.responseText;
						uploadResponse.style.display = 'block';
						
						Html5Uploader.resumeChunk = 0;
						
						if(Html5Uploader.current_index < Html5Uploader.filesArrayNew.length) {
							Html5Uploader.uploadFile();
						}
					} else {
						Html5Uploader.filesArrayNew[Html5Uploader.current_index].status = 'aborted';
						Html5Uploader.xhr.abort();
					}
				},
				uploadFailed: function(evt) {
					log('uploadFailed');
					if(Html5Uploader.filesArrayNew[Html5Uploader.current_index].status != 'aborted') {
						alert("An error occurred while uploading the file.");	
					}
				},
				uploadCanceled: function(evt) {
					log('uploadCanceled');

					el('stopButton').disabled = true;
					el('pauseButton').disabled = true;
					
					if(Html5Uploader.filesArrayNew[Html5Uploader.current_index].status == 'aborted') {
						Html5Uploader.filesArrayNew[Html5Uploader.current_index].currentChunk = 0;
						
						el('progressBar').style.width = '0px';
						el('progressNumber').innerHTML = '';
					}
					
					if(Html5Uploader.filesArrayNew[Html5Uploader.current_index].status == 'aborted') {
						alert("The upload has been canceled by the user or the browser dropped the connection.");	
					}
				},
				abortUpload: function() {
					log('abortUpload');
					this.filesArrayNew[this.current_index].status = 'aborted';
					this.xhr.abort();
				},
				pauseUpload: function() {
					log('pauseUpload');
					this.filesArrayNew[this.current_index].status = 'paused';
					this.xhr.abort();
				},
				handleResume: function() {
					log('handleResume');
					var xhrTemp = new XMLHttpRequest();
					
					xhrTemp.addEventListener("load", this.setResumeSize, false);
					//evt.target.responseText;
					
					xhrTemp.open("GET", "handle_upload_html5.php?file_size=1&pid=" +pid+ "&sid=" +sid+ "&fid=" +this.current_index);
					xhrTemp.setRequestHeader("Cache-Control", "no-cache");
					xhrTemp.setRequestHeader("X-File-Name", Html5Uploader.filesArrayNew[Html5Uploader.current_index].file.name);
					xhrTemp.setRequestHeader("X-File-Size", Html5Uploader.filesArrayNew[Html5Uploader.current_index].file.size);
					xhrTemp.setRequestHeader("X-File-Chunk", this.filesArrayNew[this.current_index].currentChunk);
					
					xhrTemp.send(null);
				},
				setResumeSize: function(evt) {
					log('setResumeSize');
					Html5Uploader.filesArrayNew[Html5Uploader.current_index].status = 'uploading';
					Html5Uploader.filesArrayNew[Html5Uploader.current_index].resumeSize = evt.target.responseText;
					Html5Uploader.resumeChunk = 1;
					
					Html5Uploader.uploadFile();
				}
			}
			
			

			function updateTransferSpeed() {
				var currentBytes = bytesUploaded;
				var bytesDiff = currentBytes - previousBytesLoaded;
				if (bytesDiff == 0) return;
				previousBytesLoaded = currentBytes;
				bytesDiff = bytesDiff * 2;
				var bytesRemaining = bytesTotal - previousBytesLoaded;
				var secondsRemaining = bytesRemaining / bytesDiff;

				var speed = "";
				if (bytesDiff > 1024 * 1024)
					speed = (Math.round(bytesDiff * 100/(1024*1024))/100).toString() + 'MBps';
				else if (bytesDiff > 1024)
					speed =  (Math.round(bytesDiff * 100/1024)/100).toString() + 'KBps';
				else
					speed = bytesDiff.toString() + 'Bps';
				document.getElementById('transferSpeedInfo').innerHTML = speed;
				document.getElementById('timeRemainingInfo').innerHTML = '| ' + secondsToString(secondsRemaining);        
			}

			function secondsToString(seconds) {
				var h = Math.floor(seconds / 3600);
				var m = Math.floor(seconds % 3600 / 60);
				var s = Math.floor(seconds % 3600 % 60);
				return ((h > 0 ? h + ":" : "") + (m > 0 ? (h > 0 && m < 10 ? "0" : "") + m + ":" : "0:") + (s < 10 ? "0" : "") + s);
			}
 
			function buttonsStatus(disableStatus) {
				document.getElementById('uploadButton').disabled = disableStatus;
				document.getElementById('stopButton').disabled = disableStatus;
				document.getElementById('pauseButton').disabled = disableStatus;
				document.getElementById('resumeButton').disabled = disableStatus;
			}

			function resetForm() {
				el('video_title').value = '';
				el('channel_id').selectedIndex = 0;
				el('video_tags').value = '';
				el('video_description').value = '';
				el('video_flag_agegate').selectedIndex = 0;
				el('publish_status').selectedIndex = 1;
				el('publish_date').value = '';

				el('conversion').disabled = false;
				el('bitrate').disabled = false;
				el('conversion').selectedIndex = 0;
				el('bitrate').selectedIndex = 0;
			}

			function trim(stringToTrim) {
				return stringToTrim.replace(/^\s+|\s+$/g,"");
			}
		</script>
	</head>
<body>
	<form id="upload_form" enctype="multipart/form-data" method="post" action="handle_upload_html5.php">
		<div id="select_video">
			<div class="row">
				<label for="fileToUpload">Select a File to Upload</label>
				<br />
	
				<input type="file" name="fileToUpload" id="fileToUpload" onchange="Html5Uploader.fileSelected();" />
			</div>
			<div class="row">
				<input type="button" onclick="Html5Uploader.uploadFile()" disabled="disabled" value="Upload" id="uploadButton" />
				<input type="button" onclick="Html5Uploader.abortUpload()" disabled="disabled" value="Stop" id="stopButton" />
				<input type="button" onclick="Html5Uploader.pauseUpload()" disabled="disabled" value="Pause" id="pauseButton" />
				<input type="button" onclick="Html5Uploader.uploadFile()" disabled="disabled" value="Resume" id="resumeButton" />
			</div>
			<div id="fileInfo">
				<div id="fileName"></div>
				<div id="fileSize"></div>
				<div id="fileType"></div>
				<div id="fileLoaded"></div>
				<div id="fileTotal"></div>
	
			</div>
			<div class="row"></div>
			<div id="progressIndicator">
				<div id="progressBar" class="floatLeft"></div>
				<div id="progressNumber" class="floatRight">&nbsp;</div>
				<div class="clear"></div>
				<div>
					<div id="transferSpeedInfo" class="floatLeft" style="width: 80px;">&nbsp;</div>
	
					<div id="timeRemainingInfo" class="floatLeft" style="margin-left: 10px;">&nbsp;</div>
					<div id="transferBytesInfo" class="floatRight" style="text-align: right;">&nbsp;</div>
					<div class="clear"></div>
				</div>
				<div id="uploadResponse"></div>
			</div>
		</div>
		<div id="video_details" style="display: none;">
			<br><br>
			Channel
			<br>
			<select name="channel_id" id="channel_id">
				<?php 
                while($row = mysql_fetch_assoc($arrChannels)) {
					echo '<option value="'.$row['id'].'">'.$row['channel_name'].'</option>';
				}
                ?>
			</select>
			<br><br>
			<font color="red">*</font>Title
			<br>
			<input name="video_title" id="video_title" size="40" />
			<br><br>
			<font color="red">*</font>Tags
			<br>
			<input name="video_tags" id="video_tags" size="40" />
			<br><br>
			<font color="red">*</font>Description
			<br>
			<textarea name="video_description" id="video_description" rows="7" cols="55"></textarea>
			<br><br>
			Age gate
			<br>
			<select id="video_flag_agegate" name="video_flag_agegate">
				<option selected="" value="0">All</option>
				<option value="1">17+ (ESRB - Mature rated)</option>
				<option value="2">18+ (ESRB - Adults only)</option>
				<option value="3">21+ (Alcohol)</option>
			</select>
			<br><br>
			Publish status
			<br>
			<select id="publish_status" name="publish_status">
				<option value="-1">PUBLISH PENDING</option>
				<option value="1" selected="">PUBLISHED</option>
				<option value="3">BANNED</option>
				<option id="optionPublishedDate" value="2">PUBLISH ON A DATE</option>
			</select>
			<br><br>
			<font color="red">*</font>Publish date (YYYY-MM-DD)
			<br>
			<input name="publish_date" id="publish_date" size="40" />
			<br><br>
			Conversion
			<br>
			<select id="conversion" name="conversion">
				<option value="1">H264</option>
				<option value="0">VP6</option>
			</select>
			<br><br>
			Bit rate
			<br>
			<select id="bitrate" name="bitrate">
			<?php 
			if (!$arrBitRates) {
				echo '<option value="1">256</option>';
			} else {
				while($row = mysql_fetch_assoc($arrBitRates)) {
					echo '<option value="'.$row['id'].'">'.$row['max_bit_rate'].' Kbps</option>';
				}
			}
			?>
			</select>
			<br><br>
			<input type="button" onclick="Html5Uploader.addDetails()" value="Add" id="addFile" />
			<input type="button" onclick="Html5Uploader.removeDetails()" value="Cancel" id="addFileCancel" />
		</div>
	</form>
	
	<?php 
	
	?>
</body>
</html>