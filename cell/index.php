<?php 
session_start(); 
include_once "connection.php"; 
mysql_select_db("cellcity",$con2);
  
function verificar_login($user,$password,&$result) { 

    $sql = "SELECT * FROM usuarios WHERE usuario = '$user' and passwd = '$password'"; 
    $rec = mysql_query($sql) or die ("Query failed: ".mysql_error()."Actual query:".$sql); 
    $count = 0; 
  
    while($row = mysql_fetch_object($rec)){ 
        $count++; 
        $result = $row; 
    } 
  
    if($count == 1){ 
        return 1; 
    }else { 
        return 0; 
    } 
} 
  
if(!isset($_SESSION['tipouser'])) 
{ 
    if(isset($_POST['login'])) 
    { 
        if(verificar_login($_POST['user'],$_POST['password'],$result) == 1) 
        { 
          
            
            $_SESSION['tipouser'] = $result->tipo;
            $_SESSION['uname'] = $result ->usuario;
             // echo "<script type='text/javascript'>alert('$_SESSION[tipouser]')</script>";

                header("location:mainpage.php"); 

        } 
        else 
        { 
            echo '<div class="error">Su usuario es incorrecto, intente nuevamente.</div>'; 
        } 
    } 
?> 
  
<style type="text/css"> 
*{ 
    font-size: 14px; 
} 
body{ 
background:#aaa; 
} 
div.login{
    position: absolute;
    top: 200px;
    left:40%;
}
form.login { 

    background: none repeat scroll 0 0 #F1F1F1; 
    border: 1px solid #DDDDDD; 
    font-family: sans-serif; 
    margin: 0 auto; 
    padding: 20px; 
    width: 278px; 
    box-shadow:0px 0px 20px black; 
    border-radius:10px; 
} 
form.login div { 
    margin-bottom: 15px; 
    overflow: hidden; 
} 
form.login div label { 
    display: block; 
    float: left; 
    line-height: 25px; 
} 
form.login div input[type="text"], form.login div input[type="password"] { 
    border: 1px solid #DCDCDC; 
    float: right; 
    padding: 4px; 
} 
form.login div input[type="submit"] { 
    background: none repeat scroll 0 0 #DEDEDE; 
    border: 1px solid #C6C6C6; 
    float: right; 
    font-weight: bold; 
    padding: 4px 20px; 
} 
.error{ 
    color: red; 
    font-weight: bold; 
    margin: 10px; 
    text-align: center; 
} 
</style> 
<div class="login" >
<form action="" method="post" class="login"> 
    <div><label>Usuario</label><input name="user" type="text" id="luser" ></div> 
    <div><label>Contraseña</label><input name="password" type="password" id="lpass"></div> 
    <div><input target="_self" name="login" id="l_submit" type="submit" value="login"></div> 
</form> 
</div>


<?php 
} else { 
    echo "<script type=text/javascript>alert('Ya existe una sesion de este usuario.')</script>";
    	header("location:mainpage.php");
    //echo '<a href="logout.php">Logout</a>'; 
}
?>

<script src="js/jquery-1.10.2.min.js"></script>
<script type="text/javascript"> 
    $('#l_submit').click(function(){
            var tipo = $_SESSION['tipouser'];
            $.ajax({
                type:"GET",
                url:"mainpage.php?tipo="+tipo,
                dataType: "html",
                success: function(response){
                    //$('#agregarespuesta').html(response);                
                    window.location.href="/mainpage.php";
                }
            });

    });
</script>
