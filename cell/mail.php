<html>
<body>
<form method="post" action="contacto.php"> 
 Email: <input name="email" type="text" id="email"><br>
 Message:<br> 
 <textarea name="message" rows="15" cols="40" id="message"></textarea><br> 
 <input type="submit" id="semail"> 
 </form> 
 <p id="respemail"></p>


<script src="js/jquery-1.10.2.min.js"></script>
<script type="text/javascript">

 $("#semail").click(function() {
 				var email = $('#email') .val();
 				var mess  = $('$message').val();

    $.ajax({    
      type: "GET",
      url: "contacto.php?sendemail=1&email="+email+"&message="+mess,
      dataType: "html",   
      //expect html to be returned                
      success: function(response){                    
          $("#respemail").html(response);           
      },
      
    });
   });
 </script>
</body>
 </html>
