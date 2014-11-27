<html>
<head>
	<link rel="stylesheet" href="css/bootstrap.min.css">
	<link rel="stylesheet" href="css/bootstrap-theme.min.css">
	<link rel="stylesheet" href="js/jquery-ui-1.10.3.custom/css/jquery-ui-1.10.3.custom.min.css">
	<link rel="stylesheet" href="style.css"> 
	<title>  Cell City | Actualiza Usuarios  </title>
</head>
<body>
<?php
include("connection.php");
mysql_select_db("cellcity",$con2);
if(isset($_GET['idu'])){
	$e_idu    = $_GET['idu'];
	$query1=mysql_query("select * from usuarios where idu='$e_idu'",$con2);
	$query2=mysql_fetch_array($query1);
?>
<a href=logout.php>Salir sesion</a>
<div id="uupdate">	
	<form  method="get"  >		
		<h4> Edita Usuario </h4>
		<div id="upo">
			Id: <br><input type="text" name="editidu"  disabled="disabled" id="editidu" value="<?php echo $e_idu ;?>" /><br/><br/>
			Usuario:<input type="text" name="editusuario"  id="editusuario" value="<?php echo $query2[1]; ?>"/><br/><br/>
			Nombre:<input  type="text" name="editnombre" id="editnombre" value="<?php echo $query2[3]; ?>"/><br/>								
		</div>
		<div id="upo" >
			Password:<input type="password" name="editpassword"  id="editpassword" value="<?php echo $query2[2]; ?>"/><br/>			
			Tipo:<label><?php echo $query2[4]; ?></label><br/>
			<select name="edittipo" id="edittipo" >
				<option selected="selected" disabled="disabled"><?php 
					echo $query2[4]; ?>
					</option>
				<option name="administrador" value="1" > Administrador </option>
				<option name="regular" value="2" > Regular </option>
			</select><br/><br/>				
			<p>1 = Administrador</p>
			<p>2 = Regular </p>				
		</div>	<br> <br /> 	<br> <br /> 
		<a  href="/">
   				<button type="button">Regresar</button>
				</a> <button  class="btn btn-primary" type="button" id="editaa" > Edita registro </button>
		<br> <br />		
	</form>	
</div>
<p id="editaste"></p>
<?php 
}
mysql_close($con2);
?>
<script src="js/jquery-1.10.2.min.js"></script>
<script src="js/jquery-ui-1.10.3.custom/js/jquery-ui-1.10.3.custom.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script type="text/javascript">
$(document).ready(function() {
	$(".datte").datepicker({dateFormat: "yy-mm-dd"});
});
</script>
<script type="text/javascript">
$("#editaa").click(function(){	
	var epassword		= $('#editpassword').val();
	var eusuario 	= $('#editusuario').val();
	var enombre	= $('#editnombre').val();
	var eidu 	= $('#editidu').val();
	var etipo = $('#edittipo option:selected').val();
//		return estatus;
	$.ajax({
	type:"GET",
		url:"ins.php?musuario=1&editusuario="+eusuario+"&editnombre="+enombre+"&edittipo="+etipo+"&editpassword="+epassword+"&editidu="+eidu,
		success: function(response){
			$('#editaste').html(response);
			alert('Contacto modificado con exito');
			window.location="/";
		},
	});
});
</script>
</body>
</html>


