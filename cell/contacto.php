<?php
		error_reporting(E_ALL);
		ini_set('display_errors', 'on');
 		$to = "rcarreon.gn@gmail.com";
 		$subject = "Contact Us";
 		$from = $_POST['email'] ;
 		$message = $_POST['message'] ;
 		$headers = "$from";
 		$sent = mail($to, $subject, $message, $headers) ;
 		if($sent){
 			?> <script type="text/javascript">alert('Email sent to <?php $to ?> successfully')</script> <?php
 		}else{
 			?> <script type="text/javascript">alert('Email could not  send out try again')</script> <?php
 		}
 ?>