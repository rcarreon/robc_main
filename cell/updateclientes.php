<html>
<head>
	<link rel="stylesheet" href="css/bootstrap.min.css">
	<link rel="stylesheet" href="css/bootstrap-theme.min.css">
	<link rel="stylesheet" href="js/jquery-ui-1.10.3.custom/css/jquery-ui-1.10.3.custom.min.css">
	<link rel="stylesheet" href="style.css"> 
	<title>  Cell City | Actualiza Cliente  </title>
</head>
<body>
<?php
include("connection.php");
mysql_select_db("cellcity",$con2);
if(isset($_GET['id'])){
	$c_id    = $_GET['id'];
	$query1=mysql_query("select * from cliente where id ='$c_id'",$con2);
	$query2=mysql_fetch_array($query1);
?>
<a href=logout.php>Salir sesion</a>
<div id="uupdate">
	
	<form  method="get"  >
		
		<h4 align="center"> Edita Cliente </h4>
		<div id="upo"><strong>
			Id: <br><input type="text" name="editid"  disabled="disabled" id="editid" value="<?php echo $c_id ;?>" /><br/><br/>
			Nombre:<input type="text" name="editnombre"  id="editnombre" disabled="disabled" value="<?php echo $query2[1]; ?>"/><br/><br/>
			Email:<input type="text" name="editemail"  id="editemail" value="<?php echo $query2[2]; ?>"/><br/><br/><br/>
			<br/>
		</div>
		<div id="upo" >
						
			Celular:<input type="text" name="editcel"  id="editcel" value="<?php echo $query2[3]; ?>"/><br/>
			Telefono:<input type="text" name="edittel"  id="edittel" value="<?php echo $query2[4]; ?>"/><br/>
			<br/><br/></strong>			
		<br> <br /><br>	 <br /><br>	
		</div>	<br>	
		<a style="padding-right:-2em;">
				 <button  class="btn btn-primary" type="button" id="c_editaa" > Guardar cambios </button>
				</a>
		<a   href="/" style="padding-right:3em;">
   				<button type="button" id="regresa">Regresar</button>
				</a>
				
		<br> <br />		
	</form>	
</div>
<p id="ceditaste"></p>
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
$("#c_editaa").click(function(){	
	var cnombre		= $('#editnombre').val();
	var cemail 	= $('#editemail').val();
	var ccel	= $('#editcel').val();
	var ctel 	= $('#edittel').val();
	var cid 	= $('#editid').val();
//		return estatus;
	$.ajax({
	type:"GET",
		url:"ins.php?mcliente=1&editemail="+cemail+"&editnombre="+cnombre+"&editcel="+ccel+"&edittel="+ctel+"&editid="+cid,
		success: function(response){
			$('#ceditaste').html(response);
			alert('Contacto modificado con exito');
			window.location="/";
		},
	});
});

</script>
</body>
</html>


