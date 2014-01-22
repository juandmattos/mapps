<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="com.mapps.model.Role" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta charset="utf-8">
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <script type='text/javascript' src="../scripts/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdata.js"></script>
	<link rel="stylesheet" href="../jqwidgets/styles/jqx.base.css" type="text/css" />
    <link rel="stylesheet" href="../jqwidgets/styles/jqx.metro.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../css/main_style.css"> 
    
</head>
<%
String token = String.valueOf(session.getAttribute("token"));
if (token.equals("null") || token.equals("")){
	response.sendRedirect("../index_login.jsp");	
}
Role role;
if ( session.getAttribute("role") == null){
	role = null;	
}else{
	role = (Role) session.getAttribute("role");	
}
%>
<body>

<script type="text/javascript">
	$(document).ready(function () {
		
		$("#start_training").jqxButton({ width: '300', height: '50', theme: 'metro'});
		$("#jqxMenu").jqxMenu({ width: '70%', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
	
		$("#start_training").on('click', function () {
			var selected = $('#trainings').jqxListBox('getSelectedItem');
			var uid = selected.value;
			window.location.replace("start_training.jsp?uid="+uid);
		});
		var source =
        {
            datatype: "json",
            url: "/mapps/getTrainingsToStart"
        };
        var dataAdapter = new $.jqx.dataAdapter(source);
        $('#trainings').jqxListBox({ source: dataAdapter, displayMember: "date", valueMember: "name", itemHeight: 70, height: '250', width: '60%',autoHeight:true, theme: 'metro',
        	renderer: function (index, label, value) {
                var datarecord = dataAdapter.records[index];
                if (dataAdapter.records.length == 0){
                	//PONER UN DIV: NO HAY ENTRENAMIENTOS PROGRAMADOS
                }
                var split = datarecord.date.split(" ");
                var table = '<table style="min-width: 130px;"><td><center> Entrenamiento programado para el dia: ' + split[0] +'</center></td><td><center> Hora: ' + split[1] +'</center></td></table>';
                return table;
            }	
        }); 
	});
</script>


<div id="header">
	<div id="header_izq" style="display:inline-block; width:25%; height:100%; float:left;">
    	<a href="index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central"  style="display:inline-block; width:50%; height:100%; float:left;">
		
    </div>
    <div id="header_der" style="display:inline-block; width:25%; height:100%; float:left;">
        <div id="logout" class="up_tab">MI CUENTA</div>
		<div id="logout" class="up_tab"><a href="/mapps/logout" >CERRAR SESI&Oacute;N</a></div>
    </div>
</div>
<div id="contenedor">

<div id="tabs">
	  	<div id="tab_1" class="tab" onclick="location.href='../index.jsp'" style="margin-left:12%;">INICIO</div>
        <div id="tab_2" class="tab" onclick="location.href='../athletes/athletes.jsp'">JUGADORES</div>
        <div id="tab_3" class="tab active" onclick="location.href='./trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='../myclub/myclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab" onclick="location.href='../configuration/configuration_main.jsp'">CONFIGURACI&Oacute;N</div>
  </div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">
        
        </div>
        <div id="main_div">
        	<div id="title" style="margin:15px;">
           		<label> Seleccione el entrenamiento que desee comenzar </label>
            </div>
        	<div id="trainings" style="margin-left:20%;">
            
            </div>
			<div id="start_training_div">
            	<input type="button" id="start_training" name="start_training" value="INICIAR ENTRENAMIENTO" style="margin-left:200px;" />
            </div>
        </div>
        <div id="sidebar_right">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <li style="height:35px;"><a href="#"> Ver entrenamientos anteriores </a></li>
             	   <li style="height:35px;"><a href="./create_training.jsp"> Programar un entrenamiento </a></li>
             	   <li style="height:35px;"><a href="./edit_training.jsp"> Editar un entrenamiento </a></li>
             	   <li style="height:35px;"><a href="./change_permissions_training.jsp"> Editar Permisos </a></li>
             	   <li style="height:35px;"><a href="#">  </a></li>
        		</ul>
  			</div>
        </div>
    </div>
 
</div>
<div id="pie">

</div>
</body>
</html>
