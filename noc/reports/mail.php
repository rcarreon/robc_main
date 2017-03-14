<?php
ini_set('display_errors', 1);
error_reporting(E_ALL);
include("include/html2text.php");
include("include/functions.inc");
include("include/config.inc");
include("include/vars.inc");
   
date_default_timezone_set("$timezone");
$i=0; $status=1; 

if (isset($_POST["mail_st"])){
  $css_st = "<style type=\"text/css\">\n";
  $css_file = @fopen("bodies/stylesheets.bdy", "r");
  while (($buff = fgets($css_file, 4096)) !== false) {
    $css_st.= "$buff";
  }
  fclose($css_file);
  $css_st.= "</style>\n";

  $mail_st=$_POST["mail_st"];

  if (isset($_POST["site"])){
    $site=$_POST["site"];}
     
    if (isset($_POST["images"])&&($_POST["images"]!="")){
      $images=$_POST["images"]; }//print_r($images);
      if(isset($_POST["aaction"])&&$_POST["aaction"]=="Send Mail"){
          $to=$_POST["to"]; //echo $to;
          $pcomma = substr($to, -1); 
          if($pcomma==";")  //If pcomma exists delete it
            $to = substr($to, 0, strlen($to)-1);  
          else {  //there has to be a comma at the end if not send error, status=0 is error message, and i=count avoid while 
            echo "Email addresss error"."<br />"; 
            $status=0;
            $i=100;
          }//echo $to;
          $recipients=explode(",",$to); //print_r($recipients); //Separate recipients with comma     

          $subject=$_POST["subject"];
          $mail_togo = "<html>\n";
          $mail_togo .= "<head><meta http-equiv=\"Content-Type\" content=\"text/html;charset=utf-8\">\n";
          $mail_togo .= sprintf("%s\n</head>\n", $css_st);
          $mail_togo .= sprintf("<body>\n%s\n</body>\n", $mail_st);
          $mail_togo .= "</html>";

          $mail_tmp = str_replace("<tr>","*<tr>",$mail_togo);
          $mail_tmp = str_replace("<br />","*",$mail_tmp);
          $mail_tmp = strip_tags($mail_tmp);
          $mail_tmp = convert_html_to_text($mail_tmp);         
          $mail_plain = str_replace("*","\r\n",$mail_tmp);

          //hardcoded variable to remove 'css text' from 'emails plain text'
          $remove_css_in_plain = "table.rpt_hdr1 { width: 1170px; height: 130px; border-top-width: 0px; border-right-width: 0px; border-bottom-width: 0px; border-left-width: 0px; } td.rpt_hdr1_row_head { width: 140px; height: 23px; font-weight: bold; }";
          $mail_plain = str_replace($remove_css_in_plain, "", $mail_plain);

          $random_hash = md5(date('r', time())); 

          if($_FILES["fileAttach"]["tmp_name"])
          {
            //HEADERS
            $headers = "From: noc@gorillanation.com\r\n"
            ."Content-Type: multipart/mixed; boundary=\"PHP-mixed-".$random_hash."\"\n"
            ."--PHP-mixed-".$random_hash."\r\n"
            ."Content-Type: multipart/alternative; boundary=\"PHP-alt-".$random_hash."\"";

            $headers_rt = $headers;
          }
          else
          {   
            //HEADERS
            $headers = "From: noc@gorillanation.com\r\n" 
            ."Content-Type: multipart/alternative; boundary=\"PHP-alt-".$random_hash."\""; 
            $headers_rt = $headers;
          }

          //PLAIN TEXT BODY
          $plain_hdr = "--PHP-alt-".$random_hash."\r\n" 
            . "MIME-Version: 1.0\"\r\n"              //text/plain; charset="UTF-8"; format=flowed
            ."Content-Type: text/plain; charset=\"UTF-8\"\r\n"
            ."Content-Transfer-Encoding: 7bit\r\n\r\n"; 
          $message = $plain_hdr; 
          $message_rt = $plain_hdr;

          //$message .= "Primer Espacio<br />Segundo Espacio<br />\"Tercer Espacio\r\n\"Cuarto Espacio\r\n"
          $plain_bdy = $mail_plain."\r\n"
            ."--PHP-alt-".$random_hash."\r\n"; 
          $message .= $plain_bdy; 
          $message_rt .= $plain_bdy;
 
          //HTML BODY  
          $html_hdr = "MIME-Version: 1.0\"\r\n"
            ."Content-Type: text/html; charset=\"UTF-8\"\r\n"
            ."Content-Transfer-Encoding: 7bit\r\n\r\n"; 
          $message .= $html_hdr; 
          $message_rt .= $html_hdr;

          //$message .= "Primer Espacio<br />Segundo Espacio<br />\"Tercer Espacio\r\n\"Cuarto Espacio\r\n"
          $html_bdy = $mail_togo."\r\n"; 
          $message_rt .= $html_bdy;
          $html_bdy .= "--PHP-alt-".$random_hash."--\r\n"; 
          $message .= $html_bdy;
          //$message_rt .= "--PHP-alt-".$random_hash."\r\n"; 

          //ATTACHMENTS
          //RT PART   
          $n=1;
          if (isset($_POST["images"])&&($_POST["images"]!="")){ 
            foreach($images as $img_code){
              $file = fetchURL($img_code);
              $attach_name= "graphic_0".$n.".jpg";
              //$message_rt .= "Content-Type: image/jpg; name=\"banner.jpg\"\r\n"
              $message_rt .= "--PHP-alt-".$random_hash."\r\n";
              $message_rt .= "Content-Type: image/jpg; name=\"$attach_name\"\r\n"
              ."Content-Transfer-Encoding: base64\r\n"
              ."Content-ID: <".$img_code.">\r\n"
              ."\r\n"
              .chunk_split(base64_encode($file))
              ."";
              $n++;
            }
          }
          $message_rt .="--PHP-alt-".$random_hash."--";
          //END

          if($_FILES["fileAttach"]["tmp_name"])
          {
            $filename = $_FILES["fileAttach"]["name"]; //name of the file
            $filecontent = chunk_split(base64_encode(file_get_contents($_FILES["fileAttach"]["tmp_name"]))); //file attachment
            $fileAttachment = "--PHP-mixed-".$random_hash."\n"; //start attaching file in the email
            $fileAttachment .= "Content-Type: application/octet-stream; name=\"".$filename."\"\n";
            $fileAttachment .= "Content-Transfer-Encoding: base64\n";
            $fileAttachment .= "Content-Disposition: attachment; filename=\"".$filename."\"\n\n";
            $fileAttachment .= $filecontent."\n\n";
            //$fileAttachment .= "--PHP-mixed-".$random_hash."--";              //end of the attaching file
            
            $message .= $fileAttachment;
            //attaching files to the RT but it doesn't receive (RT problem)
            $message_rt .= $fileAttachment;
          }

          echo "Recipients:"."<br />";
          while( $i < count($recipients) ){ 
            $recipients[$i] = str_replace(' ', '',$recipients[$i]);
            echo $recipients[$i]."<br />";
            if($recipients[$i]=="q_noc@gorillanation.com") {
              //echo " RT was included"."<br />";
              $mail_sent = @mail( $recipients[$i], $subject, $message_rt, $headers_rt ); 
              if(!$mail_sent) {
                $status=0;
                break;

              }
              }
            else {
              $mail_sent = @mail( $recipients[$i], $subject, $message, $headers ); 
              if(!$mail_sent) {
                $status=0;
                break;
                }
              }
            $i++;
          }
          if($status) {
              echo "Mail Sent!";
              echo "<meta http-equiv=\"REFRESH\" content=\"2;url=index.php\">";
          }
          else 
              echo "***Error sending mail***";
      }

      if(isset($_POST["aaction"])&&($_POST["aaction"]=="aaction"||$_POST["aaction"]=="Mail Preview")){
        //JustMail Preview
          $to="technologyplatform@gorillanation.com, q_noc@gorillanation.com;";
          //$to="omar.rivera@gorillanation.com, q_noc@gorillanation.com;";
          //$to="q_noc@gorillanation.com;";
      if (isset($_POST["subject"])){
          $subject=$_POST["subject"];
          //$subject="[gorillanation.com #29623] TEST2";
      }
   
      if (isset($_POST["graphics"])&&($_POST["graphics"]!="")){ //Array of images href
        $graphics=$_POST["graphics"];
        $mail_gp = ""; $a=0; $images[$a] = "";

        foreach ($graphics as $graph) {  //RT Images
         $mail_gp .= $graph."<br />\n";
         $images[$a] = get_string_between( $graph,"<a href=","><img");
         $images[$a] = str_replace("width=1003&height=495","width=903&height=395",$images[$a]);
         //echo $graph; echo $images[$a];
         $a++;
       }
       //print_r($images);
     }
?>
<html>
<head>
    <title>NOC Reports</title>
    <script src="include/ckeditor/ckeditor.js"></script>
    <style type="text/css">
      <?php include ("bodies/stylesheets.bdy"); ?> 
      body{background-color: f0f0f0;}  
      td {
        font: 80%/1.45em "Lucida Grande", Verdana, Arial, Helvetica, sans-serif;
      }
    </style>
    <script type="text/javascript">
      CKEDITOR.config.contentsCss = ['css/main.css'];
      CKEDITOR.replace('t1');
    </script>
</head>

    <form method="POST" action="mail.php" enctype="multipart/form-data">
    <?php
    if (isset($_POST["graphics"])&&($_POST["graphics"]!=""))
      foreach($images as $img_code){
        echo "<input type=\"hidden\" name=\"images[]\" value=\"".$img_code."\" >";
      }

    ?>
    <table width="1230" > 
      <tr>
        <td><strong>To:</strong></td>
        <td><input id="to" type="text" value="<?php echo $to;?>" name="to" size="143"></td>
      </tr>
      <tr>
        <td><strong>Subject:</strong></td>
        <td><input id="subject" type="text" value="<?php echo $subject;?>" name="subject" size="143"></td>
      </tr>
    </table>
    <div id="container">
      <div id="left">
        <INPUT Type="button" VALUE="Go Back" onClick="history.go(-1);return true;">
        <input type="submit" name="aaction" value="Send Mail"></div>
      <div id="right"><textarea name="mail_st" align="left"><?php 
      echo $mail_st;
      if (isset($_POST["graphics"])&&($_POST["graphics"]!="")){
      //echo $mail_gp;
        echo "<!-- BEGINGraphics --!>";
        echo "<table width=1170 border=0><tr><td width=140 height=23><strong>Graphics:</strong></td></tr>";
        echo "<tr><td>".$mail_gp."</td></tr></table>\r\n";
        echo "<!-- ENDGraphics --!>";
      }
      ?></textarea>
      </div>
    </div>
    <script>
    CKEDITOR.replace( 'mail_st',
    {
    toolbar :
    [
    { name: 'document', items : [ 'Source','-','Save','Preview','Print','-'] },
    { name: 'clipboard', items : [ 'Cut','Copy','Paste','PasteText','PasteFromWord','-','Undo','Redo' ] },
    { name: 'editing', items : [ 'Find','Replace','-','SelectAll','-','SpellChecker', 'Scayt' ] },
    { name: 'links', items : [ 'Link','Unlink' ] },
    { name: 'insert', items : [ 'Image','Table','Flash' ]}, 
    { name: 'insert1', items : ['HorizontalRule','Smiley','SpecialChar','PageBreak'] },
    { name: 'tools', items : [ 'Maximize', '-','About' ] },
    '/',
    { name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','-','RemoveFormat' ] },
    { name: 'paragraph', items : [ 'JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','NumberedList','BulletedList','Outdent','Indent' ] },
    { name: 'styles', items : [ 'Styles','Format','Font','FontSize' ] },
    { name: 'colors', items : [ 'TextColor','BGColor' ] },
    ],
    width : 1230,
    height : 698
});
    </script>
    <tr>
      <td>Attachment</td>
      <td><input name="fileAttach" type="file" id="1"></td>
    </tr>
    <table width="1236">
    <tr><td><INPUT Type="button" VALUE="Go Back" onClick="history.go(-1);return true;"><input type="submit" name="aaction" value="Send Mail"></td></tr>   </table>
    </form>
</html>
<?php
    }

    }else
      echo "Error";
?>
