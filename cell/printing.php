<html>
<head>
<link rel="stylesheet" href="style.css">
</head>
<body>

	<?php  
  		$p_modelo    = $_GET['p_modelo'];
  		$p_imei      = $_GET['p_imei'];
  		$p_cliente   = $_GET['p_cliente'];     
  		$p_fecha     = $_GET['p_fecha'];  
  		$p_detalles  = $_GET['p_detalles'];
	?>
	

			<div  >				
			<FORM id="pprint">				
				<table id="printt" style="width:50em;height:5em;">
					<tr>
						<td class="uno">Cliente</td>
						<?php echo "<td class='dos'> $p_cliente </td>";?>
					</tr>
						<td class="uno">Equipo</td>
						<td class="dos" > </td>
					</tr>
						<td class="uno">Imei</td>
						<td class="dos"></td>
					</tr>
				</table>
			<br />
				<table id="printt">
					<thead >
							<tr>
								<th>Detalles Servicio Tecnico</th>
							</tr>
					</thead>
					<tbody>
						<tr>
							<td class="dos">yayayysaksdhaskjdhaskjdhaskjd
								asdajsldkaskdhaksjdhas
								daslkdhaskdjahsdkjaaslkdhaskjdahsjdahsdasjdkas
								dalskdjaslkdjaksjdhasd
								asdlkajskdkaskdjasd
								asdkajsdklahskdjahskdjha</td>							
						</tr>
					</tbody>								
				</table>
				<INPUT TYPE="button" onClick="window.print()" id="imprimir">
			</form>
		</div>
		<script src="js/jquery-1.10.2.min.js"></script>
		<script type="text/javascript">
				$('#inprimir').click(function(){

				});
		</script>
</body>
</html>