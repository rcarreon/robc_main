<?php
/**
*	CLASS TAGS
*	This is class for managing tags.
*	
*	@author     Ac <actionaca@yahoo.com>
*	@version    v1	2008/03/11 
*
*	METHODS:
*	add_tag($tag)
*	find_tag($tag_id=NULL)
*	find_id($tag='')
*	increase_tag($id=NULL)
*	increase_tag_by_tagname($tag='')
*	find_tags_for_content_id($content_id=NULL)
*	delete_content_id($content_id=NULL)
*	find_all_content_id_with_tag_id($tag_id=NULL)
*	find_all_content_id_with_tag_name($tag='')
*	find_most_popular_tags($len=10)
*	find_number_of_tags()
*
*/

class tags
{
/**
*	Name of tag in tag table
*	@var string
*/
var $tag;

/**
*	Id of tag in tag table
*	@var integer
*/
var $tag_id;

/**
*	Id of content in join table*	@var integer
*/
var $content_id;

/**
*	Name of join tag table
*	@var string
/**
*	Id of content in join table
*/
var $tablename;

/**
*	Connection to database
*	@var connection
*/
var $connection;

/**
*	Site Id
*	@var int
*/
var $site_id;




	/**
	*	Add tag to tags table. 
	*	(If it NOT exists in tag table.)
	*
	*	@param string $tag tag value (example: koska)
	*	@return boolean true if cuccess, or false
	*/
	function add_tag($tags, $content_id)
	{
		$arr_tags = $this->filter_tag($tags);
		if (count($arr_tags)>0 && isset($arr_tags)) {
			foreach ($arr_tags as $tag) {
				$tag = mysql_real_escape_string(stripslashes(strip_tags(trim($tag))));
				$tag = strtolower($tag);
				if ($tag!="") {
					// check if tag exists
					$sql_chk = "SELECT id, tag FROM tags WHERE tag='$tag' LIMIT 1";
					$que_chk = mysql_query($sql_chk, $this->connection);
					$arr_chk = mysql_fetch_array($que_chk);
					
					// adding to tags table
					if (mysql_num_rows($que_chk) < 1) {
						$sql_add = "INSERT INTO tags SET tag='$tag'";
						if ($que_add = mysql_query($sql_add, $this->connection)) {
							$insid_add = mysql_insert_id($this->connection);
							$addjoin = $this->add_ids_to_join_table($content_id, $insid_add);
						}
					} else {
						$gor = $this->add_ids_to_join_table($content_id, $arr_chk['id']);
						//{return true;}else{return false;}
					}
				}
			}
		}
		return true;
	}


	/**
	*	Filter 
	*	This filter convert tags separated by comas in array.
	*	
	*	@param string or array $tag tag value (example: koska, doxa, paradoxa)
	*	@return array, or false
	*/
	function filter_tag($tag)
	{
		if ($tag) {
			if (is_array($tag)) {
				return $tag;
			} else {
				//$tag = str_replace(" ", ",", $tag);
				$arr = explode(",", $tag);
				return $arr;
			}
		} else {
			return false;		
		}
	}



	/**
	*	Add ids to join table 
	*
	*	@param integer $tag_id, $content_id tag value (example: 22,22)
	*	@return boolean true on success or false on failed
	*/
	function add_ids_to_join_table($content_id = NULL, $tag_id = NULL) {
	
		if ($tag_id && $content_id) {
		
			// check id combination exists
			$sql_chk = "SELECT * FROM tags_videos WHERE content_id=$content_id AND tag_id=$tag_id AND site_id=".$this->site_id." LIMIT 1";
			$que_chk = mysql_query($sql_chk, $this->connection);
		
			if (mysql_num_rows($que_chk) < 1) {
			
				// Add to join table
				//$sql_joi = "INSERT INTO tags_videos SET content_id=$content_id, tag_id=$tag_id";
				$sql_joi = "INSERT INTO tags_videos SET site_id = '".$this->site_id."', content_id=".$content_id.", tag_id=$tag_id";
				if ($que_joi = mysql_query($sql_joi, $this->connection)) {
					$insid_joi = mysql_insert_id($this->connection);
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
			
		} else {
			return false;
		}
	}
	

	/**
	*	Find tag from id 
	*
	*	@param integer $tag_id tag value (example: 23)
	*	@return string tagname or false if failed
	*/
	function find_tag($tag_id=NULL)
	{
		if($tag_id)
		{
			$sql_fnd = "SELECT tag FROM tags WHERE id='$tag_id' LIMIT 1";
			$que_fnd = mysql_query($sql_fnd, $this->connection);
			$arr_fnd = mysql_fetch_array($que_fnd);
			return $arr_fnd['tag'];
		}
		else
		{
			return false;
		}
	}
	

	/**
	*	Find id from tag 
	*
	*	@param string $tag tag value (example: brachiopoda)
	*	@return integer id of tag or false if failed
	*/
	function find_id($tag='')
	{
		if($tag!='')
		{
			$sql_fnd = "SELECT id FROM tags WHERE tag='$tag' LIMIT 1";
			$que_fnd = mysql_query($sql_fnd, $this->connection);
			$arr_fnd = mysql_fetch_array($que_fnd);
			return $arr_fnd['id'];
		}
		else
		{
			return false;
		}
	}
	

	/**
	*	Increase counter
	*
	*	@param integer $tag_id tag value (example: 22)
	*	@return boolean true if increased or false if failed
	*/
	function increase_tag($tag_id=NULL)
	{
		if($tag_id)
		{
			$sql_fnd = "UPDATE tags SET counter=counter +1 WHERE id=$tag_id";
			if($que_fnd = mysql_query($sql_fnd, $this->connection)){return true;}else{return false;}
		}
		else
		{
			return false;
		}
	}
	

	/**
	*	Increase counter
	*
	*	@param string $tag tag value (example: brachiopoda)
	*	@return boolean true if increased or false if failed
	*/
	function increase_tag_by_tagname($tag='')
	{
		if($tag!='')
		{
			$tag = trim(strtolower($tag));
			$sql_fnd = "UPDATE tags SET counter=counter +1 WHERE tag='$tag'";
			if($que_fnd = mysql_query($sql_fnd, $this->connection)){return true;}else{return false;}
		}
		else
		{
			return false;
		}
	}
	

	/**
	*	Find tags for content id
	*
	*	@param integer $content_id tag value (example: brachiopoda)
	*	@return array or false if failed
	*/
	function find_tags_for_content_id($content_id=NULL)
	{
		if($content_id)
		{
			$sql_fnd = "SELECT tags.tag FROM  tags LEFT JOIN ".$this->tablename." ON tags.id=".$this->tablename.".tag_id WHERE ".$this->tablename.".content_id=$content_id";
			$arr = array();
			if($que_fnd = mysql_query($sql_fnd, $this->connection))
			{
				while($arr_gavra = mysql_fetch_array($que_fnd))
				{
					$arr[] = $arr_gavra['tag'];
				}
				return $arr;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}



	/**
	*	Remives specific content id from join table
	*
	*	@param integer $content_id tag value (example: 27)
	*	@return true if deleted or false if failed
	*/
	function delete_content_id($content_id=NULL)
	{
		if($content_id)
		{
			$sql_del = "DELETE FROM ".$this->tablename." WHERE content_id=$content_id";
			if($que_del = mysql_query($sql_del, $this->connection))
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}


	/**
	*	Find contentids for specific tag_id
	*
	*	@param integer $tag_id tag value (example: 128)
	*	@return array or false if failed
	*/
	function find_all_content_id_with_tag_id($tag_id=NULL)
	{
		if($tag_id)
		{
			$sql_fnd = "SELECT content_id FROM ".$this->tablename." WHERE tag_id=$tag_id";
			$arr = array();
			if($que_fnd = mysql_query($sql_fnd, $this->connection))
			{
				while($arr_gavra = mysql_fetch_array($que_fnd))
				{
					$arr[] = $arr_gavra['content_id'];
				}
				return $arr;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}


	/**
	*	Find contentids for specific tagname
	*
	*	@param integer $tag value (example: simeon)
	*	@return array or false if failed
	*/
	function find_all_content_id_with_tag_name($tag='')
	{
		if($tag!='')
		{
			$tag = trim(strtolower($tag));
			$sql_fnd = "SELECT id FROM tags WHERE tag='$tag' LIMIT 1";
			if($que_fnd = mysql_query($sql_fnd, $this->connection))
			{
				if(mysql_num_rows($que_fnd)>0)
				{
					$arr_tag = mysql_fetch_array($que_fnd);
					$arr = $this->find_all_content_id_with_tag_id($arr_tag['id']);
					return $arr;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}



	/**
	*	Find most popular tags
	*
	*	@param integer $len value (example: 10)
	*	$len is length of toplist
	*	@return ordered array or false if failed
	*/
	function find_most_popular_tags($len=10)
	{
		if($len!==NULL)
		{
			$sql_fnd = "SELECT * FROM tags ORDER BY counter DESC, tag ASC LIMIT $len";
			if($que_fnd = mysql_query($sql_fnd, $this->connection))
			{
				if(mysql_num_rows($que_fnd)>0)
				{
					while($arr_tag = mysql_fetch_array($que_fnd))
					{
						if($arr_tag['counter']>0)
						{
							$arr[] = $arr_tag;
						}
					}
					return $arr;
				}
				else
				{
					return false;
				}
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}


	/**
	*	Find how many of tags are in the table
	*
	*	Return number of tags or false if failed
	*/
	function find_number_of_tags()
	{
		$sql_fnd = "SELECT COUNT(*) FROM tags";
		if($que_fnd = mysql_query($sql_fnd, $this->connection))
		{
			$arr_tag = mysql_fetch_array($que_fnd);
			return $arr_tag[0];
		}
		else
		{
			return false;
		}
	}


}
?>