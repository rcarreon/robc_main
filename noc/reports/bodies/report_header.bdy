<!-- report_header.bdy -->
<?php
$t_head_width=1170;
$t_head_height=130;

/*
?>
<table class=\"rpt_hdr1\">
  <tr>
    <td width=100><strong>Date:</strong></td>
    <td><?php echo date('l M d Y') ?></td>
  </tr>
  <tr>
    <td><strong>Down Time:</strong></td>
    <td><?php echo $downtime ?><d>
  </tr>
  <tr>
     <td ><strong>Recovery Time:</strong></td>
     <td ><?php echo $uptime ?></td>
  </tr>
    <td><strong>Problem Title:</strong></td>
    <td><?php echo $subject ?></td>
  </tr>
  <tr>
    <td><strong>Site:</strong></td>
    <td><?php echo $site ?></td>
  </tr>
  <tr>
    <td><strong>VIP:</strong></td>
    <td><?php echo $evip ?></td>
  </tr>
</table>

<table width=<?php echo $t_head_width ?> border=0>
  <tr>
    <td><strong>Vip Visualizer info:</strong>
      <a href=http://vipvisual.gnmedia.net/extractServer?value=<?php echo $site ?> target=_blank>
http://vipvisual.gnmedia.net/extractServer?value=<?php echo $site ?></a>
    </td>
  </tr>
</table>

<?php
 *
 */
  $mail_st = "<table class=\"rpt_hdr1\">\n";
  $mail_st .="  <tr>\n";
  $mail_st .="    <td class=\"rpt_hdr1_row_head\"><strong>Date:</strong></td>\n";
  $mail_st .="    <td>".date('l M d Y')."</td>\n";
  $mail_st .="  </tr>\n";
  $mail_st .="  <tr>\n";
  $mail_st .="    <td class=\"rpt_hdr1_row_head\"><strong>Down Time:</strong></td>\n";
  $mail_st .="    <td>".$downtime."</td>\n";
  $mail_st .="  </tr>\n";
  $mail_st .="  <tr>\n";
  $mail_st .="    <td class=\"rpt_hdr1_row_head\"><strong>Recovery Time:</strong></td>\n";
  $mail_st .="    <td >".$uptime."</td>\n";
  $mail_st .="  </tr>\n";
  if ($user->name!="jdoe"){
  $mail_st .="  <tr>\n";
  $mail_st .="    <td class=\"rpt_hdr1_row_head\"><strong>Name:</strong></td>\n";
  $mail_st .="    <td >".$user->fullname."</td>\n";
  $mail_st .="  </tr>\n";
  }
  $mail_st .="    <td class=\"rpt_hdr1_row_head\"><strong>Problem Title:</strong></td>\n";
  $mail_st .= "   <td>".$subject."</td>\n";
  $mail_st .="  </tr>\n";
  $mail_st .="  <tr>\n";
  $mail_st .="    <td class=\"rpt_hdr1_row_head\"><strong>Site:<//strong></td>\n";
  $mail_st .="    <td>$site</td>\n";
  $mail_st .="  </tr>\n";
  //$mail_st .="  <tr>\n";
  //$mail_st .="    <td> class=\"rpt_hdr1_row_head\"VIP:</td>\n";
  //$mail_st .="    <td>".$evip."</td>\n";
  //$mail_st .="  </tr>\n";
  $mail_st .="</table>\n";
  $mail_st .="<table width=1170 border=0>\n";
  $mail_st .="  <tr>\n";
  $mail_st .="    <td><strong>Vip Visualizer info:</strong>";
  $mail_st .="<a href=http://vipvisual.gnmedia.net/extractServer?value=".$site." tarPOST=_blank >";
  $mail_st .="http://vipvisual.gnmedia.net/extractServer?value=".$site."</a>";
  $mail_st .="</td>\n";
  $mail_st .="  </tr>\n";
  $mail_st .="</table>\n";

  echo $mail_st;
?>
<!-- report_header.bdy  end -->
