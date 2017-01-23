<?
/**
 *	InsertHelper Class combine functions to serve complete.php 
 *	Most of inline code removed from complete.php and combined into one Class for better performance and code look nice
 *	@author Milos Todorovic
 *	@version Version 1.2
 *	@package gears.upload
 *  @category  gears.upload
 *  Error levels: notice - just log error, big - log error and send email report, and discuss about removing file and record in db
 * 	Watch for unique key! - Added for multiupload purpose for bigger strength of unique key
 * 	|--------------------------|
 * 	| id | legacy_id | site_id |
 * 	|--------------------------|
 * 	|125 |     0 	 |   65    |
 * 	|--------------------------|
*/

class InsertHelper{
	
	/**
	 * Database link
	 * @var db_link
	 */
	protected $db=null;
	/**
	 * This var will be filled with all messages that will be sent to log and debug log or debug email
	 * @var string $strMessage
	 */
	public $strMessage='';
	/**
	 * Error var will track is there any error happend
	 * @todo This should be changed from bool to Exception with try -catch blocks
	 * @var bool $error
	 */
	protected $error=false;
	/**
	 * This is config array containes db_host, db_user and db_pass
	 * @var array $config
	 */
	private $config=array();
	/**
	 * Default maximum bitrate value in kbps
	 * @since Version 1.1
	 * @var const MAX_ALLOWED_BIT_RATE
	 */
	const MAX_ALLOWED_BIT_RATE = 256;
	/**
	 * Default maximum upload file size for partners in MB
	 * @since Version 1.1
	 * @var const MAX_PARTNER_FILE_SIZE
	 */
	const MAX_PARTNER_FILE_SIZE = 200;
	/**
	 * Default maximum attempt number to ping mysql adn refresh connection
	 * @see isConnected method
	 * @since Version 1.1
	 * @var const RETRY_CONNECTION_ATTEMPTS
	 */
	const RETRY_CONNECTION_ATTEMPTS = 3;
	/**
	 * Default attept number to execute query if some of common mysql error codes are returned
	 * @see executeQuery method
	 * @since Version 1.1
	 * @var const RETRY_QUERY_ATTEMPTS
	 */
	const RETRY_QUERY_ATTEMPTS = 3;
	
	/**
	 * InsertHelper Constructor
	 * @param db_link $dblink
	 * @param array $config
	 * @since Version 1.1
	 */
	public function __construct($dblink=null,$config=array())
	{
		$this->db = $dblink;
		$this->config = $config;
	}
	/**
	 * Get maximum allowed bitrate for partner - Error level: notice
	 * @since Version 1.0
	 * @param int $partner_id
	 * @param int $custom_bitrate
	 * @return int $maxAllowed
	 */
	public function getVideoBitRate($partner_id,$custom_bitrate)
	{
		
		$maxAllowed = $this->MAX_ALLOWED_BIT_RATE;
		$sqlCheckMax = 'SELECT bit_rate_tiers.max_bit_rate AS bit_rate_tiers FROM bit_rate_tiers LEFT JOIN partner_configuration ON partner_configuration.bitrate_tier_id = bit_rate_tiers.id WHERE partner_configuration.id = "' . $partner_id . '"';
	
		$resMax = $this->executeQuery ( $sqlCheckMax ,__LINE__.' file:'.__FILE__);
		if($resMax)
		{
				$max_bitrate_row = mysql_fetch_assoc ( $resMax );
				if (!empty($max_bitrate_row))
				{
					$maxAllowed = $max_bitrate_row ['bit_rate_tiers'];
				}
				$video_bitrate = $maxAllowed;
				//find max bitrate and check is in allowed range
				$resBitrate = $this->executeQuery ( 'SELECT max_bit_rate AS bit_rate FROM bit_rate_tiers WHERE id = "' . $custom_bitrate . '" LIMIT 1' ,__LINE__.' file:'.__FILE__);
	
				$bitrete_row = mysql_fetch_assoc ( $resBitrate );
				if (! empty ( $bitrete_row ))
				{
					if ($bitrete_row ['bit_rate'] <= $maxAllowed)
					{
						$video_bitrate = $bitrete_row ['bit_rate'];
					}
				}
				return $video_bitrate;
		}
		else
		{
			$this->strMessage .= 'Error selecting bit rate.'.mysql_error().' On line('.__LINE__.') in file: '.__FILE__;
			return $maxAllowed;
		}
		return $maxAllowed;
	}
	/**
	 * Get file extension - Error level: none
	 * @param string $file
	 * @since Version 1.0
	 * @return string $exts
	 */
	public function getExtension($file)
	{
		$filename = strtolower ( $file );
		$exts = split ( "[/\\.]", $filename );
		$n = count ( $exts ) - 1;
		return $exts [$n];	
	}
	/**
	 * Update video status on $status value - Error level: big
	 * @param int $video_id
	 * @param int $uid
	 * @since Version 1.0
	 * @param string $status
	 */
	public function updateVideoStatus($video_id,$uid,$status='failed')
	{

		$sqlVideoUpdate = 'UPDATE videos SET status = "' . $status . '", legacy_id="'.$video_id.'" WHERE id = "' . $video_id . '" AND user_id = "' . $uid . '"';
	
		if(!$this->executeQuery($sqlVideoUpdate, __LINE__.' file:'.__FILE__))
		{
			$this->strMessage .= 'Error updating video status with query '.$sqlVideoUpdate.' error: '.mysql_error().' On line('.__LINE__.') in file: '.__FILE__;
			$this->error = true;
		}
		else
		{
			$this->strMessage .= 'Set video status failed for video id:'.$video_id."\n";
		}
	}
	/**
	 * Get Maximum Filesize allowed for the partner - Error level: notice
	 * @param int $partner_id
	 * @since Version 1.0
	 * @return int $partnerMaxFileSize
	 */
	public function getMaxFileSizeByPartnerId($partner_id)
	{
		$sqlUploadTierId = 'SELECT upload_tiers.max_file_size AS upload_file_size FROM upload_tiers LEFT JOIN partner_configuration ON partner_configuration.upload_tier_id = upload_tiers.id WHERE partner_configuration.id = "'.$partner_id.'"';
	
		$uploadTierId = $this->executeQuery ( $sqlUploadTierId, __LINE__.' file:'.__FILE__);
		$partnerMaxFileSize = self::MAX_PARTNER_FILE_SIZE;
		if(!empty($uploadTierId))
		{	
			$row = mysql_fetch_assoc ( $uploadTierId );
			if (!empty($row))
			{
				$partnerMaxFileSize = $row ['upload_file_size'];
			}
		}
		else
		{
			$this->strMessage .= 'Error getting maxFileSize '.$sqlUploadTierId.' error: '.mysql_error().' On line('.__LINE__.') in file: '.__FILE__;
		}
		return $partnerMaxFileSize*1024*1024;
		
	}
	/**
	 * Bind and insert link between video and channel into channels_videos table - Error level: big
	 * @since Version 1.0
	 * @param int $intInsertVideoID
	 * @param int $channel
	 * @param int $partner_id
	 */
	public function insertChannel($intInsertVideoID,$channel,$partner_id)
	{
			$sqlChannelJoint = 'INSERT INTO channels_videos SET video_id = "' . $intInsertVideoID . '", channel_id = "' . $channel . '", site_id="'.$partner_id.'"';
							
			$this->strMessage .= 'Videos-Channels joint SQL: ' . "\n";
			$this->strMessage .= $sqlChannelJoint . "\n";
	
			$rsChannelJoint = $this->executeQuery ( $sqlChannelJoint,__LINE__.' file:'.__FILE__ );
			
			if ($rsChannelJoint)
			{
				$this->strMessage .= 'Videos-Channels joint SQL query executed successfully.' . "\n";
			} else
			{
				$this->strMessage .= 'Failed to execute Videos-Channels joint SQL query. error: '.mysql_error().' On line('.__LINE__.') in file: '.__FILE__;
				$this->error = true;
			}
	}
	/**
	 * Executes given query, on the $central_db link - Error level big
	 * @see complete.php
	 * @since Version 1.0
	 * @param string $sql
	 * @param mixed $central_db
	 * @param string $info here is sent info like {@example $this->strMessage .= 'Failed to execute Insert Vote SQL query.' . mysql_error () . '(On line: ' . __LINE__ . ')' . "\n";}
	 * @return mixed|bool $query_resource
	 */
	public function executeQuery($sql, $info='')
	{
			$retry_count = $this->RETRY_QUERY_ATTEMPTS;
			$retry_codes = array(
	//		4009,	// can't lock file
			1202,   // Message: Could not create slave thread; check system resources 
			1203, 	// Message: User %s already has more than 'max_user_connections' active connections 
			1204,	// Message: You may only use constant expressions with SET 
			1205, 	// Message: Lock wait timeout exceeded; try restarting transaction 
			1206, 	// Message: The total number of locks exceeds the lock table size 
			1207, 	// Message: Update locks cannot be acquired during a READ UNCOMMITTED transaction
			2006, 	// Message: Mysql server gone away
			2012, 	// Message: Mysql server lost
			);

			$query_resource = mysql_query ($sql,$this->db);
			
			if (!$query_resource)
			{
				$error_no = @mysql_errno();
				$count = 0;
	
				$this->fillErrorMsg ("RETRY QUERY, error code: {$error_no}, error message: ".@mysql_error(). $info);
	
				while (!empty($error_no) && in_array($error_no, $retry_codes) && $count++ < $retry_count)
				{
					//try to ping or refresh connection
					
					//values in my.cnf are changed from 60 to:
					//interactive_timeout        | 28800 |
					//wait_timeout               | 28800 |
					
					$this->isConnected($info,$sql);
					
					$query_resource = @mysql_query ($sql,$this->db)
						or $this->fillErrorMsg ("RETRY: ".@mysql_errno().": ".@mysql_error()."\n Query string: \"{$sql}\"".$info);
					
					$error_no = @mysql_errno();
					if (!empty($error_no))
					{
						$this->strMessage .= "RETRY FAILED: {$error_no}, error message: ".@mysql_error().$info;
						
					}
				}
			}
			
			if($query_resource)
			{
				return $query_resource;
			}
			return false;
	}
	/**
	 *  Fill global $this->strMessage with message
	 *  @since Version 1.0
	 *  @param string $string
	 */
	public function fillErrorMsg($string)
	{
		$this->strMessage .= $string."\n";
	}
	/**
	 * If script compleate.php break with preuploaded status on video, get last 5 videos with preuploaded status and insert them into debug report
	 * @since Version 1.0
	 * @param int $uid
	 */
	public function fillDebugPreuploadByThisUser($uid)
	{
		$sqlPreUploaded = 'SELECT * FROM videos WHERE user_id="' . $uid . '" and status="pre_uploaded" ORDER BY id DESC LIMIT 0,5';
	
		$resMax = $this->executeQuery ( $sqlPreUploaded, __LINE__.' file:'.__FILE__ );
		if ($resMax)
		{
			$preuploaded = mysql_fetch_assoc ( $resMax );
			if (! empty ( $preuploaded ))
			{
				$this->strMessage .= "\n\n" . '------------------------START LAST 5 PRE_UPLOAD FOR ' . $uid . '--------------------------' . "\n\n";
				$this->strMessage .= print_r ( $preuploaded,true);
				$this->strMessage .= "\n\n" . '-----------------------END LAST 5 PRE_UPLOAD FOR ' . $uid . '--------------' . "\n\n";
			}
		}
	}
	/**
	 * This method checks if mysql is still conected and tries to reconect up to 3 times - Error level big
	 * Removed since Version 1.2 because values in my.cnf are changed from 60 to:
	 * interactive_timeout        | 28800 | - default mysql value setup by Ali Argyle
	 * wait_timeout               | 28800 | - default mysql value
	 * @since Version 1.0
	 * @param string $line
	 * @param string $query
	 */
	private function isConnected($line='', $query='')
	{
			$maxcount = $this->RETRY_CONNECTION_ATTEMPTS;	//try x times
			$cnt = 1;		//try number
			//hello?  anybody home?
			$ping = @mysql_ping( $this->db );
			//if no answer and we haven't tried too many times...
			while( !$ping && $cnt < $maxcount)
			{
				//close current connection
				@mysql_close($this->db);
				$this->db = null;
				//open another connection
				$this->db  = mysql_connect($this->config['host'],$this->config['user'], $this->config['pass']) or die(mysql_error());
				if($this->db===FALSE)
				{
					$this->strMessage .= 'COULD NOT RECONNECT TO MYSQL. ATTEMPT NUM:'.$cnt."\n";
					$this->error = true;
				}
				else
				{
					if (mysql_select_db($this->config['db_name'], $this->db) === FALSE) {
	       
						$this->strMessage .= 'COULD NOT SELECT DB IN IS_CONNECTED. ATTEMPT NUM:'.$cnt."\n";
						$this->error = true;
	    			 }
	    			 $this->strMessage .= 'TRYING TO RECONECCT. ATTEMPT NUM:'.$cnt."\n";
					//ping again to make sure someone answers
					$ping = @mysql_ping( $this->db ) ;
					
					//if no answer...
					if(!$ping )
					{
						//take a nap, that always works.
						sleep(1);
					}
				}
				
				//increase number of times we've tried
				$cnt++;
			}
			
			if(!$ping)
			{
				$this->strMessage .= '--CONNECTION LOST-- on this query:'.$query.', on line: '.$line.' Error num:'.mysql_errno()."\n";
				
					$this->strMessage .= 'COULD NOT RECONNECTED TO MYSQL.' . "\n";
					$this->error = true;
			}
			else
			{
				$this->strMessage .= 'Connection is fine.'. "\n";
			}
	}
	/**
	 * If error occures, fill debug report with all mysql values for better debuging
	 * @since Version 1.0
	 */
	public function fillDebugWithMysqlInfo()
	{
		$result = $this->executeQuery('SHOW STATUS', $this->db,__LINE__.' file:'.__FILE__);
		$this->strMessage .= 'MYSQL DEBUG LOG START'."\n";
		while ($row = mysql_fetch_assoc($result)) {
		    $this->strMessage .= $row['Variable_name'] . ' = ' . $row['Value'] . "\n";
			}
		$this->strMessage .= 'MYSQL srever info: '.mysql_get_server_info($this->db)."\n";
		$this->strMessage .= 'MySQL host info: '. mysql_get_host_info($this->db)."\n";
		$this->strMessage .= 'MYSQL DEBUG LOG END'."\n";
	}
	/**
	 * Get error status
	 * @since Version 1.1
	 * @return bool
	 */
	public function getError()
	{
		return $this->error;
	}
	/**
	 * Set error status
	 * @since Version 1.1
	 * @param bool $err
	 */
	public function setError($err)
	{
		$this->error = $err;
	}
	/**
	 * Gets status message
	 * @since Version 1.1
	 * @return string
	 */
	public function getMessage()
	{
		return $this->strMessage;
	}
	/**
	 * Returns db link
	 * @since Version 1.1
	 * @param string $info
	 * @return mixed|db_link
	 */
	public function getDb($info='')
	{
		$this->isConnected($info);
		return $this->db;
	}
	/**
	 * Gets current partner configuration by partner_id
	 * @param int $partner_id
	 * @since Version 1.1
	 * @return mixed|recordset
	 */
	public function getPartnerConfiguration($partner_id)
	{
		$row = mysql_fetch_assoc ($this->executeQuery ( 'SELECT * FROM partner_configuration WHERE id = "' . $partner_id . '"', __LINE__.' file:'.__FILE__) );
		if (! $row)
		{
			$this->strMessage .= 'Failed to select partner.' . mysql_error () . '(On line: ' . __LINE__ . ')' . "\n";
			$this->error = true;
		}
		return $row;
	}
	/**
	 * Get Mime Type of the file by extension
	 * @since Version 1.1
	 * @param string $file
	 * @return string
	 */
	public function getMimeType($file)
	{
		//Get original file Mime Type
		/*if (!function_exists('mime_content_type')) {
		    function mime_content_type($filename) {
		        $finfo    = finfo_open(FILEINFO_MIME);
		        $mimetype = finfo_file($finfo, $filename);
		        finfo_close($finfo);
		        return $mimetype;
		    }
		}*/
		
		$filename = basename($file);

	    // break file into parts seperated by .
	    $filename = explode('.', $filename);
	
	    // take the last part of the file to get the file extension
	    $ext = $filename[count($filename)-1]; 
		
		//Allowed file types
		//.mpeg, .mpg, .mov, .moov, .flv, .rm, .mp4, .wmv, .avi, .divx, .3gp, .3gpp, .amv, .mpe, .asf, .ogm, .ogv, .ovx, .m4v. 
		$mimeTypes = array(
			 "mpeg" => "video/mpeg",
	         "mpg" => "video/mpeg",
		 	 "mov" => "video/quicktime",
			 "moov" => "video/quicktime",
			 "flv" => "video/x-flv",
			 "rm" => "audio/x-realaudio",
			 "mp4" => "video/mp4",
			 "wmv" => "video/x-ms-wvx",
		 	 "avi" => "video/avi",
			 "divx" => "video/divx",
			 "3gp" => "video/3gp",
			 "3gpp" => "video/3gpp",
			 "amv" => "video/x-amv",
	         "mpe" => "audio/x-mpeg",
	         "asf" => "video/x-ms-asf",
	         "ogv" => "video/ogg",
	         "ovx" => "video/ovx",
	         "m4v" => "video/x-m4v", 
		);
		
		// return mime type for extension
	      if (isset($mimeTypes[$ext])) {
	         return $mimeTypes[$ext];
	      // if the extension wasn't found return octet-stream         
	      } else {
	         return 'text/plain';
	      } 
	}
}
?>