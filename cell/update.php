
<html>
<head>
	<link rel="stylesheet" href="css/bootstrap.min.css">
	<link rel="stylesheet" href="css/bootstrap-theme.min.css">
	<link rel="stylesheet" href="js/jquery-ui-1.10.3.custom/css/jquery-ui-1.10.3.custom.min.css">
	<link rel="stylesheet" href="style.css"> 
	<title>  Cell City | Actualiza folio  </title>

</head>
<body>
<?php
include("connection.php");
//$uname =$_SESSION['uname'];
//$tipo =$_SESSION['tipouser'];

mysql_select_db("cellcity",$con2);
if(isset($_GET['folio'])){
	$e_folio     = $_GET['folio'];
	$nombree = mysql_real_escape_string($_GET['editcliente']);
	$query1=mysql_query("select folio,modelo,imei,cliente,status,reparacion,detalles,password,fecha from dispos where folio='$e_folio'",$con2);
	$query3=mysql_query("select email,telefono from cliente where nombre ='$nombree'",$con2);	
	$query2=mysql_fetch_array($query1);
	$query4=mysql_fetch_array($query3);
?>
<div id="update">
	<!-- <a href=logout.php>Salir sesion</a> -->
	<form  method="get" id="update" >		
		<h4> Edita Folio </h4>
		<div style="position:absolute;top:15%;left:15%">
		Folio:
		<div >
			<input type="text" name="editfolio"  disabled="disabled" id="editfolio" value="<?php echo $e_folio ;?>" />
		</div>
		Cliente:
		<div >
			<input  name="editcliente" id="editcliente" disabled="disabled" value="<?php echo $query2[3];?>" />
		</div>
		Equipo:
		<div >
			<input type="text" name="editmodelo"  id="editmodelo" value="<?php echo $query2[1]; ?>" tabindex=1 />
		</div>
		Fecha:
		<div >
			<input class="datte" type="text" name="editfecha" id="editfecha" value="<?php echo $query2[8]; ?>" tabindex=2 />
		</div>
		Imei:
		<div>
			<input type="text" name="editimei"  id="editimei" value="<?php echo $query2[2]; ?>" tabindex=3 />
		</div>
	</div>
		<div class="rcasos"  style="display:none;">				
					<h5 align="center"> Reparacion </h5>					
					<div><input type="checkbox" name="a_rep[]" id="a_rep" value="LCD">LCD 
					<input type="checkbox" name="a_rep[]" id="a_rep" value="Touch">Touch 
					<input type="checkbox" name="a_rep[]" id="a_rep" value="Trackpad">TrackPad</div>
					<div><input type="checkbox" name="a_rep[]" id="a_rep"  value="C.Carga">C. de Carga
					<input type="checkbox" name="a_rep[]" id="a_rep" value="Bocina">Bocina
				    <input type="checkbox" name="a_rep[]" id="a_rep" value="Grantia">Garantia</div>
					<div><input type="checkbox" name="a_rep[]" id="a_rep" value="Mic">Mic
					<input type="checkbox" name="a_rep[]" id="a_rep" value="Bateria">Bateria
					<input type="checkbox" name="a_rep[]" id="a_rep" value="Cristal">Cristal</div>
					<div><input type="checkbox" name="a_rep[]" id="a_rep" value="Flex">Flex
					<input type="checkbox" name="a_rep[]" id="a_rep" value="Camara">Camara
					<input type="checkbox" name="a_rep[]" id="a_rep" value="B.Encendido">Boton Encendido</div>
					<div><input type="checkbox" name="a_rep[]" id="a_rep" value="Portasim">Porta Sim
					<input type="checkbox" name="a_rep[]" id="a_rep" value="Servicio">Servicio
					<input type="checkbox" name="a_rep[]" id="a_rep" value="Software">Software</div>
					<div><input type="checkbox" name="a_rep[]" id="a_rep" value="No hay reparacion">No hay reparacion </div>

					<input type="button" id="lrep"  value="Listo">					
		</div>
		<div style="position:absolute;top:15%;right:15%">
								
				Status:<label ><?php echo $query2[4]; ?></label><br/>
			<div>
			<select id="editstatus" tabindex=4 class="form-control">
				<option selected="selected" disabled="disabled"><?php echo $query2[4]; ?></option>
				<option  value="listo" id="listo"> Listo </option>
				<option  value="listo" id="nohay"> No hay reparacion </option>
				<option  value="Entregado" id="Entregado" > Entregado </option>

			</select>
		</div>			
				Detalles:
				<div><textarea type="text"  maxlength="115" name="editdetalles" id="editdetalles" tabindex=5 ><?php echo $query2[6]; ?></textarea></div>
				Contraseña:<div><input type="text" name="editpassword" id="editpassword" value="<?php echo $query2[7]; ?>" tabindex=6 /></div>		
				Email:<div><input type="text" disabled="disabled"  name="editemail" id="editemail" value="<?php echo $query4[0]; ?>"/></div>									
				Contacto:<div><input type="text"  disabled="disabled" name="editcontacto" id="editcontacto" value="<?php echo $query4[1]; ?>"/></div>	
			<br /><br>		
		</div></div>	<br> <br /><br /><br /><br />
		
				<button  style="position:relative;left:37%;"class="btn btn-primary" type="button" id="editaa" tabindex=7 > Guardar cambios </button>
				<button  style="position:relative;left:39%;"  type="button" id="printeando" onclick="updateoutput()" tabindex=8> Imprimir </button>								
				<a  href="/" >
   					<button style="position:relative;left:45%;" type="button" id="regresa" tabindex=9>Regresar</button>
				</a>		
				
	</form>	

				
				
		<!-- #######################IMPRIMIR################# -->

		<div id="print" class="print" >	
			<img id="logo" src="images/logocellcity250x1002.jpg" alt="Cell City logo" height="110" width="350">
				
				<table class="printt" style="width:35em;height:5em;">
				
					<tr>
						<td class="uno" ><strong>Cliente</strong></td>
						<td class="dos" id="cliente" name="cliente"></td>
					</tr>
						<td class="uno"  ><strong>Equipo</strong></td>
						<td class="dos" id="equipo"  > </td>
					</tr>
						<td class="uno"  ><strong>Imei</strong></td>
						<td class="dos" id="imei" ></td>
					</tr>
				
				</table>
				<br>
				
				<div style="position:relative;left:15%;">
					<input type="checkbox"> SIM </input>
					<input type="checkbox"> Bateria</input>
					<input type="checkbox"> Tapa</input>
					<input type="checkbox"> Memoria </input>
				</div>
				Original
				<table class="printt" id="pfolio">
					<tr>
						<strong><td class="uno" align="center"><strong>Folio</strong></td></strong>
					</tr>
					<tr>
						<td class="uno" align="center" id="pfolio1" >

						</td>
					</tr>
				</table>
				<br>
				<table class="printt" id="pfolio">
					<tr>
						<strong><td class="uno" align="center"><strong>Fecha</strong></td></strong>
					</tr>
					<tr>
						<td class="uno" id="fecha"></td>
					</tr>
				</table>									
				<table class="printt" style="width:35em;height:5em;bottom:10%;">
					<thead>
						<tr>
							<th>DETALLES DE SERVICIO TECNICO</th>
						</tr>
						<tr>
							<td>La contraseña es <label id="contra"></label></td>
						</tr>
						<tr>
							<td rowspan="4" class="uno" id="detalles" ></td>
						</tr>
					</thead>																
				</table>
				<p class="alinea"><strong>EN CAMBIO DE CRISTAL EL CLIENTE ACEPTA EL RIESGO DE DANO DE PANTALLA</strong></p>	
				<div style="width:550px;" class="alinea">
					<p id="politicas" align="justify">Politicas: 1.Debe de presentar este comprobante para que se le haga entrrega del equipo.2.Despues de 15 dias no nos hacemos
				responsables de su equipo.3.Si no recoge su equipo en 30 dias,pasa a ser propiedad de Cell City.4. No se hacen garantias en equipos golpeados
				o mojados.5. No nos hacemos responsables de la perdida parcial o total de la informacion en su equipo. NO NOS HACEMOS RESPONSABLES EN CASO DE
				ROBO O INCENDIO.</p>
				</div>
				<br><br><br>				
								<div style="position:relative;left:5%;">
									<p > ________________________________  <br/>                   
									Recibio <?php echo $uname ?></p>
								</div>
								<div style="position:relative;left:55%;bottom:7%;">
								<p > ________________________________  <br/>                   
									Aceptacion de Cliente</p>
								</div>
										<strong><hr style="position:absolute;top:670px;"></strong>
								<p>
				<div style="position:relative;bottom:50%;left:78%;">Patron:
					<img src="images/cuadritocellcity2.jpg" width="120" height="120">
				</div>
				<div style="position:relative;bottom:20%;padding-left:20em;">
					<button id="imp" TYPE="button" onClick="printArea('print');" >Imprimir
					<button type="regresa" id="cancelar">Cancelar
				</div>					
		</div>
		
		<div id="segundo" style="display:none;">			
				<!-- SEGUNDO -->
				<img id="logo" src="images/logocellcity250x1002.jpg" alt="Cell City logo" height="110" width="350">				
				<table class="printt" style="width:35em;height:5em;">				
					<tr>
						<td class="uno" ><strong>Cliente</strong></td>
						<td class="dos" id="cliente2" ><font style="font-size:10em;" name="cliente"></font></td>
					</tr>
						<td class="uno" ><strong>Equipo</strong></td>
						<td class="dos" id="equipo2"  > </td>
					</tr>
						<td class="uno"  ><strong>Imei</strong></td>
						<td class="dos" id="imei2" ></td>
					</tr>				
				</table>
				<br>				
				<div style="position:relative;left:15%;">
					<input type="checkbox"> SIM </input>
					<input type="checkbox"> Bateria</input>
					<input type="checkbox"> Tapa</input>
					<input type="checkbox"> Memoria </input>
				</div>
				<table class="printt" id="pfolio">
					<tr>
						<td class="uno" align="center"><strong>Folio</strong></td>
					</tr>
					<tr>
						<td class="uno" align="center" id="pfolio2" >
						</td>
					</tr>
				</table>
				<br>
				<table class="printt" id="pfolio">
					<tr>
						<td class="uno" align="center"><strong>Fecha</strong></td>
					</tr>
					<tr>
						<td class="uno" id="fecha2"></td>
					</tr>
				</table>									
				<table class="printt" style="width:35em;height:5em;bottom:10%;">
					<thead>
						<tr>
							<th>DETALLES DE SERVICIO TECNICO</th>
						</tr>
						<tr>
							<td>La contraseña es <label id="contra2"></label></td>
						</tr>
						<tr>
							<td rowspan="4" class="uno" id="detalles2" ></td>
						</tr>
					</thead>
					<br /><br/>																
				</table>
				<p class="alinea"><strong>EN CAMBIO DE CRISTAL EL CLIENTE ACEPTA EL RIESGO DE DANO DE PANTALLA</strong></p>	
				<div style="width:550px;" class="alinea">
					<p id="politicas" align="justify">Politicas: 1.Debe de presentar este comprobante para que se le haga entrrega del equipo.2.Despues de 15 dias no nos hacemos
				responsables de su equipo.3.Si no recoge su equipo en 30 dias,pasa a ser propiedad de Cell City.4. No se hacen garantias en equipos golpeados
				o mojados.5. No nos hacemos responsables de la perdida parcial o total de la informacion en su equipo. NO NOS HACEMOS RESPONSABLES EN CASO DE
				ROBO O INCENDIO.</p>
				</div>
				<br><br><br><br>
				
								<div style="position:relative;left:5%;">
									<p > ________________________________  <br/>                   
									Recibio <?php echo $uname ?></p>
								</div>
								<br>
								<div style="position:relative;left:55%;bottom:9%;">
								<p > ________________________________  <br/>                   
									Aceptacion de Cliente</p>
								</div>
								<p>
				<div style="position:absolute;top:133%;left:78%;">Patron:
					<img src="images/cuadritocellcity2.jpg" width="120" height="120">
				</div>
				<div style="position:relative;bottom:20%;padding-left:20em;">
					<button id="imp" TYPE="button" onClick="printArea('print');" >Imprimir
					<button type="regresa" id="cancelar">Cancelar
				</div>
</div>		
			<!-- #######################IMPRIMIR################# -->	
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
function goBack() {
    window.history.back()
}
$(document).ready(function() {
	$(".datte").datepicker({dateFormat: "yy-mm-dd"});
});
$(function(){
	$('.rcasos').draggable();
});

$('#editstatus').change(function(){
	$('.rcasos').show();
	alert('Si quieres cambiar de status sin que las reparaciones sufran cambios , no marques nada y haz click en listo para cerrar el dialogo, despues guarda los cambios');
});
$('#editstatus').change(function(){
			$('.rcasos').show();
});
$(document).ready(function(){
		$('#lrep').click(function(){
			$('.rcasos').hide();
		});
});
////////////////////////IMPRIMIR/////////////////////////////////////////////
////ESTA FUNCION ES PARA MANDAR LOS VALORES QUE ESTAN EN EL DIV DE UPDATE PARA EL DIV DE PRINT /////////////
function 	updateoutput(){
			document.getElementById('detalles').innerHTML=document.getElementById('editdetalles').value;
			document.getElementById('imei').innerHTML=document.getElementById('editimei').value;
			document.getElementById('equipo').innerHTML=document.getElementById('editmodelo').value;
			document.getElementById('pfolio1').innerHTML=document.getElementById('editfolio').value;			
			document.getElementById('fecha').innerHTML=document.getElementById('editfecha').value; 
			document.getElementById('cliente').innerHTML=document.getElementById('editcliente').value;
			document.getElementById('contra').innerHTML=document.getElementById('editpassword').value;


			///Segundo///
			document.getElementById('detalles2').innerHTML=document.getElementById('editdetalles').value;
			document.getElementById('imei2').innerHTML=document.getElementById('editimei').value;
			document.getElementById('equipo2').innerHTML=document.getElementById('editmodelo').value;
			document.getElementById('pfolio2').innerHTML=document.getElementById('editfolio').value;			
			document.getElementById('fecha2').innerHTML=document.getElementById('editfecha').value;			
			document.getElementById('cliente2').innerHTML=document.getElementById('editcliente').value;
			document.getElementById('contra2').innerHTML=document.getElementById('editpassword').value;					
			
}
////ESTA FUNCION ES PARA MANDAR A IMPRIMIR NADA MAS EL DIV QUE SE QUIERE ///////////
function printArea(areaName){
        var printContents = document.getElementById('print').innerHTML;
        var segundo = document.getElementById('segundo').innerHTML;
        
        //var originalContents = document.body.innerHTML;
        document.body.innerHTML = printContents + segundo  ;
        window.print();
        document.body.innerHTML= "";
        location.reload();        
}    
$(document).ready(function(){
		$('#lrep').click(function(){
			$('#imprime').hide();
		});
});
$('#printeando').click(function(){
		$('.print').show();
		$('#regresa').show();

});
$('#cancelar').click(function(){
		$('.print').hide();
});

$(function() {
    $( ".print" ).draggable();
});
////////////////////////////////////////////////////////////////////////////
$("#editaa").click(function(){
	//var eimei		= $('#editimei').val(obj[0].editimei);
	var eimei		= $('#editimei').val();
	var emodelo 	= $('#editmodelo').val();
	var ecliente	= $('#editcliente').val();	
	var econta		= $('#editcontacto').val();
	var efecha		= $('#editfecha').val();
	var eemail		= $('#editemail').val();
	var efolio		= $('#editfolio').val();
	var epass 		= $('#editpassword').val()
	var edetalles   = $('#editdetalles').val();
	var estatus = $('#editstatus option:selected').val();
	var repara  = [];
	   $(':checkbox:checked').each(function(i){
	   		repara[i] = $(this).val();
	   });
	$.ajax({
	type:"GET",
		url:"ins.php?eeditas=1&editimei="+eimei+"&editcliente="+ecliente+"&editmodelo="+emodelo+"&editstatus="+estatus+"&editcontacto="+econta+"&editfecha="+efecha+"&editemail="+eemail+"&editfolio="+efolio+"&editpassword="+epass+"&editdetalles="+edetalles+"&editrepara="+repara,
		success: function(response){
			$('#editaste').html(response);
			alert('Contacto modificado con exito');
			//window.location="/";
		},
	});
});
</script>
</body>
</html>


