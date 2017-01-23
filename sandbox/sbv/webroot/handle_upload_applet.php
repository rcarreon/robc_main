<?php 
		
	include 'settings.php';
	
	$classparams = array();
	$classparams['allowed_mime_types'] = 'all';					// array of allowed MIME types
	$classparams['allowed_file_extensions'] = 'all';			// array of allowed file extensions
	$classparams['tmp_prefix'] = 'jutmp.';
	$classparams['allow_zerosized'] = true;
	
	//$myFile = "UploadDebug.txt";
	//$fh = fopen($myFile, 'a') or die("can't open file");
	
	if(!empty($_FILES)) {
		$jupart = (isset($_POST['jupart'])) ? (int)$_POST['jupart'] : 0;
		if(!isset($_POST['sid'])) {
			//fwrite($fh, "Required POST variable Session ID is missing\n");
			exit;
		}
		if(!isset($_POST['pid'])) {
			//fwrite($fh, "Required POST variable Partner ID is missing\n");
			exit;
		}
		
		$logFileName = $_POST['pid']. '_' .date('Ymd'). '_' .$_POST['sid']. '_upload_log.txt';
		$partDebug = '';
		
		if(!isset($_POST['md5sum'])) {
	   		//fwrite($fh, "Required POST variable md5sum is missing\n");
	   		exit;
		}
		if(!isset($_POST['fid'])) {
			//fwrite($fh, "Required POST variable File ID is missing\n");
			exit;
		}
		
	} else {
		//$jupart = 0;
		echo "SUCCESS";
		exit;
	}
	
	//fwrite($fh, "\n===============START=============\n");
	addToDebug("===============START=============\n");
	
	if($jupart > 1) {
		//check size
		//$current_file_size = filesize($UPLOAD_DIR .$_POST['sid']. "." .$_POST['fid']. ".final");
		$current_file_size = getFileSize($UPLOAD_DIR .$_POST['sid']. "." .$_POST['fid']. ".final");
		if(!((($jupart-1) * 2000000) == $current_file_size)) {
			//fwrite($fh, "File size mismatch, chunk number = " .$jupart. " file size = " .$current_file_size. " \n");
			addToDebug("Partner = " 		.$_POST['pid']);
			addToDebug("Session id = " 		.$_POST['sid']);
			addToDebug("File name = " 		.$_FILES['0']['name']['0']);
			addToDebug("File size = " 		.$_POST['filesize']);
			addToDebug("File id = " 		.$_POST['fid']);
			addToDebug("Chunk number = " 	.$jupart);
			addToDebug("Retry = " 			.$_POST['retryIndicator']);
			addToDebug("File size mismatch, chunk number = " .$jupart. ", file size = " .$current_file_size);
			file_put_contents($LOG_DIR.$_POST['pid'].'/'.date('Ymd').'/'.$logFileName, $partDebug, FILE_APPEND);
			sendDebugEmail($partDebug . "\n");
			exit;
		}
		addToDebug("Current file size = " .$current_file_size);
		//$tmpname = $UPLOAD_DIR.$classparams['tmp_prefix'].$sid . "." .$fid. ".final";
	}
	
	$cnt = 0;
	foreach ($_FILES as $key => $value) {
			
	    //$jupart			= (isset($_POST['jupart']))		 		? (int)$_POST['jupart']		: 0;
	    $jufinal		= (isset($_POST['jufinal']))	 		? (int)$_POST['jufinal']	: 1;
	    $relpaths		= (isset($_POST['relpathinfo'])) 		? $_POST['relpathinfo']		: null;
	    $md5sums		= (isset($_POST['md5sum']))				? $_POST['md5sum']			: null;
	    $mimetypes 		= (isset($_POST['mimetype'])) 	 		? $_POST['mimetype']		: null;
	    $fid 			= (isset($_POST['fid'])) 	 			? $_POST['fid']				: null;
	    $sid 			= (isset($_POST['sid'])) 	 			? $_POST['sid']				: null;
	    $pid 			= (isset($_POST['pid'])) 	 			? $_POST['pid']				: null;
	    $retryIndicator = (isset($_POST['retryIndicator'])) 	? $_POST['retryIndicator']	: null;
	    $file_size 		= (isset($_POST['filesize']))  			? $_POST['filesize']		: null;
	    
	    //$relpaths = (isset($_POST["relpathinfo$cnt"])) ? $_POST["relpathinfo$cnt"] : null;
    	//$md5sums = (isset($_POST["md5sum$cnt"])) ? $_POST["md5sum$cnt"] : null;
    	//fwrite($fh, "===========RECEIVED=============\n\n");
    	addToDebug("===========RECEIVED START=============");
    	//fwrite($fh, "FILE: " .print_r($value, true). "\n");
    	addToDebug("FILE: " .print_r($value, true));
    	//fwrite($fh, "fid: " .$fid. "\n");
    	addToDebug("fid: " .$fid);
    	//fwrite($fh, "sid: " .$sid. "\n");
    	addToDebug("sid: " .$sid);
    	//fwrite($fh, "pid: " .$pid. "\n");
    	addToDebug("pid: " .$pid);
    	//fwrite($fh, "file size: " .$file_size. "\n");
    	addToDebug("file size: " .$file_size);
    	//fwrite($fh, "jupart: " .$jupart. "\n");
    	addToDebug("jupart: " .$jupart);
    	addToDebug("retry: " .$retryIndicator);
    	//fwrite($fh, "jufinal: " .$jufinal. "\n");
    	addToDebug("jufinal: " .$jufinal);
    	$relapath_array_string = print_r($relpaths, true);
    	//fwrite($fh, "relpaths: " .$relapath_array_string. "\n");
    	addToDebug("relpaths: " .$relapath_array_string);
    	//fwrite($fh, "relpaths1: " .printArrayMadafaka($relpaths). "\n");
    	$md5sums_array_string = print_r($md5sums, true);
    	//fwrite($fh, "md5sums: " .$md5sums_array_string. "\n");
    	addToDebug("md5sums: " .$md5sums_array_string);
    	$mimetypes_array_string = print_r($mimetypes, true);
    	//fwrite($fh, "mimetypes: " .$mimetypes_array_string. "\n");
    	addToDebug("mimetypes: " .$mimetypes_array_string);
    	//fwrite($fh, "===========RECEIVED=============\n\n");
    	addToDebug("===========RECEIVED END=============");
    	
    	addToDebug("===========HANDLE CHUNK START=============");
    	
		if (gettype($relpaths) == 'string') {
	        $relpaths = array($relpaths);
	    }
	    if (gettype($md5sums) == 'string') {
	        $md5sums = array($md5sums);
	    }
	    if (!is_array($md5sums)) {
	        //fwrite($fh, "Expecting an array of MD5 checksums\n");
	        addToDebug("Expecting an array of MD5 checksums");
	    }
		if (!is_array($relpaths)) {
	        //fwrite($fh, "Expecting an array of relative paths\n");
	        addToDebug("Expecting an array of relative paths");
	    }
	    if (!is_array($mimetypes)) {
            //fwrite($fh, "Expecting an array of MIME types\n");
            addToDebug("Expecting an array of MIME types");
        }
        // Check the MIME type (note: this is easily forged!)
        if (isset($classparams['allowed_mime_types']) && is_array($classparams['allowed_mime_types'])) {
        	if (!in_array($mimetypes[$cnt], $classparams['allowed_mime_types'])) {
        		//fwrite($fh, "MIME type " .$mimetypes[$cnt]. " not allowed\n");
        		addToDebug("MIME type " .$mimetypes[$cnt]. " not allowed");
        	}
        }
		if (isset($classparams['allowed_file_extensions']) && is_array($classparams['allowed_file_extensions'])) {
        	$fileExtension = substr(strrchr($value['name'][$cnt], "."), 1);
        	if (!in_array($fileExtension, $classparams['allowed_file_extensions'])) {
        		//fwrite($fh, "File extension " .$fileExtension. " not allowed\n");
        		addToDebug("File extension " .$fileExtension. " not allowed");
        	}
        }
        
        $dstdir = $UPLOAD_DIR; //$sid . "." .$fid. ".final";
	    $dstname = $dstdir.$sid . "." .$fid. ".final";//$classparams['tmp_prefix'].$sid;
	    $tmpname = $dstdir.$classparams['tmp_prefix'].$sid . "." .$fid. ".final";//'tmp'.$sid;
	    
	    //fwrite($fh, "\n\n");
	    addToDebug("\n\n");
	    //fwrite($fh, "Destionation Dir: " .$dstdir. "\n");
	    addToDebug("Destionation Dir: " .$dstdir);
	    //fwrite($fh, "Destionation Dir Name: " .$dstname. "\n");
	    addToDebug("Destionation Dir Name: " .$dstname);
	    //fwrite($fh, "Destionation Dir Temp: " .$tmpname. "\n");
	    addToDebug("Destionation Dir Temp: " .$tmpname);
	    
	    //Controls are now done. Let's store the current uploaded files properties in an array, for future use.
		$tmp_name 						= $value['tmp_name'][$cnt];
		
		//fwrite($fh, "Trying to copy: " .$tmp_name. " to " .$tmpname. "\n");
		addToDebug("Trying to copy: " .$tmp_name. " to " .$tmpname);
		if (!move_uploaded_file($tmp_name, $tmpname)) {
        	//fwrite($fh, "Unable to move uploaded file (from" .$tmp_name. " to " .$tmpname. ")\n");
        	addToDebug("Unable to move uploaded file (from" .$tmp_name. " to " .$tmpname. ")");
			file_put_contents($LOG_DIR.$pid.'/'.date('Ymd').'/'.$logFileName, $partDebug, FILE_APPEND);
			sendDebugEmail($partDebug . "\n");
        	exit;
        } else {
        	//fwrite($fh, "File copied to tmp location.\n");
        	addToDebug("File copied to tmp location");
        	if (!chmod($tmpname, 0777)) {
	        	//fwrite($fh, "Chmod IO error 1\n");
	        	addToDebug("Chmod IO error 1");
        	}
        }
        
        if ($jupart) {
        	//fwrite($fh, "IN THE CHUNK #" .$jupart. "\n");
        	addToDebug("IN THE CHUNK #" .$jupart);
        	// got a chunk of a multi-part upload
            $len = getFileSize($tmpname);
            //fwrite($fh, "Chunk length: " .$len. "\n");
            addToDebug("Chunk length: " .$len);
            //INTERRUPTED CHUNKS FROM APACHE
            if($len < 2000000 && $jufinal == 0 ) {
            	unlink($dstname);
                unlink($tmpname);
                echo "CHUNK DISCARDED";
                addToDebug("CHUNK DISCARDED!!!");
            	addToDebug("===========HANDLE CHUNK END=============");
				addToDebug("===============END===============");
				
				//If there is no log dir, we create it
				if(!is_dir($LOG_DIR.$pid)) {
					exec('mkdir '.$LOG_DIR.$pid);
				}
				
				$LOG_DIR = $LOG_DIR.$pid.'/';
				if(!is_dir($LOG_DIR.date("Ymd"))) {
					exec('mkdir '.$LOG_DIR.date("Ymd"));
				}
				$LOG_DIR = $LOG_DIR.date("Ymd").'/';
				
				if($partDebug != '') {
					file_put_contents($LOG_DIR.$logFileName, $partDebug, FILE_APPEND);
				}
				exit;
            }
            if ($len > 0) {
            	$src = fopen($tmpname, 'rb');
            	$dst = fopen($dstname, ($jupart == 1) ? 'wb' : 'ab');
            	while ($len > 0) {
            		$rlen = ($len > 8192) ? 8192 : $len;
                    $buf = fread($src, $rlen);
            		if (!$buf) {
                        fclose($src);
                        fclose($dst);
                        unlink($dstname);
                        unlink($tmpname);
                        //fwrite($fh, "Read IO error, chuck read failed\n");
                        addToDebug("Read IO error, chunk read failed");
                        file_put_contents($LOG_DIR.$pid.'/'.date('Ymd').'/'.$logFileName, $partDebug, FILE_APPEND);
                        sendDebugEmail($partDebug . "\n");
                        exit;
                    }
                    //APPEND
                    if (!fwrite($dst, $buf, $rlen)) {
                        fclose($src);
                        fclose($dst);
                        unlink($dstname);
                        unlink($tmpname);
                        //fwrite($fh, "Read IO error, chuck append failed\n");
                        addToDebug("Read IO error, chunk append failed");
                        file_put_contents($LOG_DIR.$pid.'/'.date('Ymd').'/'.$logFileName, $partDebug, FILE_APPEND);
                        sendDebugEmail($partDebug . "\n");
                        exit;
                    }
                    $len -= $rlen;
            	}
            	//fwrite($fh, "Chunk saved\n");
            	addToDebug("Chunk saved");
            	fclose($src);
                fclose($dst);
                unlink($tmpname);
            }
            if ($jufinal) {
            	$dlen = getFileSize($dstname);
            	if ($dlen != $file_size) {
	            	//fwrite($fh, "File size mismatch\n");
	            	addToDebug("File size mismatch");
                    file_put_contents($LOG_DIR.$pid.'/'.date('Ymd').'/'.$logFileName, $partDebug, FILE_APPEND);
	            	unlink($dstname);
	            	sendDebugEmail($partDebug . "\n");
	            	exit;
            	}
            	if ($md5sums[$cnt] != md5_file($dstname)) {
	            	//fwrite($fh, "MD5 checksum mismatch\n");
	            	$md5sums_array_string_output = print_r($md5sums, true);
	            	addToDebug($md5sums_array_string_output);
	            	addToDebug(md5_file($dstname));
	            	addToDebug("MD5 checksum mismatch");
                    file_put_contents($LOG_DIR.$pid.'/'.date('Ymd').'/'.$logFileName, $partDebug, FILE_APPEND);
	            	unlink($dstname);
	            	sendDebugEmail($partDebug . "\n");
	            	exit;
            	}
            	
            	if (($dlen > 0) || $classparams['allow_zerosized']) {
            		if (!chmod($dstname, 0777)) {
	                	//fwrite($fh, "Chmod IO error, DEST FILE\n");
	                	addToDebug("Chmod IO error, DEST FILE");
            		}
            	} else {
	            	unlink($dstname);
	            }
            	
            }
        } else {
            // Got a single file upload. Trivial.
            if ($md5sums[$cnt] != md5_file($tmpname)) {
                //fwrite($fh, "MD5 checksum mismatch.\n");
                $md5sums_array_string_output = print_r($md5sums, true);
            	addToDebug($md5sums_array_string_output);
            	addToDebug(md5_file($dstname));
                addToDebug("MD5 checksum mismatch");
                file_put_contents($LOG_DIR.$pid.'/'.date('Ymd').'/'.$logFileName, $partDebug, FILE_APPEND);
                sendDebugEmail($partDebug . "\n");
                exit;
            }
            if (!rename($tmpname, $dstname)) {
	        	//fwrite($fh, "Chmod IO error.\n");
	        	addToDebug("Chmod IO error");
                file_put_contents($LOG_DIR.$pid.'/'.date('Ymd').'/'.$logFileName, $partDebug, FILE_APPEND);
                sendDebugEmail($partDebug . "\n");
	        	exit;
            }
	        if (!chmod($dstname, 0777)) {
	        	//fwrite($fh, "Chmod IO error.\n");
	        	addToDebug("Chmod IO error");
	        }
        }
        $cnt++;
			
	}
	
	echo "SUCCESS";
	//fwrite($fh, "\n===============END===============\n");
	addToDebug("===========HANDLE CHUNK END=============");
	addToDebug("===============END===============");
	
	//If there is no log dir, we create it
	if(!is_dir($LOG_DIR.$pid)) {
		exec('mkdir '.$LOG_DIR.$pid);
	}
	
	$LOG_DIR = $LOG_DIR.$pid.'/';
	if(!is_dir($LOG_DIR.date("Ymd"))) {
		exec('mkdir '.$LOG_DIR.date("Ymd"));
	}
	$LOG_DIR = $LOG_DIR.date("Ymd").'/';
	
	if($partDebug != '') {
		file_put_contents($LOG_DIR.$logFileName, $partDebug, FILE_APPEND);
	}
	//fclose($fh);
	exit;
	
	function addToDebug($msg) {
		global $partDebug;
		$partDebug .= date('h:i:s').' - '.$msg."\n";
	}
	
	function getFileSize($file_path) {
		clearstatcache();
		return filesize($file_path);
	}
?>