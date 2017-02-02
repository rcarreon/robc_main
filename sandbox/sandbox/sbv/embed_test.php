<?php
/**
 * This class is used for fetching external partners, need to be compleatly rewritten, so it can inherents parent class
 * @todo
 * 1. Rewrite logic into EmbedFlv parent, childs EmbedYoutube, EmbedMetacafe etc
 * 2. It can be smart enough to catch title and description
 * 3. Check if we are getting flv or mp4 and pass that info to conversion
 *
 * @used in videos_controller.php and modules/fetch_flv_springboard/fetch_flv.php
 * @since version 1.0
 * @author documented by losmi, written by unknown
 * @see videos_controller.php (admin_add_embed, admin_check_embed), modules/fetch_flv_springboard/fetch_flv.php
 *
 * //YOU TUBE CODES @see http://en.wikipedia.org/wiki/YouTube#Quality_and_codecs
 *
 *  &fmt = FLV (verry low)
 *  &fmt=5 = FLV (verry low)
 *	&fmt=6 = FLV (works not always)
 *	&fmt=13 = 3GP (mobile phone)
 *	&fmt=18 = MP4 (normal)hq
 *	&fmt=22 = MP4 (hd ready) 720 kbps
 *	&fmt=35 = MP4 (hq) 480 kbps
 *	&fmt=34 = MP4 (hq) 360 kbps
 *	&fmt=37 = MP4 (hq) 360 kbps
 *
 */
class embededFLV {

	/**
	 * Error message
	 * @var string $error
	 */
	var $error='';
	/**
	 * Site from witch we are trying to fetch videos
	 * @var string
	 */
	var $site;
	var $note;
	/**
	 * Url for download
	 * @since version 1.0
	 * @var string $url
	 */
	public $url;
	/**
	 * Title
	 * @var string $title
	 */
	public $title = '';
	/**
	 * Available source quality that we are trying to catch
	 * Values: fullhd, hdready, hq, mq, normal
	 * @since Version 1.0
	 * @var string $fetchingVideo
	 */
	var $fetchingVideo='normal';
	/**
	 * File size of the Video that user is trying to fetch
	 * @since version 1.0
	 * @see $this->calculateAndSetFileSize()
	 * @var string $contentLength
	 */
	var $contentLength = 'unknown';
	/**
	 * File size of the Video that user is trying to fatch presented as int value
	 * @since version 1.0
	 * @see $this->calculateAndSetFileSize()
	 * @var int $contentLengthBytes
	 */
	var $contentLengthBytes = 0;
	/**
	 * Default value for maximum allowed fetch file size
	 * @since version 1.0
	 * @var int
	 */
	var $max_allowed_file_size = 50;
	/**
	 * This var is used to track is URL found, and if it doesn't match allowed file size criteria,
	 * we know that url/emebd is good, source is there, but it can't be fetched because it is to large
	 * @var bool $found
	 */
	var $found = false;
	/**
	 * Debug boolean variable
	 * @var boolean
	 */
	var $debug = false;
	/**
	 * This var is used for adding youtube videos in videos list.
	 * 
	 * @var string $youtube_video_id
	 */
	var $youtube_video_id = NULL;
	
	/**
	 * Extension of downloaded file
	 * 
	 * @var string $extension
	 */
	var $extension = '';
	
	var $vevo = false;
	/**
	 * Keywords from meta tag
	 *  
	 * @var string
	 */
	var $keywords = '';
	/**
	 * Description from meta tag
	 * 
	 * @var string
	 */
	var $description = '';
	/**
	 * Class constructor, recieves int value of the maximum allowed fetching file size defined fot this current partner
	 * @since version 1.0
	 * @param int $max_size
	 */
	function embededFLV($max_size=50, $debug = false)
	{
		$this->max_allowed_file_size = $max_size*1024*1024;
		$this->debug = $debug;
	}
	
	/**
	 * Main download method used for youtube html5 video support
	 * @param string $video_id - Youtube video id
	 * @return bool
	 */
	function get_youtube_url($video_id) {
		
		$format_array = array(38, 37, 22, 18);
		$content = file_get_contents("http://youtube.com/get_video_info?video_id=".$video_id);
		
		if (preg_match('@title=([^&]+)@iU', $content, $match_title)) {
			//echo "TITLE = " .urldecode(rawurldecode($match_title[1]));
			$this->title = urldecode(rawurldecode($match_title[1]));
		}
		$final_key = -1;
		
		if (preg_match('@url_encoded_fmt_stream_map=[^&]+@', $content, $match)) {
			
			$encoded_data = rawurldecode($match[0]);
			$encoded_array = explode(",", $encoded_data);
	
			foreach($format_array as $fmt_value) {
				foreach($encoded_array as $file_key => $file_url) {
					if(preg_match('@itag='.$fmt_value.'@', $file_url, $match1)) {
						$final_key = $file_key;
						break 2;
					}
				}
			}
			
			if(preg_match('@url=([^&]+)@', $encoded_array[$final_key], $match2)) {
				$this->url = rawurldecode(rawurldecode($match2[1]));
			}
			return true;
		} else {
			return false;
		}
	}
	/**
	 * Main download method used for all types of partners that we support
	 * @param string $embed_code - Could be url/embed code
	 * @return bool
	 */
	function download($embed_code)
	{
		// http://youtu.be/juDs4AVk2vw
		
		if (preg_match ( '@www.youtube(.*).com/v/(.*)[&"]@iU', $embed_code, $match ) || 
			preg_match ( '@http://www.youtube(.*).com/watch\?v=(.*)[&"]*@i', $embed_code, $match2 ) || 
			preg_match ( '@www.youtube.com/embed/(.*)[&"]@iU', $embed_code, $match3 ) ||
			preg_match ( '@youtu.be/(.*)@', $embed_code, $matchShortLink ) || 
			(preg_match ( '@www.youtube(.*).com@iU', $embed_code, $match4 ) && preg_match ( '@v=(.*)[&"]*@i', $embed_code, $match5 ))
		   )
		{ // YouTube/Google
			print_r($match);
			print_r($match3);
			
			$this->site = "Youtube (Google)";
			if (isset($match2 [2]) && !empty($match2 [2]))
			{
				$match [2] = $match2 [2];
			}
			//user posted youtube iframe that is in still in beta, but be prepared
			if(isset($match3[1]))
			{
				$match [2] = $match3[1];
			}
			if(isset($match [2]) && !empty($match [2]))
			{
				$f = explode('?',$match [2]);
				$videoid = $f[0];
			}
			if(isset($match5 [1]) && !empty($match5 [1]))
			{
				$videoid = $match5[1];
			}
			//User posted short youtube link
			if(isset($matchShortLink[1]))
			{
				//print_r($matchShortLink);
				$videoid = $matchShortLink[1];
			}
			
			echo "VIDEO ID = " .$videoid;
			
			$youtube_explode = explode('&', $videoid);
			$this->youtube_video_id = $youtube_explode[0];
			
			if($this->debug)
			{
				//echo 'Get content from: '."http://www.youtube.com/watch?v={$videoid}<br>";
			}
			
			//echo "http://www.youtube.com/watch?v={$videoid}";
			$content = $this->get_data("https://www.youtube.com/watch?v={$videoid}"/*."&html5=1"*/);
			//echo $content;
			//exit;
			/*if(preg_match('@requiressl@iU', $content, $match_requiressl)) {
				echo "IMA";
				exit;
			} else {
				echo "NEMA";
				exit;
			}*/
			
			
			
			if(preg_match('@name=attribution\s+content=vevo@iU', $content, $match_vevo)) {
				$this->vevo = true;
			}

			if($this->debug)
			{
				//echo '<br/><textarea style="width:800px;height:500px;">'.$content.'</textarea><br/>';
			}
			
			//$cont = file_get_contents("http://www.youtube.com/get_video_info?&video_id={$videoid}&fmt=18");
			
			//echo '<br/><textarea style="width:800px;height:500px;">'.$cont.'</textarea><br/>';
			
			//We try to catch is there any reson that you tube setup for not to embed this video?

			//if (preg_match ( '@&reason=(.*)@', $cont, $match ) && preg_match ( '@status=fail&@', $cont, $matchd ))
			//{
			//	$this->error = str_replace("+", " ", rawurldecode($match[1]));
				//We found NOT TO reason, we are good to break
			//}
			

			//if(empty($this->error))
			//{
			//$fmtArray = array('fullhd'=>37,'hdready'=>22,'hq'=>35,'mq'=>18,'normal'=>34);
			$fmtArray = array('fullhd'=>45,'hdready'=>44,'mq'=>22,'mq'=>35,'normal'=>18);
			$fmtArrayFlip = array(34 => 'normal', 35 => 'mq', 18 => 'normal', 22 => 'hdready', 37 => 'fullhd', 38 => 'fullhd', 46 => 'fullhd', 45 => 'hdready', 44 => 'mq', 43 => 'normal');
			
			
			//if (preg_match('@fmt_list=(\\"?)(.*)(\\"?)@', $content, $match)) {
			//if (preg_match('@url_encoded_fmt_stream_map(\\"?):\s+(\\"?)(.*)(\\"?)@', $content, $match)) {
			if (preg_match('@url_encoded_fmt_stream_map\\"\s*:\s*\\"(.*?)\\"@', $content, $match)) {
				
				print_r($match);
				//echo $match[1];
				//die();
				
				//TITLE - Grab video title
					if(preg_match('@<meta\s+name="title\"\s+content="([^"]*)">@', $content, $match_title)) {
						//echo $match_title[1];
						$this->title = htmlspecialchars_decode(urldecode(rawurldecode(trim($match_title[1]))));
						//$this->title = $match_title[1];
					}
				//TAGS - This is to get keywords and present them as tags
					if(preg_match('@<meta\s+name="keywords\"\s+content="([^"]*)">@', $content, $match_keywords)) {
	
						$this->keywords = htmlspecialchars_decode(urldecode(rawurldecode(trim($match_keywords[1]))));
	
					}
				//DESCRIPTION - Grab description form page itself
					if(preg_match('@<p\s+id="eow-description\"\s+>(.*)<@', $content, $match_description)) {
						
						$this->description = htmlspecialchars_decode(urldecode(rawurldecode(strip_tags($match_description[1]))));
						
						}
					//If description is empty, get metadata description
					if($this->description==''){
						
						if(preg_match('@<meta\s+name="description\"\s+content="([^"]*)">@', $content, $match_metadata_description)) {
						
						$this->description = htmlspecialchars_decode(urldecode(rawurldecode(trim($match_metadata_description[1]))));
						
						}
					}
				$rawred = $match[1];
				$red = rawurldecode($match[1]);
				echo $red;
				echo "<br><br><br>";
				//die();
				
				//url_encoded_fmt_stream_map=([^\\])*
				//if (preg_match_all('@url_encoded_fmt_stream_map=(.*)watermark@', $red, $match_new)) {
				//if (preg_match_all('@url_encoded_fmt_stream_map=([^\\\\])*@', $red, $match_new)) {
				
					//Grab all URL formats
					/*if (preg_match_all('@url_encoded_fmt_stream_map=(.*)(watermark=)@', $red, $match_new)) {
						
						$red = $match_new[0][0];
						echo $red;
					}
					
					$o = explode(',',$red);
					print_r($o);*/
				
				$formatFound = array();
				$i=0;
				$videoTypeSet = false;
				$videoQualitySet = false;
				
				//Walk through all Url formats and fill all formats into $formatFound array
				//foreach($o as $kljuc=>$vrednost) {
					$break = false;
					
					//if (preg_match_all('@itag=(.*)&url=([^&]*)@', $vrednost, $match)) {
					
					//TEST
					/*if (preg_match_all('@itag=([0-9]+)&@', rawurldecode($vrednost), $match_itag) && preg_match_all('@sig=([\.a-zA-Z0-9]+)@', rawurldecode($vrednost), $match_sig) && 
						 preg_match_all('@url=([^&]+)@', $vrednost, $match_url)) {
						echo "<br><br><br><br>";
						echo rawurldecode($match_itag[0][0]). "<br>";
						echo rawurldecode($match_itag[1][0]). "<br>"; //OVAJ
						print_r($match_itag);
						echo "<br><br><br><br>";
						
						echo "<br><br><br><br>";
						echo rawurldecode($match_sig[0][0]). "<br>";
						echo rawurldecode($match_sig[1][0]). "<br>"; //OVAJ
						print_r($match_sig);
						echo "<br><br><br><br>";
						
						echo "<br><br><br><br>";
						echo rawurldecode($match_url[0][0]). "<br>";
						echo rawurldecode($match_url[1][0]). "<br>"; //OVAJ
						print_r($match_url);
						echo "<br><br><br><br>";
					}*/
					
					if(preg_match_all('@itag=([0-9]+)&@', rawurldecode($red), $match_itag1) || preg_match_all('@itag=([0-9]+),@', rawurldecode($red), $match_itag1) || preg_match_all('@itag=([0-9]+)\\\@', rawurldecode($red), $match_itag1)) {
						echo "<br>";
						echo "ITGA PASSED";
						echo "<br>";
					}
					
					if(preg_match_all('@url=([^\\\]+)@', $rawred, $match_url1)) {
						echo "<br>";
						echo "URL PASSED";
						echo "<br>";
					}
					
					if(preg_match_all('@sig=([\.a-zA-Z0-9]+)@', rawurldecode($red), $match_sig1) || preg_match_all('@s=([\.a-zA-Z0-9]+)@', rawurldecode($red), $match_sig1)) {
						echo "<br>";
						echo "SIG PASSED";
						echo "<br>";
					}
					
					if(preg_match_all('@type=([a-zA-Z0-9\/]+)@', rawurldecode($red), $match_type1)) {
						echo "<br>";
						echo "TYPE PASSED";
						echo "<br>";
					}
					
					//Get whole line inside the URL parameter
					if ( (preg_match_all('@itag=([0-9]+)\\\@', rawurldecode($red), $match_itag) || preg_match_all('@itag=([0-9]+)&@', rawurldecode($red), $match_itag) || preg_match_all('@itag=([0-9]+),@', rawurldecode($red), $match_itag)) && 
						preg_match_all('@url=([^\\\]+)@', $rawred, $match_url) && 
						(preg_match_all('@sig=([\.a-zA-Z0-9]+)@', rawurldecode($red), $match_sig) || preg_match_all('@s=([\.a-zA-Z0-9]+)@', rawurldecode($red), $match_sig)) &&
						preg_match_all('@type=([a-zA-Z0-9\/]+)@', rawurldecode($red), $match_type))  {
						
						print_r($match_itag);
						print_r($match_url);
						print_r($match_sig);
						print_r($match_type);
						//die();
						
						if(preg_match_all('@s=([\.a-zA-Z0-9]+)@', rawurldecode($red), $match_sig_s)) {
							
							$new_match_sig_array = array();
							$s_key = 0;
							//CHECK IF MATCH CONTAINS ".", valid signature
							foreach($match_sig[1] as $key_s=>$sig) {
								$pos_s = strpos($sig, ".");
								if($pos_s !== false) {
									$new_match_sig_array[0][$s_key] = "s=".$sig;
									$new_match_sig_array[1][$s_key] = $sig;
									$s_key = $s_key + 1;
								}
							}
							$match_sig = $new_match_sig_array;
							print_r($match_sig);
						}

						/*if(preg_match_all('@itag=([0-9]+)&@', rawurldecode($red), $match_temp) && count($match_itag[1]) != count($match_sig[1])) {
							print_r($match_itag);
							preg_match_all('@itag=([0-9]+)\\\@', rawurldecode($red), $match_itag);
							if(preg_match_all('@itag=([0-9]+)\\\@', rawurldecode($red), $match_temp1) && count($match_itag[1]) != count($match_sig[1])) {
								print_r($match_itag);
								preg_match_all('@itag=([0-9]+),@', rawurldecode($red), $match_itag);
								if(empty($match_itag[1])) {
									$match_itag = empty($match_temp1) ? $match_temp : $match_temp1;
								}
								print_r($match_itag);
							}
						}*/
							
						
						foreach($match_url[1] as $k=>$val) {
							
							/*if(preg_match_all('@url=([^,]+)@', $match_url[0][$k], $match_eception)) {
								$val = $match_eception[1];
							}*/
							
							$pos = strpos($val, ",");
							if($pos !== false) {
								echo "<br>";
								echo "STARI VAL = " .$val;
								echo "<br>";
								echo "NOVI VAL = " .substr($val, 0, $pos);
								$val = substr($val, 0, $pos);
							}
							
							$pos = strpos($val, "www.youtube");
							if($pos === false) {
								$formatFound[$k]['frmt'] = $match_itag[1][$k];
								$formatFound[$k]['url'] = rawurldecode($val). ( !empty($match_sig) ? "&signature=" . $match_sig[1][$k] : '' );
								$formatFound[$k]['type'] = $match_type[1][$k];
								//break;
							}
						}
						print_r($formatFound);
						//die();
					}
					//echo "NEMA";
					//die();
					/*if (preg_match_all('@itag=(.*)&url=(.*)@', rawurldecode($vrednost), $match)) {
						//www.youtube
						if(!empty($match)) {
							//$formatFound[$i]['url'] = rawurldecode($match[2][0]);
							
							//REPLACE "sig" with "signature" (with sig we are receiving HTTP Failed /Authorization
							$formatFound[$i]['url'] = str_replace('sig', 'signature',($match[2][0]));
							$formatFound[$i]['frmt'] = $match[1][0];
						}
						
					}*/
					/*if(isset($formatFound[$i]['url']) && $formatFound[$i]['url']!='') {
						if (preg_match_all('@type=video(.*)@', $vrednost, $match)) {
							//print_r($match); die();
	
							if(!empty($match)) {
								$formatFound[$i]['type'] = rawurldecode($match[0][0]);
								$videoTypeSet = true;
							}
						}
						if (preg_match_all('@quality=(.*)@', $vrednost, $match)) {
							//print_r($match); die();
	
							if(!empty($match)) {
								$formatFound[$i]['quality'] = rawurldecode($match[0][0]);
								$videoQualitySet = true;
							}
						}
						
					}
					if($videoTypeSet && $videoQualitySet) {
						$i++;
						$videoTypeSet = false;
						$videoQualitySet = false;
					}*/
				//}
				
				
				
				
				
				
				//Walk through $formatFound (all formats found) and match format that is allowed to grab/download
				if(!empty($formatFound)) {
					//print_r($formatFound);
					foreach ($formatFound as $k=>$v) {
						
						if (!preg_match('@something@', $v['type'], $match)) { //REMOVE WEBM FORMAT FETCH
							
							//if(array_search($v['frmt'],$fmtArray)) { //$match[1][0] format value 34, 18...
							if(array_key_exists($v['frmt'], $fmtArrayFlip) ) {
								
								//URL - There are not Youtube reasons to embed this video
								$this->url = $v['url'];
								
								if(preg_match('@mp4@', $v['type'], $match_ex)) {
									$this->extension = 'mp4';
								}
								if(preg_match('@flv@', $v['type'], $match_ex)) {
									$this->extension = 'flv';
								}
								if(preg_match('@webm@', $v['type'], $match_ex)) {
									$this->extension = 'webm';
								}
								$this->found = true;
								//We fond our url, but is source smaller than allowed fetching file size for this partner?
								//echo $this->url . "     ";
								$this->calculateAndSetFileSize();
								//echo '<br>'.$this->contentLengthBytes.'   '.$this->max_allowed_file_size.'<br>';
								if($this->contentLengthBytes > $this->max_allowed_file_size) {
									
									//remove from array, quality is to strong
	
									//If content of the source is larger the allowed, remove this array member from the fmtArray and try find again action
											//$fmtArray = array_flip($fmtArray);
											//unset($fmtArray[$v['frmt']]);
									//echo 'Dont catch:'.$p[0].' size:'.$this->contentLength."\n";
											//$fmtArray = array_flip($fmtArray);
									unset($fmtArrayFlip[$v['frmt']]);
									$this->url ='';
									$this->extension = '';
									$this->contentLength ='';
	
								} else {
									//echo 'CATCHING frmt:'.$v['frmt'].', '.print_r($v,true).'<br>';
									//echo (($this->contentLengthBytes/1024)/1024).' is smaller than '.(($this->max_allowed_file_size/1024)/1024).'<br>';
									//We found our url member, we are good to break
									$break = true;
											//$fmtArray = array_flip($fmtArray);
									$urlFormatted = str_replace('videoplayback','generate_204',$this->url);
									$this->fetchingVideo = $fmtArrayFlip[$v['frmt']];
								}
								if($break){ break; } else { continue; }
							}
						}
					}
					
					
				} else {
					$this->error .= 'Could not fetch this video 11.';
				}
			} else {
				
				
				$this->error .= 'Could not fetch this video 22.';
				//Test if user need to be logged in onto YouTube to grab this video
				if (preg_match('@(Sign in to view this video)@', $content, $match_test)) {
						
					$this->error .= ' Can not fetch videos that require YouTube authentication.';
				}
				
				
			}

		}

		//We found source from the link/emebd code, but none of the source sizes doesn't match criteria for max allowed fetch file size for this partner

		if($this->found==true)
		{
			if($this->url == '' && $this->contentLength=='')
			{
				//$this->error .= 'Fetched file source exceeds maximum allowed file size.';
				$this->error .= 'You are not allowed('.number_format((($this->max_allowed_file_size/1024)/1024), 2, '.', ',').') to catch file of this ('.$this->fetchingVideo.') size('.number_format((($this->contentLengthBytes/1024)/1024), 2, '.', ',').').';
				return false;
			}
		}
		if (!empty($this->error))
		{
			return false;
		}

		if (! $this->url || empty($this->url))
		{
			$this->error .= 'Cannot find video link.';
			return false;
		}
		if($this->contentLength=='unknown')
		{
			$this->error .= 'Source file size is unknown.';
			return false;
		}
		//Ping $this->url, to set File size
		$this->calculateAndSetFileSize();
		if (! $this->site)
		{
			$this->error .= 'Embeded code/site is not supported.';
			return false;
		}
		//echo 'You are fetching ('.$this->fetchingVideo.') size('.number_format((($this->contentLengthBytes/1024)/1024), 2, '.', ',').').';

		return true;

	}

	function httpSocketConnection($host, $method, $path, $data, $whattoreturn = 'content')
	{

		$method = strtoupper ( $method );

		if ($method == "GET")
		{
			$path .= '?' . $data;
		}

		$filePointer = fsockopen ( $host, 80, $errorNumber, $errorString );

		if (! $filePointer)
		{
			echo 'No pointer...';
			return false;
		}

		$requestHeader = $method . " " . $path . "  HTTP/1.1\r\n";
		$requestHeader .= "Host: " . $host . "\r\n";
		$requestHeader .= "User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.8.1) Gecko/20061010 Firefox/2.0\r\n";
		$requestHeader .= "Content-Type: application/x-www-form-urlencoded\r\n";

		if ($method == "POST")
		{
			$requestHeader .= "Content-Length: " . strlen ( $data ) . "\r\n";
		}

		$requestHeader .= "Connection: close\r\n\r\n";

		if ($method == "POST")
		{
			$requestHeader .= $data;
		}

		fwrite ( $filePointer, $requestHeader );

		$responseHeader = '';
		$responseContent = '';

		do
		{
			$responseHeader .= fread ( $filePointer, 1 );
		} while ( ! preg_match ( '/\\r\\n\\r\\n$/', $responseHeader ) );

		if (! strstr ( $responseHeader, "Transfer-Encoding: chunked" ))
		{
				
			while ( ! feof ( $filePointer ) )
			{
				$responseContent .= fgets ( $filePointer, 128 );
			}

		} else
		{
				
			while ( $chunk_length = hexdec ( fgets ( $filePointer ) ) )
			{
				$responseContentChunk = '';
				$read_length = 0;

				while ( $read_length < $chunk_length )
				{
					$responseContentChunk .= fread ( $filePointer, $chunk_length - $read_length );
					$read_length = strlen ( $responseContentChunk );
				}

				$responseContent .= $responseContentChunk;
				fgets ( $filePointer );
			}
		}

		if ($whattoreturn == 'content')
		{
			return chop ( $responseContent );
		} else if ($whattoreturn == 'headers')
		{
			return $responseHeader;
		} else
		{
			return $responseHeader . "\n\n" . chop ( $responseContent );
		}
	}

	function is_valid($embed_code)
	{

		$embed_code = trim ( $embed_code );

		// check embeded code
		if (preg_match ( '@^<embed src="http://www.veoh.com/.*</embed>@s', $embed_code ))
		{
			return 'Veoh';
		}

		if (preg_match ( '@^<embed src="http://www.metacafe.com/.*</embed>@s', $embed_code ))
		{
			return 'Metacafe';
		}

		if (preg_match ( '@^<object.* value="http://www.youtube.com.*src="http://www.youtube.com@s', $embed_code ))
		{
			return 'Google/Youtube';
		}

		if (preg_match ( '@^<div><object.*<param name="movie" value="http://www.dailymotion.com/.*<embed src="http://www.dailymotion.com/.*</embed>.*</div>@s', $embed_code ))
		{
			return 'DailyMotion';
		}

		if (preg_match ( '@^<object.*value="http://embed.break.com/.*</object>@s', $embed_code ))
		{
			return 'Break';
		}

		if (preg_match ( '@^<object.*value="http://.*video.yahoo.com/.*</embed></object>@s', $embed_code ))
		{
			return 'Yahoo';
		}
		//check url
		if (preg_match ( '@www.youtube.com/v/(.*)[&"]@iU', $embed_code, $match ) || preg_match ( '@http://www.youtube.com/watch\?v=(.*)[&"]*@i', $embed_code, $match2 ))
		{
			return 'Youtube (Google)';
		}
		if (preg_match ( '@(http://www.metacafe.com/watch/.*)"@iU', $embed_code, $match ) || preg_match ( '@(http://www.metacafe.com/watch/.*)$@iU', $embed_code, $match2 ))
		{ // MetaCafe
			return 'MetaCafe';
		}
		if (preg_match ( '@(http://www.break.com/index/.*)"@iU', $embed_code, $match ) || preg_match ( '@(http://www.break.com/index/.*)$@iU', $embed_code, $match2 ))
		{ // Break.com
			return 'Break.com';
		}
		if (preg_match ( '@(http://www.dailymotion.com/video/.*)"@iU', $embed_code, $match ) || preg_match ( '@http://www.dailymotion.com.*/video/(.*)$@iU', $embed_code, $match2 ))
		{ // DailyMotion
			return 'DailyMotion';
		}
		if (preg_match ( '@http://vimeo.com/moogaloop.swf\?clip_id=([0-9]*)@i', $embed_code, $match ) || preg_match ( '@http://vimeo.com/([0-9]*)@i', $embed_code, $match2 ))
		{
			return 'Vimeo flv';
		}

		return false;

	}

	function calculateAndSetFileSize()
	{
		if(!empty($this->url))
		{
			//$useragent="Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.0.5) Gecko/2008120122 Firefox/3.0.5";
			//echo $this->url;
			$curl = NULL;
			$curl = curl_init ($this->url);
			//curl_setopt($curl, CURLOPT_USERAGENT, $useragent);

			curl_setopt ( $curl, CURLOPT_RETURNTRANSFER, true );
			curl_setopt ( $curl, CURLOPT_TIMEOUT, 5 );
			curl_setopt($curl, CURLOPT_NOBODY, true);
			curl_setopt($curl, CURLOPT_MAXREDIRS, 10); //follow up to 10 redirects
			curl_setopt($curl, CURLOPT_HEADER, true);
			curl_setopt($curl, CURLOPT_FOLLOWLOCATION, true); //not necessary unless the file redirects (like the PHP example we're using here)
			//curl_setopt($curl, CURLOPT_COOKIEJAR, '/tmp/cookies.txt');
			//curl_setopt($curl, CURLOPT_COOKIEFILE, '/tmp/cookies.txt');
			//curl_setopt($curl, CURLOPT_USERAGENT, 'Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.1.2) Gecko/20090729 Firefox/3.5.2 GTB5');

			try
			{
				$content = curl_exec ( $curl );
				$info = curl_getinfo($curl);
				//print_r($info);
				//echo $content;
				if (preg_match('/Content-Length: (\d+)/', $content, $matches)) {
					$this->contentLength = number_format((($matches[1]/1024)/1024), 2, '.', ',');
					$this->contentLengthBytes = $matches[1];
				}
				//HTTP/1.1 404 Not Found
				if (preg_match('/HTTP\/1.1 404 Not Found/', $content, $matches)) {
					$this->error = 'Content not found.'; //.$this->url;
				}

				curl_close($curl);
			} catch ( Exception $e )
			{
				$this->error = 'Caught exception: '. $e->getMessage ();
				//return true;
			}
		}
	}
	
	function getDailyMotionUrl($quality_type, $sequence) {
		
		if (preg_match ( '@'.$quality_type.'":"(.*)"@iU', $sequence, $match )) {
			if (!empty($match[1]) && $match[1] != '') {
				$url = stripslashes($match[1]);
				$url.="&ts=0.0";
				$headers = get_headers ( $url, 1 );
				$status = explode (" ", $headers ['1']);
				if ($status [1] == "200" || $status [1] == "302"|| $status [1] == "301") {
					return $headers['Location'];
					$this->found = true;
				} else {
					return '';
				}
			} else {
				return '';
			}
		} else {
			return '';
		}
	}
	
	function checkDailyMotionUrl($urlLocation) {
		
		$this->url = $urlLocation;
		$this->calculateAndSetFileSize();
		
		if($this->contentLengthBytes > $this->max_allowed_file_size) {
			return false;	
		}
		
		return true;
	}
	
	function get_data($url) {
		
		//$useragent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.30 (KHTML, like Gecko) Chrome/12.0.742.112 Safari/534.30";
		//$agent= 'Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; .NET CLR 1.0.3705; .NET CLR 1.1.4322)';
		//return file_get_contents($url);
		$ch = NULL;
		$ch = curl_init();
		$timeout = 10;
		//curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		//curl_setopt($ch, CURLOPT_VERBOSE, true);
		//curl_setopt($ch, CURLOPT_USERAGENT, $useragent);
		curl_setopt($ch, CURLOPT_URL, $url);
		curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
		curl_setopt($ch, CURLOPT_MAXREDIRS, 10); //follow up to 10 redirects
		curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, $timeout);
		curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
		curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
		
		$data = curl_exec($ch);
		
		if(curl_errno($ch))
		{
			echo 'error:' . curl_error($ch);
		}
		
		curl_close($ch);
	 	return $data;
	}
	
}

############################################################################################################################


/*

$embed_code_or_page_url='<object width="425" height="344"><param name="movie" value="http://www.youtube.com/v/K4EJfUtYknU&hl=en&fs=1"></param><param name="allowFullScreen" value="true"></param><param name="allowscriptaccess" value="always"></param><embed src="http://www.youtube.com/v/K4EJfUtYknU&hl=en&fs=1" type="application/x-shockwave-flash" allowscriptaccess="always" allowfullscreen="true" width="425" height="344"></embed></object>';
$embed_code_or_page_url='http://vimeo.com/1188595';


$getflv = new embededFLV();

if ($getflv->download($embed_code_or_page_url)) {
echo "<a href=\"{$getflv->url}\">{$getflv->site} download link</a>";
} else {
echo "Error: {$getflv->error}";
}
*/

#if ($site = $getflv->is_valid($embed_code)) {
#	echo $site;
#	} else {
#	echo "Embed code not reckognized!";
#	}

$class_instance = new embededFLV(500, true);
#https://www.youtube.com/watch?v=QDIlqd-mhJc
$class_instance->download("<iframe src=\"//www.youtube.com/embed/ezFLIBgzafE\" width=\"730\" height=\"548\" frameborder=\"0\" allowfullscreen=\"allowfullscreen\"></iframe>");
//Legend  https://www.youtube.com/watch?v=mbMWnaD3fhI
//Pharrel https://www.youtube.com/watch?v=y6Sxv-sUYtM

echo "<br><br><br><br>";
echo "URL = " .$class_instance->url . "<br>";
echo "GRESKA = " .$class_instance->error;
?>
