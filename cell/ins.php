<?php
//check connection

include("connection.php");
$amodelo  = $_GET['a_modelo'];
$aimei    = $_GET['a_imei'];
$acliente = $_GET['a_cliente'];   
$aemail   = $_GET['a_email'];
$astatus  = $_GET['a_status'];
$afecha   = $_GET['a_fecha'];
$adir     = $_GET['a_direccion'];
$adetalles = $_GET['a_detalles'];
$apass    = $_GET['a_password'];
$ataller  = $_GET['a_taller'];
$aconta   = $_GET['a_conta'];
$arep     = $_GET['a_rep'];
$sfolio   = $_GET['s_folio'];
$simei   = $_GET['s_imei'];
$smodelo   = $_GET['s_modelo'];
$scliente  = mysql_real_escape_string($_GET['s_cliente']);
$sstatus   = $_GET['s_status'];
$sfecha    = $_GET['s_fecha'];

//////////tabla para mostrar todas las columas de la tabla dispos//////////

$tr = "
<table>
     <tr>
        <td align=center ><b>Editar</b></td>
        <td align=center><b>Folio</b></td>
        <td align=center><b>Modelo</b></td>
        <td align=center><b>Imei</b></td>
        <td align=center><b>Cliente</b></td>
        <td align=center><b>Status</b></td>
        <td align=center><b>Reparacion</b></td>
        <td align=center><b>Password</b></td>
        <td align=center><b>Detalles</b></td>        
        <td align=center><b>Fecha</b></td>
        <td align=center><b>Email</b></td>
        <td align=center><b>Telefono Contacto</b></td>";
///////////tabla para mostrar columbas de la tabla usuarios/////////////////
$tr2 = "
<table>
     <tr>
        <td align=center><b>Editar</b></td>
        <td align=center><b>Id</b></td>
        <td align=center><b>Usuario</b></td>
        <td align=center><b>Nombre</b></td>
        <td align=center><b>Tipo de Usuario</b></td>";
/////////tabla para mostrar columas de la tabla clientes ////////////////////
$tr3 = "
<table>
     <tr>
        <td align=center><b>Editar</b></td>
        <td align=center><b>Id</b></td>
        <td align=center><b>Nombre</b></td>
        <td align=center><b>Email</b></td>
        <td align=center><b>Celular</b></td>
        <td align=center><b>Telefono Contacto</b></td>";

//Abrimos Conexion a la base de datos usando la conexion 2 
mysql_select_db("cellcity",$con2);

 if(!empty($_GET['s_submit'])){
////Filtro para buscar todos los registros de la tabla dispos 
    if(!empty($_GET['s_submit']) && empty($sfolio) && empty($simei) && empty($smodelo) && empty($scliente) && empty($sfecha)){
      
      $resulta= mysql_query("SELECT dispos.*, cliente.email,cliente.telefono,cliente.nombre from dispos LEFT JOIN cliente ON  cliente.nombre = dispos.cliente order by dispos.folio desc" ,$con2);     
      echo $tr;
    }  
////Filtro para buscar registro segun el folio
    if($sfolio){
      
      $resulta= mysql_query("SELECT dispos.*,cliente.email,cliente.telefono,cliente.nombre from dispos LEFT JOIN cliente ON  cliente.nombre = dispos.cliente where dispos.folio = '$sfolio'",$con2);
      echo $tr;
    }
////Filtro para buscar registro segun imei 
    if($simei){
      
      $resulta= mysql_query("SELECT dispos.*,cliente.email,cliente.telefono,cliente.nombre from dispos LEFT JOIN cliente ON  cliente.nombre = dispos.cliente where dispos.imei = '$simei'",$con2);
      echo $tr;         
    }
////Filtro para buscar registro segun equipo/modelo
    if($smodelo){
      
      $resulta= mysql_query("SELECT dispos.*,cliente.email,cliente.telefono,cliente.nombre from dispos LEFT JOIN cliente ON  cliente.nombre = dispos.cliente where dispos.modelo LIKE '$smodelo%'",$con2);
      echo $tr;
    }   
////Filtro para buscar registro segun cliente y status
    if($scliente){    
        if (!empty($sstatus)){      
                  $resulta= mysql_query("SELECT dispos.*,cliente.email,cliente.telefono,cliente.nombre from dispos   LEFT JOIN cliente ON  cliente.nombre = dispos.cliente where dispos.cliente LIKE '$scliente%' AND dispos.status = '$sstatus'",$con2);
        }else{                  
                  
                  $resulta= mysql_query("SELECT dispos.*,cliente.email,cliente.telefono,cliente.nombre from dispos  LEFT JOIN cliente ON  cliente.nombre = dispos.cliente where dispos.cliente LIKE '$scliente%'",$con2);
        }        
        echo $tr;          
    }    
     if($sfecha){        
        $resulta=mysql_query("SELECT dispos.*, cliente.email,cliente.telefono,cliente.nombre from dispos LEFT JOIN cliente  ON  cliente.nombre = dispos.cliente where dispos.fecha = '$sfecha'",$con2);
        echo $tr;
    }      
////loop para mostrar los registros mientras haya resultados en la busqueda
    while($data = mysql_fetch_row($resulta)){           
      //echo '<pre>';
      //print_r($data);
        echo "<tr>";                
            echo "<td align=center><a href=update.php?folio=".$data[0]."&editcliente=".urlencode($data[3]).">Editar</a></td> ";                  
            //echo "<td align=center><input id='button' type='button' value='Editar' class='btn btn-info btn-sm' onclick=abre();></td>";     
            echo "<td  align=center name=editfolio id=editfolio>$data[0]</td>";
            echo "<td  align=center id=editmodelo >$data[1]</td>";
            echo "<td  align=center id=editimei >$data[2]</td>";
            echo "<td  align=center id=editcliente >".urldecode($data[13])."</td>";
            echo "<td  align=center id=editstatus >$data[4]</td>";
            echo "<td  align=center id=editrepara >$data[5]</td>";
            echo "<td  align=center id=editpassword>$data[7]</td>";
            echo "<td  align=center id=editdetalles>$data[6]</td>";            
            echo "<td  align=center id=editfecha >$data[8]</td>";          
            echo "<td  align=center id=editmail >$data[11]</td>";
            echo "<td  align=center id=editcontacto >$data[12]</td>";            
            echo "</tr>";
    }
  ///Cerrando Connection a la base de datos usando con2       
    mysql_close($con2);
 }
/// AGREGA NUEVO FOLIO PERO CHECA SI EL CLIENTE YA ESTA REGISTRADO.
if(!empty($_GET['s_sumito'])){     
         $q = mysql_query("SELECT  nombre  from cliente  where nombre = '$acliente' ",$con2);
         $ress = mysql_fetch_row($q);         
          if (!$ress) {
               echo "<script type=text/javascript>alert('Cliente $acliente no existe favor de registrar cliente y luego agregar folio')</script>";
             exit(1);
          }else{
              if ($acliente){ 
                    $query = "INSERT INTO dispos ( modelo, imei, cliente, email, status, detalles, reparacion, fecha, contacto,password )
                    VALUES ('$amodelo','$aimei','$acliente','$aemail','$astatus','$adetalles','$arep', '$afecha','$aconta', '$apass')";
                    $result = mysqli_query($con,$query);
                    if (!$result){
                        die('Couldn\'t query' . mysqli_error($con));
                    }      
            ?>
                    <script type="text/javascript">
                        alert('<?php echo  $amodelo?> fue agregado para <?php echo $acliente?>, NO Olvides Imprimir comprobante de recibo.')
                    </script>  
	     <?php
            } 
      }
}
/////Editar folio 
if(!empty($_GET['eeditas'])){

  $e_modelo    = $_GET['editmodelo'];
  $e_imei      = $_GET['editimei'];
  $e_cliente   = $_GET['editcliente'];   
  $e_email     = $_GET['editemail'];
  $e_status    = $_GET['editstatus'];
  $e_fecha     = $_GET['editfecha'];
  $e_pass      = $_GET['editpassword'];
  $e_detalles  = $_GET['editdetalles'];
  $e_contacto  = $_GET['editcontacto'];
  $e_folio     = $_GET['editfolio'];
  $e_repara    = $_GET['editrepara'];
  if (!$e_repara){
                $query = "UPDATE dispos SET modelo = '$e_modelo', imei = '$e_imei', cliente = '$e_cliente', status = '$e_status', fecha = '$e_fecha', email = '$e_email', detalles = '$e_detalles', password = '$e_pass', contacto = '$e_contacto' WHERE folio = '$e_folio'";
  }else{
        $query = "UPDATE dispos SET modelo = '$e_modelo', imei = '$e_imei', cliente = '$e_cliente', status = '$e_status', fecha = '$e_fecha', email = '$e_email', detalles = '$e_detalles', password = '$e_pass', contacto = '$e_contacto',  reparacion = '$e_repara' WHERE folio = '$e_folio'";
  }
      $result = mysqli_query($con,$query);
      if (!$result){
            die('Coudnt query'. mysqli_error($con));
          } 

}
///AGREGA USUARIO NUEVO
if(!empty($_GET['agregau'])){
   $uusuario   = $_GET['u_usuario'];
   $upsswd    = $_GET['u_pass'];
   $unombre    = $_GET['u_nombre'];
   $utipo      = $_GET['u_tipo'];

   $query = "INSERT INTO usuarios ( usuario, passwd, nombre, tipo) VALUES ('$uusuario','$upsswd','$unombre','$utipo')";
   $q = mysql_query("SELECT  usuario  from usuarios  where usuario = '$uusuario' ",$con2);
   $ress = mysql_fetch_row($q);         
   if ($ress) {
               echo "<script type=text/javascript>alert('Usuario $uusuario ya existe , si quieres modificarlo ve a manejar usuarios luego mostrar todos y selecciona editar')</script>";
             die();
    }else{
          $result = mysqli_query($con,$query);
          if(!$result){
            die('Could query'. mysqli_error($con));
          }
          echo "<script type=text/javascript>alert('Usuario $uusuario ha sido agregado con exito ')</script>";
    }
}
///MUESTRA USUARIO NUEVO
if (!empty($_GET['musuarios'])){  
    $result=mysql_query("select idu,usuario,nombre,tipo from usuarios",$con2);
    echo $tr2;
    while($dato = mysql_fetch_row($result)){
          echo "<tr>";
          echo "<td align=center><a href=updateusers.php?idu=".$dato[0].">Editar</a></td> "; 
            echo "<td id=editidu align=center>$dato[0]</td>";
            echo "<td id=editusuario align=center>$dato[1]</td>";
            echo "<td id=editnombre align=center>$dato[2]</td>";
            echo "<td id=editipo align=center>$dato[3]</td>";
          echo "</tr>";
    } 
}
///MODIFICA USUARIO NUEVO
if(!empty($_GET['musuario'])){
    $eusuario    = $_GET['editusuario'];
    $enombre      = $_GET['editnombre'];
    $epasswd   = $_GET['editpassword'];   
    $etipo     = $_GET['edittipo'];
    $eidu      = $_GET['editidu'];

    $query = "UPDATE usuarios SET usuario = '$eusuario', nombre = '$enombre', tipo = '$etipo', passwd = '$epasswd' WHERE idu = '$eidu'";

      $result = mysqli_query($con,$query);
      if (!$result){
            die('Coudnt query'. mysqli_error($con));
          } 
}
///MUESTRA TODOS LOS CLIENTES
if (!empty($_GET['mclientes'])){  
    $result=mysql_query("select * from cliente",$con2);
    echo $tr3;
    while($dato = mysql_fetch_row($result)){
          echo "<tr>";
          echo "<td align=center ><a href=updateclientes.php?id=".$dato[0].">Editar</a></td> "; 
            echo "<td align=center id=editid >$dato[0]</td>";
            echo "<td align=center id=editnombre >$dato[1]</td>";
            echo "<td align=center id=editemail >$dato[2]</td>";
            echo "<td align=center id=editcelular >$dato[3]</td>";
            echo "<td align=center id=edittelefono >$dato[4]</td>";
          echo "</tr>";
    } 

}
///MODIFICA CLIENTES
if(!empty($_GET['mcliente'])){
    $cnombre    = $_GET['editnombre'];
    $cemail     = $_GET['editemail'];
    $ccel       = $_GET['editcel'];   
    $ctel       = $_GET['edittel'];
    $cid        = $_GET['editid'];

    $query2 = "UPDATE dispos SET  cliente = '$cnombre'  WHERE cliente = '$cnombre'";
    $result2 = mysqli_query($con,$query2);

    $query = "UPDATE cliente  SET nombre = '$cnombre', email = '$cemail', celular = '$ccel', telefono = '$ctel'  WHERE id = '$cid'";
    $result = mysqli_query($con,$query);
    if (!$result){
           die('Coudnt query'. mysqli_error($con));
    } 
}
///AGREGA CLIENTE
if(!empty($_GET['agregac'])){
    $cnombre    = $_GET['c_nombre'];
    $cemail     = $_GET['c_email'];
    $ccel       = $_GET['c_cel'];
    $ctel       = $_GET['c_tel'];
    $q = mysql_query("SELECT  nombre  from cliente  where nombre = '$cnombre' ",$con2);
    $ress = mysql_fetch_row($q); 
   if ($ress) {
           echo "<script type=text/javascript>alert('Cliente $ress[0] ya existe,favor de ingresar con otro nombre ')</script>";
           //exit(1);
    } else {      
    $query = "INSERT INTO cliente (nombre, email, celular, telefono) VALUES ('$cnombre','$cemail','$ccel','$ctel')";
      $result = mysqli_query($con,$query);
    if(!$result){
        die('Couldnt query'. mysqli_error($con));

    }
      echo "<script type=text/javascript>alert('Cliente $cnombre ha sido agregado con exito ')</script>";
  }

}
///AUTOCOMPLETAR CLIENTE
if(!empty($_GET['clienteauto'])) {
    $cliente = $_GET['term'];

    $query = "SELECT  nombre FROM cliente WHERE nombre LIKE '%$cliente%'";
    $result = mysql_query($query, $con2);
    $clientes = array();
   
    while($dat = mysql_fetch_array($result)){
        $clientes[] = array(        
           'label' => $dat["nombre"],
          );
        
    }
    echo json_encode($clientes);
}
//AUTOCOMPLETAR IMEI 

if(!empty($_GET['imeiauto'])) {
    $imeii = $_GET['term'];

    $query = "SELECT  imei FROM dispos WHERE imei LIKE '$imeii%'";
    $result = mysql_query($query, $con2);
    $imeis = array();
   
    while($dat = mysql_fetch_array($result)){
        $imeis[] = array(        
           'label' => $dat["imei"],
          );
        
    }
    echo json_encode($imeis);
}

if(!empty($_GET['pclient'])){

    $pcliente = $_GET['a_cliente'];

    $sql2 = "SELECT folio from dispos where cliente = '$pcliente ' order by folio desc limit 1"; 
    $rec2 = mysql_query($sql2,$con2) or die ("Query failed: ".mysql_error()."Actual query:".$query); 
    $rows2 = mysql_fetch_row($rec2);
     echo "$rows2[0]";

}
mysqli_close($con);

?> 
