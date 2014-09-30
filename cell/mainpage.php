

<html>
<head>
	<title>  Cell City | Hermosillo  </title>
	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link rel="stylesheet" href="/css/bootstrap.min.css"> <!-- en produccion este parece no cargar averiguar por que...-->
	<link rel="stylesheet" href="css/bootstrap-theme.min.css">
	<link rel="stylesheet" href="js/jquery-ui-1.10.3.custom/css/jquery-ui-1.10.3.custom.min.css">
	<link rel="stylesheet" href="style.css"> 
	<link rel="shortcut icon" type="image/x-icon" href="./favicon.ico" >

<script type="text/javascript">


function optionCheck(){
	var option = $('#opsearch option:selected').val();
	if (option == "agregaru"){
		$("#agregau").show();
		$("#mostrar").hide();
	}
	if (option == "mostraru"){
		$("#agregau").hide();
		$("#mostrar").show();
	}

}
function optionCheck2(){
	var option2 = $('#opsearch2 option:selected').val();

switch (option2){
		case "imei":
			$("#s_imei").show();
			$("#s_folio").val('').hide();
			$("#s_modelo").val('').hide();
			$("#s_cliente").val('').hide();
			$("#s_status").val('').hide();
			$("#s_todos").val('').hide();
			$("#s_fecha").val('').hide();
			$("#s_submit").show();
			$("#s_table").show();
			$('#sestatus').hide();
		break;
		case "folio":
			$("#s_imei").val('').hide();
			$("#s_folio").show();
			$("#s_modelo").val('').hide();
			$("#s_status").val('').hide();
			$("#s_todos").val('').hide();
			$("#s_cliente").val('').hide();
			$("#s_fecha").val('').hide();
			$("#s_submit").show();
			$("#s_table").show();
			$('#sestatus').hide();
		break;
		case "modelo":
			$("#s_imei").val('').hide();
			$("#s_folio").val('').hide();
			$("#s_status").val('').hide();
			$("#s_todos").val('').hide();
			$("#s_modelo").show();
			$("#s_cliente").val('').hide();
			$("#s_fecha").val('').hide();
			$("#s_submit").show();
			$("#s_table").show();
			$('#sestatus').hide();
		break;
		case "cliente":
			$("#s_imei").val('').hide();
			$("#s_folio").val('').hide();
			$("#s_modelo").val('').hide();
			$("#s_status").show();
			$("#s_todos").val('').hide();
			$("#s_fecha").val('').hide();
			$('#sestatus').show();
			$("#s_cliente").show();
			$("#s_submit").show();
			$("#s_table").show();
		break;
		case "todos":
			$("#s_imei").val('').hide();
			$("#s_folio").val('').hide();
			$("#s_modelo").val('').hide();
			$("#s_cliente").val('').hide();
			$("#s_status").val('').hide();
			$("#s_fecha").val('').hide();
			$("#s_todos").show();
			$("#s_submit").show();
			$("#s_table").show();
			$('#sestatus').hide();
		break;
		case "todosclientes":
			$("#s_imei").val('').hide();
			$("#s_folio").val('').hide();
			$("#s_modelo").val('').hide();
			$("#s_cliente").val('').hide();
			$("#s_status").val('').hide();
			$("#s_fecha").val('').hide();
			$("#s_todos").show();
			$("#s_submit").show();
			$("#s_table").show();
			$('#sestatus').hide();
		break;
		case "fecha":
			$("#s_imei").val('').hide();
			$("#s_folio").val('').hide();
			$("#s_modelo").val('').hide();
			$("#s_cliente").val('').hide();
			$("#s_status").val('').hide();
			$("#s_fecha").show();
			$("#s_todos").show();
			$("#s_submit").show();
			$("#s_table").show();
			$('#sestatus').hide();
		break;

	}
	
}

function optionCheck3(){
		var option3 = $('#opsearch3 option:selected').val();
		switch (option3) {
			case "agregarf":
		//	alert('Si el campo "Cliente" no puede autocompletar deberas de agregrar cliente primero');
				$("#agregaf").show();
			break;
		}

}
function optionCheck4(){
		var option4 = $('#opsearch4 option:selected').val();
		switch (option4) {
			case "agregarc":
				
				//$("#agregau").hide();
				$("#m_todosclientes").hide();
				$("#agregac").show();
				
			break;
			case "todosclientes":
				$("#agregac").hide();
				$("#m_todosclientes").show();
			break;

		}

}

</script>


</head>
<body >	
<div class="container">
	<div class="main">

		<!-- <div id="dialog"  style="width:50em;" title="Dialog Form">
		<form action=""   method="post">
			<label>Folio:</label>
			<input id="efolio" name="efolio" type="text">
			<label>Modelo:</label>
			<input id="emodelo" name="emodelo" type="text">
			<label>Imei:</label>
			<input id="eimei" name="eimei" type="text">
			<label>Cliente:</label>
			<input id="ecliente" name="ecliente" type="text">
			<label>Status:</label>
			<input id="estatus" name="estatus" type="text">
			<label>Repara:</label>
			<input id="erepara" name="erepara" type="text">
			<label>Password:</label>
			<input id="epass" name="epass" type="text">
			<label>Email:</label>
			<input id="email" name="email" type="text">
			<label>Detalles:</label>
			<input id="edetalles" name="edetalles" type="text">
			<label>Fecha:</label>
			<input id="efecha" name="efecha" type="text">
			<label>Email:</label>
			<input id="eemail" name="eemail" type="text">	
			<label>Contacto:</label>
			<input id="econtacto" name="econtacto" type="text">			
			<input id="submit" type="submit" value="Submit">
		</form>
		</div>		
</div> -->

	
<?php
	include "connection.php";
	mysql_select_db("cellcity",$con2);	
	$sql = "SELECT usuario FROM usuarios WHERE usuario = 'rob'"; 
    $rec = mysql_query($sql) or die ("Query failed: ".mysql_error()."Actual query:".$query); 
    $rows = mysql_fetch_row($rec);	    
    mysql_close($con2);		
?>
<div class="container"  id="wrapper">	
	<hr>
	<?php 
		session_start(); 		
		$tipo =$_SESSION['tipouser'];
		$uname =$_SESSION['uname'];
	echo "<p>Bienvenid@<strong> $uname !</strong></p>";
	?>			
		<a id="logout" href=logout.php>Salir Sesion</a>  

		<div align="center" >				
				<img src="images/titulocellcity.jpg">
				<hr>
		</div>			
		<div align="center" id="botones">			
			<div>
				<button   type="button" class="btn btn-primary" id="s_submit_b" value="bujcar" >Buscar</button>
				<button   type="button" class="btn btn-primary" id="s_submit_a"  value="folios">Folios</button>
				<button   type="button" class="btn btn-primary" id="s_submit_c"  value="clientela ">Clientes</button>
				<?php if ($tipo != 1){?>
					<br><button  style="display:none;"  class="btn btn-primary" id="s_submit_mu"  value="manejausuario">Manejar Usuarios</button>
				<?php } else { ?>
					<br><br /><button   type="image"   style="position:relative;left: 13.5%;" id="s_submit_mu"  value="manejausuario">Manejar Usuarios</button>
					<?php  } ?>
			</div>
		</div>	
		<div  class= "container" id="bujca"  style="display:none;">
			<h4>Busca Folio por:</h4>
			<form  action="" id="bpor">				
					<select  onchange="optionCheck2();"name="busq" id="opsearch2" title="Selecciona una de las opciones siguientes para buscar
					un equipo en nuestra base de datos" class="form-control" style="width:200px;">
						<option selected="selected" disabled="disabled">--Seleciona  opcion--</option>
						<option value="imei"  > Imei</option>
						<option value="folio" > Folio </option>
						<option value="modelo" > Equipo </option>
						<option value="cliente" > Cliente</option>	
						<option value="fecha" > Fecha</option>	
						<option value="todos">Todos los Equipos</status>
					</select>
				</form>
		</div>
		<div class="container" style="display:none;" id="manageagre">
				<h4>Agregar por:</h4>
				<form >
					<select onchange="optionCheck3();" name="maneja" id="opsearch3"  class="form-control" style="width:200px;">
						<option selected="selected" disabled="disabled">--Selecciona Opcion--</option>						
						<option value="agregarf">Agregar Folio</option>						
					</select>
				</form>
		</div>
		<div class="container" style="display:none;" id="manageclien" >
				<h4>Busca/Agrega Clientes:</h4>
				<form>
					<select onchange="optionCheck4();" name="maneja" id="opsearch4"  class="form-control" style="width:200px;".form>
						<option selected="selected" disabled="disabled">--Selecciona Opcion--</option>
						<option value="agregarc">Agregar Cliente </option> 
						<option value="todosclientes" >Todos los Clientes</option>
					</select>
				</form>
		</div>
		<div id="m_todosclientes"  style="display:none;position:absolute;left:3%;" class="container">
			
				<form  method="get" id="bujca4">
					<button type="button" id="clientes_submit" style="position:relative; left:1.5%;">Mostrar Clientes</button><br><br />
					
					<table   id="muestrablaclientes"  class="table table-striped table-hover tablesorter" >	

								
					</table>
				
				</form>
			
		</div>
		<div class="container"  id="bujcapor">
				<form name="busqueda" method="get" id="bujca2">
					<input  type="text" name="s_folio" id="s_folio"  placeholder="Busca por folio" style="display:none;" >
					<input  type="text" name="s_imei" id="s_imei"  class="s_imei_auto" placeholder="Busca por imei" style="display:none;"> 
					<input  type="text" name="s_modelo" id="s_modelo"  placeholder="Busca por Equipo" style="display:none;" >
					<input  type="text" name="s_fecha" id="s_fecha" placeholder="Buscar por fecha" style="display:none;" class="datte">
					<input  type="text" name="s_cliente" id="s_cliente"  placeholder="Busca por cliente" class="s_cliente_auto" style="display:none;" >
						<select name="s_status" id="s_status" style="display:none;"  >
							<option selected="selected" disabled="disabled" value="">opcion</option>
							<option name="s_status" value="listo" > Listo </option>
							<option name="s_status" value="En reparacion" > En reparacion </option> 
							<option name="s_status" value="Garantia" > Garantia </option>  
							<option name="s_status" value="Entregado" > Entregado </option>
					  	</select>	 						
					</div>
					<button   type="button" class="btn btn-primary" id="s_submit" style="display:none;"   >Buscar</button>	

					 	
				</form>
				<div class="col-xs-3" style="padding: 4px 2px;display:none;" >
                                        <select name="entries" id="entries" class="form-control" >
                                                <option value="10">10</option>
                                                <option value="20" selected="selected">20</option>
                                                <option value="50">50</option>
                                                <option value="100">100</option>
                                                <option value="200">200</option>
                                                <option value="-1">All</option>
                                        </select>
                   </div>	
		</div>
		<div class="container" id="s_table"  style="display:none;">
			<div  style="display:inline-block;">
				<br />
				<form name="editar" method="get" id="eedita">
					
					<table  id="respuestabla"  class="table table-striped table-hover tablesorter">	
						<tbody>
						</tbody>
									
					</table>
				
				</form>
				
			</div>
		</div>
		
		<!--<div id="footer">	
			<div class="container span12">
				<h4> CellCity 2014 </h4>
			</div>
		</div> -->
		<div   class = "container" id="agregaf" style="display:none;">			
			<form   name="agrega" method="post" id="aagrega"><strong>
				<h4 align="Center" >Agregar Folio</h4>				
				<font color="red">**</font>Cliente 
				<div class="f_agrega">
					<input type="text" name="a_cliente" id="a_cliente" class="s_cliente_auto" placeholder="Ingresa Cliente" tabindex=1 style="text-transform:uppercase;">	
				</div>
				Imei:
				<div>
				 <input type="text" name="a_imei" id="a_imei" class="s_imei_auto" placeholder="Ingresa Imei" tabindex=2 style="text-transform:uppercase;">
			    </div>
				Equipo: 
				<div class="f_agrega" >
					<input type="text" id="a_modelo" name="a_modelo" placeholder="Ingresa Equipo" tabindex=3  style="text-transform:uppercase;">
				</div>
					Fecha:
				<div>
						<input class="datte" type="text" name="a_fecha" id="a_fecha" value="<?php $date = date('Y-m-d'); echo $date; ?>" tabindex=3 style="text-transform:uppercase;">
				</div>
				<div class="f_agrega">
				 <input type="radio" name="a_status" id="a_status"   class="lis" value="Garantia" tabindex=4 >Garantia
					   <input type="radio" name="a_status" id="a_status"  class="rep" value="En reparacion" tabindex=5 >Nuevo Ingreso 				
			    </div>
			    
			   Detalles Tecnicos:
			    <div>			
			    	<textarea maxlength="115" type="text" id="a_detalles" name="a_detalles" placeholder="Detalles Servicio Tecnico" tabindex=6 style="text-transform:uppercase;"></textarea>					
			    </div>
			    <div style="position:absolute;top:67%;right:10%">
			    Contrasena:
			    <div>
					<input type="text" id="a_password" name="a_password" placeholder="Ingresa Contraseña" tabindex=7 style="text-transform:uppercase;">				
				</div>
				</div>
				</strong><br/><br>
				<button    type="button" id="a_submit" class="btn btn-primary" tabindex=8 > Agregar Folio </button>
				<!--<button    type="button" id="nuevo" class="btn btn-primary" > Nuevo Folio </button> -->
				<button type="button" id="printeando" onclick="updateoutput()" disabled="disabled" tabindex=9> Imprimir </button>											
				</form>	
				<button  style="position:absolute;bottom:-9%;left:65%;"  id="limpia" type="button" tabindex=11>Limpiar datos</button>												
				<a href="/" >
   				<button style="position:absolute;bottom:-9%;left:85%;" type="button" tabindex=10>Regresar</button>
				</a>

		</div>		
		<!--IMPRIMIR -->
	<div id="print" class="print" >	
			<img id="logo" src="images/logocellcity250x1002.jpg" alt="Cell City logo" height="110" width="350">				
				<table class="printt" style="width:35em;height:5em;">				
					<tr>
						<td class="uno" ><strong>Cliente</strong></td>
						<td class="dos" id="cliente" name="cliente"></td>
					</tr>
						<strong><td class="uno"  ><strong>Equipo</strong></td></strong>
						<td class="dos" id="equipo"  > </td>
					</tr>
						<strong><td class="uno"  ><strong>Imei</strong></td></strong>
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
						<td class="dos" id="cliente2" name="cliente"></td>
					</tr>
						<strong><td class="uno"  ><strong>Equipo</strong></td></strong>
						<td class="dos" id="equipo2"  > </td>
					</tr>
						<strong><td class="uno"  ><strong>Imei</strong></td></strong>
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
						<strong><td class="uno" align="center"><strong>Folio</strong></td></strong>
					</tr>
					<tr>
						<td class="uno" align="center" id="pfolio2" >

						</td>
					</tr>
				</table>
				<br>
				<table class="printt" id="pfolio">
					<tr>
						<strong><td class="uno" align="center"><strong>Fecha</strong></td></strong>
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
				<div style="position:absolute;top:125%;left:78%;">Patron:
					<img src="images/cuadritocellcity2.jpg" width="120" height="120">
				</div>
				<div style="position:relative;bottom:20%;padding-left:20em;">
					<button id="imp" TYPE="button" onClick="printArea('print');" >Imprimir
					<button type="regresa" id="cancelar">Cancelar
				</div>
</div>
		<!--FIN IMPRIMIR-->
		<p id="agregarespuesta"> </p>
		<div class="container" style="display:none;" id="manageusr">
				<h4>Manejar Usuarios:</h4>
				<form>
					<select onchange="optionCheck();" name="maneja" id="opsearch">
						<option selected="selected" disabled="disabled">--Selecciona Opcion--</option>
						<option value="agregaru">Agregar Usuario </option>
						<option value="mostraru">Muestra Usuarios</option>						
					</select>
				</form>
		</div>			
		<div class="container" id="agregau" style="display:none;">			
			<form name="uagrega" method="get" id="uagrega">
				<h4 align="center"> Agrega usuario Nuevo </h4>
				<strong><font color="red">**</font>Usuario:
				<div>
					<input type="text" name="u_usuario" id="u_usuario"> 
				</div><br />
				Nombre:
				<div>				
					<input type="text" name="u_nombre" id="u_nombre">
				</div><br />
				<font color="red">**</font>Contraseña:
 				<div>
 					<input type="password" name="u_pass" id="u_pass">
				</div><br />
				Tipo de usuario:
				<div>				
					<input type="radio" name="u_tipo" id="u_tipo" value="1">Administrador
					<input type="radio" name="u_tipo" id="u_tipo" value="2">Regular			
				</div><br />
				<br/>
			</strong>
				<button type="button"id="u_submit" class="btn btn-primary"> Nuevo usuario </button>	
				<a  href="/">
   				<button type="button">Regresar</button>
				</a>						
			</form>
			<p id="agregauser"></p>
		</div>
		<div id="mostrar"  style="display:none;" class="container">
			<div style="display:inline-block;">
				<form  method="get" id="bujca3">
					<button type="button" id="m_submit" style="position:relative; left:5.5%;">Mostrar usuarios</button><br><br />					
						<table style="display:inline-block;"  id="muestrabla"  class="table table-striped table-hover tablesorter" >	

						</table>					
				</form>

			</div>

		</div>

		<div class="container" id="agregac" style="display:none; " >				
			<form name="cagrega" method="get" id="cagrega">
				<h4 align="center"> Agrega Cliente Nuevo </h4>					
				<strong><font color="red">**</font>Nombre:
					<div>
						<input  maxlength="70" size="30" type="text" name="c_nombre" id="c_nombre" placeholder="Nombre de cliente" tabindex=1 style="text-transform:uppercase;">
					</div>

					Email:
					<div>							
						<input size="30"name="c_email" id="c_email" placeholder="Correo Electronico" tabindex=2 style="text-transform:uppercase;" >
					</div>
					Celular:
 					<div>
 						<input size="30" type="text" name="c_cel" id="c_cel" placeholder="Celular" tabindex=3 style="text-transform:uppercase;" >				
 					</div>
					<font color="red">**</font>Telefono contacto autorización:
					<div>						
						<input size="30" type="text" name="c_tel" id="c_tel" placeholder="Telefono de contacto" tabindex=4 style="text-transform:uppercase;" >
					</div><br />
					<br/>
				</strong>						
			</form>
			<button type="button"id="c_submit" class="btn btn-primary" tabindex=5> Guardar Cliente </button>	

			<a style="padding-left:20em;"  href="/">
   				<button type="button" tabindex=6 >Regresar</button>
			</a>		
			<p id="agregacliente"></p>
		</div>
<p id="editaste"> </p>
</div> 
<script src="js/jquery-1.10.2.min.js"></script>
<script src="js/jquery-ui-1.10.3.custom/js/jquery-ui-1.10.3.custom.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script type="text/javascript" charset="utf-8">

$("#s_submit_b").click(function(){
	$('#opsearch option:eq(0)').attr('selected','selected');
		$('#opsearch3 option:eq(0)').attr('selected','selected');
		$('#opsearch4 option:eq(0)').attr('selected','selected');
	    $('#agregac').hide();
  		$("#bujca").show();
		$("#agregaf").hide();
		$('#manageagre').hide();
		$("#respuestabla").show();
		$("#bujca2").show();
		$('#manageusr').hide();
		$("#agregau").hide();
		$("#mostrar").hide()
		$('#manageclien').hide();
			
		$('#m_todosclientes').hide();
});
$("#s_submit_a").click(function(){
		//alert('Antes de agregar un folio recuerda agregar cliente primero, si el cliente ya esta registrado ignora el msg y sigue adelante');
		$('#opsearch option:eq(0)').attr('selected','selected');
		$('#opsearch2 option:eq(0)').attr('selected','selected');
		$('#opsearch4 option:eq(0)').attr('selected','selected');
		$('#agregac').hide();
		$("#agregaf").show();
		$("#manageclien").hide();
		$('#s_submit').hide();
		//$("#agrega").show();
		$("#bujca").hide();
		$("#respuestabla").hide();
		$("#bujca2").hide();
		$('#manageusr').hide();
		$("#agregau").hide();
		$("#mostrar").hide()
		$('#manageclien').hide();		
		$('#m_todosclientes').hide();

});
$("#s_submit_c").click(function(){
	$('#opsearch2 option:eq(0)').attr('selected','selected');
	$('#opsearch3 option:eq(0)').attr('selected','selected');
	$('#opsearch option:eq(0)').attr('selected','selected');

		$('#s_submit').hide();
		$('#agregac').hide();
  		$("#manageclien").show();
  		$("#bujca").hide();
		$("#agregaf").hide();
		$('#manageagre').hide();
		$("#respuestabla").hide();
		$("#bujca2").hide();
		$('#manageusr').hide();
		$("#agregau").hide();
		$("#mostrar").hide()
});
$("#s_submit_mu").click(function(){
	$('#opsearch2 option:eq(0)').attr('selected','selected');
	$('#opsearch3 option:eq(0)').attr('selected','selected');
	$('#opsearch4 option:eq(0)').attr('selected','selected');
		$('#s_submit').hide();
		$('#manageusr').show();
		$("#manageclien").hide();
		$('#agregac').hide();		
		$("#bujca").hide();
		$("#agregaf").hide();
		$("#respuestabla").hide();
		$("#bujca2").hide();		
		$("#manageagre").hide();				
		$('#m_todosclientes').hide();
});

$(document).ready(function() {
	$(".datte").datepicker({dateFormat: "yy-mm-dd"});
});
</script>

<script type="text/javascript">



////////////////DIALOGO //////////////////
//$(document).ready(function() {
$(function() {
	$("#dialog").dialog({
		autoOpen: false,
		width: 600,
		height: 300
	});
	//$("#button").on("click", function() {
	//	$("#dialog").dialog("open");
	//});
	//$('#button').click(function(){
	//		$("#dialog").dialog("open");
	//});
});

////////////////////////IMPRIMIR/////////////////////////////////////////////
////ESTA FUNCION ES PARA MANDAR LOS VALORES QUE ESTAN EN EL DIV DE UPDATE PARA EL DIV DE PRINT /////////////
function 	updateoutput(){
			document.getElementById('detalles').innerHTML=document.getElementById('a_detalles').value;
			document.getElementById('imei').innerHTML=document.getElementById('a_imei').value;
			document.getElementById('equipo').innerHTML=document.getElementById('a_modelo').value;
			document.getElementById('cliente').innerHTML=document.getElementById('a_cliente').value;
			document.getElementById('contra').innerHTML=document.getElementById('a_password').value;					
			document.getElementById('fecha').innerHTML=document.getElementById('a_fecha').value; 
//// SEGUNDO 
			document.getElementById('detalles2').innerHTML=document.getElementById('a_detalles').value;
			document.getElementById('imei2').innerHTML=document.getElementById('a_imei').value;
			document.getElementById('equipo2').innerHTML=document.getElementById('a_modelo').value;
			document.getElementById('cliente2').innerHTML=document.getElementById('a_cliente').value;
			document.getElementById('contra2').innerHTML=document.getElementById('a_password').value;					
			document.getElementById('fecha2').innerHTML=document.getElementById('a_fecha').value; 			
}
////ESTA FUNCION ES PARA MANDAR A IMPRIMIR NADA MAS EL DIV QUE SE QUIERE ///////////
function printArea(areaName){
        var printContents = document.getElementById('print').innerHTML;
        var segundo = document.getElementById('segundo').innerHTML;
        //var separador = document.getElementById('separator').innerHTML;
        //var originalContents = document.body.innerHTML;
        document.body.innerHTML = printContents +  segundo  ;
        window.print();
        document.body.innerHTML= "";
        location.reload();        
}   
$('#imp').click(function(){
	$('#separator').show();
});
$('#printeando').click(function(){
		$('.print').show();
		var pcliente = $('#a_cliente').val();
		$.ajax({
			type:"GET",
			url:"ins.php?pclient=1&a_cliente="+pcliente,
			dataType:"html",
			success:function(response){
				$("#pfolio1").html(response); 
				$("#pfolio2").html(response); 
			},
		});						
});
$('#cancelar').click(function(){
						$('.print').hide();
						$('#a_modelo').removeAttr("disabled");
						$('#a_imei').removeAttr("disabled");
						$('#a_cliente').removeAttr("disabled");
						$('#a_detalles').removeAttr("disabled");
						$('#a_password').removeAttr("disabled");
						$('#a_conta').removeAttr("disabled");
						$('#a_fecha').removeAttr("disabled");
						$('#a_email').removeAttr("disabled");
						$('input:radio[name=a_status]:checked').removeAttr("disabled","disabled");
});
$(function() {
    $( ".print" ).draggable();
});
////////////////////////////////////////////////////////////////////////////
/*
////////ESTO es para hacer tipo responsive  ////
if (screen.width > 800) {
 document.getElementById(
"agregac").style.marginLeft=Math.round((screen.width - 900) / 2);
}
*/
$(function() {
    $( "#agregaf" ).draggable();
  });
$(function() {
    $( "#agregac" ).draggable();
  });
$(function() {
    $( "#agregau" ).draggable();
  });

$(function(){
		$('.s_cliente_auto').autocomplete({
			source: 'ins.php?clienteauto=2',
			minLength: 2
		
		});
		$('.s_imei_auto').autocomplete({

			source: 'ins.php?imeiauto=1',
			minLength: 5
		
		})
	});

///Buscar
 $("#s_submit").click(function() {

 				
 				var simei 		=  $('#s_imei').val();
 				var smodelo 	=  $('#s_modelo').val(); 				
 				var sstatus 	=  $('#s_status option:selected').val();
 	            var sfolio 		=  $('#s_folio').val();
 	            var scliente 	=  $('#s_cliente').val();
 	            var sfecha 		=  $('#s_fecha').val();
 	            

    $.ajax({    
      type: "GET",
      url: "ins.php?s_submit=1&s_folio="+sfolio+"&s_imei="+simei+"&s_cliente="+scliente+"&s_modelo="+smodelo+"&s_status="+sstatus+"&s_fecha="+sfecha,
      dataType: "html",   
      //expect html to be returned                
      success: function(response){                    
          $("#respuestabla").html(response);           
      },
      
    });
    
});
 ///Agrega Folio
$("#a_submit").click(function(){
	
	var aimei 		= $('#a_imei').val();
	var amodelo 	= $('#a_modelo').val();
	var acliente 	= $('#a_cliente').val();
	var adetalles 	= $('#a_detalles').val();
	var apass 		= $('#a_password').val();
	var astatus     = $('input:radio[name=a_status]:checked').val();	
	var aconta 		= $('#a_conta').val();
	var afecha 		= $('#a_fecha').val();
	var aemail 		= $('#a_email').val();
	//$('#printeando').show();
	var repara  = [];
	   $(':checkbox:checked').each(function(i){
	   		repara[i] = $(this).val();
	   });
	if (!acliente){
		alert('Tienes que proporcionar nombre de cliente');	
		var nohay = 1;
	} else {
		$.ajax({
			type: "GET",
			url: "ins.php?s_sumito=1&a_imei="+aimei+"&a_cliente="+acliente+"&a_modelo="+amodelo+"&a_status="+astatus+"&a_conta="+aconta+"&a_fecha="+afecha+"&a_email="+aemail+"&a_rep="+repara+"&a_password="+apass+"&a_detalles="+adetalles,
			dataType: "html",
			success: function(response){
				$('#agregarespuesta').html(response);				
					if(acliente){
					//window.location.href="/mainpage.php";		
					//window.location.href = "/";
						$('#a_modelo').attr("disabled","disabled");
						$('#a_imei').attr("disabled","disabled");
						$('#a_cliente').attr("disabled","disabled");
						$('#a_detalles').attr("disabled","disabled");
						$('#a_password').attr("disabled","disabled");
						$('#a_conta').attr("disabled","disabled");
						$('#a_fecha').attr("disabled","disabled");
						$('#a_email').attr("disabled","disabled");
						$('input:radio[name=a_status]:checked').attr("disabled","disabled");						
						$('#printeando').removeAttr("disabled");
						$('#a_submit').attr("disabled","disabled");

				}else {
					window.location.href="#";
					
				}
			}
		});
	}		
});
$('#limpia').click(function(){
						$('#a_imei').val('');
						$('#a_modelo').val('');
						$('#a_cliente').val('');
						$('#a_detalles').val('');
						$('#a_password').val('');
						//$('input:radio[name=a_status]:checked').val('');	
						$('#a_status').val();
						$('#a_conta').val('');						
						$('#a_email').val('');						
						$('#printeando').attr("disabled","disabled");
						$('#a_submit').removeAttr("disabled");
						$('#a_modelo').removeAttr("disabled");
						$('#a_imei').removeAttr("disabled");
						$('#a_cliente').removeAttr("disabled");
						$('#a_detalles').removeAttr("disabled");
						$('#a_password').removeAttr("disabled");
						$('#a_conta').removeAttr("disabled");
						$('#a_fecha').removeAttr("disabled");
						$('#a_email').removeAttr("disabled");
						$('input:radio[name=a_status]:checked').removeAttr("disabled");

});
///Agrega Usuarios 
$('#u_submit').click(function(){
	var uusuario = $('#u_usuario').val();
	var unombre  = $('#u_nombre').val();
	var upass 	 = $('#u_pass').val();	
	var utipo 	 = $('input:radio[name=u_tipo]:checked').val();
	if(!uusuario || !upass ){
		alert('Para dar de alta a un usuario tiene que tener usuario y password');
	}else{
		$.ajax({
			type: "GET",
			url: "ins.php?agregau=1&u_usuario="+uusuario+"&u_nombre="+unombre+"&u_pass="+upass+"&u_tipo="+utipo,
			dataType: "html",
			success: function(resp){
				 $('#agregauser').html(resp);
			 	
			 	window.location.href="/mainpage.php";
			}
		});
	}
});
///Agrega Cliente
$('#c_submit').click(function(){
	var cnombre = $('#c_nombre').val();
	var cemail 	= $('#c_email').val();
	var ccel 	= $('#c_cel').val();
	var ctel 	= $('#c_tel').val();
	if (!cnombre || !ctel){
		alert('Para seguir tienes que proporcionar nombre de cliente y/o numero de contacto');		
	} else {
		$.ajax({
			type: "GET",
			url: "ins.php?agregac=1&c_nombre="+cnombre+"&c_email="+cemail+"&c_cel="+ccel+"&c_tel="+ctel,
			dataType:"html",
			success: function(resp){
				$('#agregacliente').append(resp);
				
			 	window.location.href="/mainpage.php";
			}
			
		});
	}
});
$('#m_submit').click(function(){
	$.ajax({
		type:"GET",
		url: "ins.php?musuarios=1",
		dataType:"html",
		success: function(resp){
			$('#muestrabla').html(resp);			
		}
	});
});
$('#clientes_submit').click(function(){
	$.ajax({
		type:"GET",
		url: "ins.php?mclientes=1",
		dataType:"html",
		success: function(resp){
			$('#muestrablaclientes').html(resp);
		}
	});
});
</script>
</body>
</html>
