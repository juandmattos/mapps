<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="com.mapps.model.Role" %>
<%@ page import="com.mapps.model.Gender" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta charset="utf-8">
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <script type='text/javascript' src="//ajax.googleapis.com/ajax/libs/jquery/1.8.3/jquery.min.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcore.js"></script>
	<script type="text/javascript" src="../jqwidgets/jqxdata.js"></script>
    <script type="text/javascript" src="../scripts/demos.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdatetimeinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcalendar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxtooltip.js"></script>
    <script type="text/javascript" src="../jqwidgets/globalization/globalize.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxpasswordinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdropdownlist.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcheckbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmaskedinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxtooltip.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxvalidator.js"></script>
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
	
			
		// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '200', mode: 'vertical', theme: 'metro'});
        $("#jqxMenu").css('visibility', 'visible');
		
		$("#delete").jqxButton({ width: '150', theme: 'metro'});
		
		$("#delete").click(function () {
            var array = $("#dataTable").jqxDataTable('getSelection');
            var json = JSON.stringify(array);
            $.ajax({
                url: "/mapps/...",
                type: "POST",
                data: {json: json},
                success: function (response){
                	window.location.replace("delete_institution.jsp");
                },
                error: function(jqXHR, textStatus, errorThrown) {
                	  console.log(textStatus, errorThrown);
                } 
            });
        });
		
		var url = "/mapps/getAllUsers";
        $.ajax({
            url: url,
            type: "GET",
            success: function (response){
            	fill_table(response);
        }});
	
	});
	
	function fill_table(response){
		var athletes = response['users'];
		var source =
        {
            localData: institutions,
            dataType: "array",
            dataFields:
            [
                { name: 'name', type: 'string' },
                { name: 'lastName', type: 'string' },
				{ name: 'username', type: 'string' },
				{ name: 'ci', type: 'string' },
            ]
        };
		var dataAdapter = new $.jqx.dataAdapter(source);
		$("#dataTable").jqxDataTable(
	            {	
	            	theme: 'metro',
	            	altrows: true,
	                sortable: true,
	                exportSettings: { fileName: null },
	                source: dataAdapter,
	                columnsResize: true,
	                columns: [
	                    { text: 'Nombre', dataField: 'name', width: 200 },
	                    { text: 'Apellido', dataField: 'lastName', width: 200 },
						{ text: 'Usuario', dataField: 'username', width: 200 },
						{ text: 'Documento', dataField: 'ci', width: 200 },
	                ]
	            }
		);
	}
</script>

<div id="header">
	<div id="header_izq">
    	<img src="../images/logo_mapps.png" style="height:80px; margin-top:15px; margin-left:20px;" />
    </div>
    <div id="header_central">
	
	</div>
    <div id="header_der">
	
    </div>
</div>
<div id="contenedor">

	<div id="tabs">
	  	<div id="tab_1" class="tab" onclick="location.href='../index.jsp'" style="margin-left:180px;">INICIO</div>
        <div id="tab_2" class="tab" onclick="location.href='../athletes/athletes.jsp'">JUGADORES</div>
        <div id="tab_3" class="tab" onclick="location.href='../training/trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='../myclub/myclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab active" onclick="location.href='./configuration.jsp" style="margin-right:180px;">CONFIGURACI&Oacute;N</div>
  	</div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">

        </div>	   
        <div id="main_div">
        	<div id="navigation" class="navigation">
            	<a href="./athletes.jsp">CONFIGURACI&Oacute;N</a> >> Eliminar Usuarios
            </div>
            <div id="title" style="margin:15px;">
                <label> Seleccione uno o varios usuarios </label>
            </div>
        	<div id="dataTable" style="margin-top:25px; margin-left:50px;">
            
            </div>
        	<div style="margin-top:25px; margin-left:250px;">
             	<input type="button" value="Eliminar" id='delete' />
            </div>
        </div>
        <div id="sidebar_right">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <li style="height:35px;"><a href="./register_user.jsp"> Agregar un Usuario </a></li>
             	   <li style="height:35px;"><a href="./edit_user.jsp"> Editar un Usuario </a></li>
                   <li style="height:35px;"><a href="./delete_user.jsp"> Eliminar un Usuario </a></li>
             	   <li style="height:35px;"><a href="./add_sport.jsp"> Agregar un Deporte </a></li>
                   <li style="height:35px;"><a href="./add_institution.jsp"> Agregar una Instituci&oacute;n </a></li>
                   <li style="height:35px;"><a href="./edit_institution.jsp"> Editar una Instituci&oacute;n </a></li>
                   <li style="height:35px;"><a href="#"> Eliminar una Instituci&oacute;n </a></li>
                   <li style="height:35px;"><a href="./add_device.jsp"> Agregar un Dispositivo </a></li>
        		</ul>
  			</div>
        </div>
    </div>
 
    
</div>
<div id="pie">

</div>
</body>
</html>