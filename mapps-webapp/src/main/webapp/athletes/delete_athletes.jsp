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
    <script type="text/javascript" src="../jqwidgets/jqxdata.js"></script> 
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdatatable.js"></script> 
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdata.export.js"></script>
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
String info = String.valueOf(request.getParameter("info"));
if (info.equals("null"))
	info = "";
String error = String.valueOf(request.getParameter("error"));
if (error.equals("null"))
	error = "";

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
                url: "/mapps/deleteAthlete",
                type: "POST",
                data: {json: json},
                success: function (response){
                	window.location.replace("delete_athletes.jsp");
                },
                error: function(jqXHR, textStatus, errorThrown) {
                	  console.log(textStatus, errorThrown);
                		} 
            });
        });
		
        var url = "/mapps/getAllAthletesOfInstitution";
        $.ajax({
            url: url,
            type: "GET",
            success: function (response){
            	fill_table(response);
            }});
   	});
	
	function fill_table(response){
		var athletes = response['athletes'];
		var source =
        {
            localData: athletes,
            dataType: "array",
            dataFields:
            [
                { name: 'name', type: 'string' },
                { name: 'lastName', type: 'string' },
                { name: 'idDocument', type: 'string' },
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
	                    { text: 'Apellido', dataField: 'lastName', width: 170 },
	                    { text: 'C.I.', dataField: 'idDocument', width: 170 }
	                ]
	            });
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
        <div id="tab_2" class="tab active" onclick="window.location.reload()">JUGADORES</div>
        <div id="tab_3" class="tab" onclick="location.href='../training/trainings.jsp'">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab" onclick="location.href='../myclub/myclub.jsp'">MI CLUB</div>
        <div id="tab_5" class="tab" onclick="location.href='../configuration/configuration.jsp'">CONFIGURACI&Oacute;N</div>
    </div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">
        
        </div>
        <div id="main_div">
        	<div id="navigation" class="navigation">
            	<a href="./athletes.jsp">JUGADORES</a> >> Eliminar
            </div>
        	<%=info %>
            <div id="title" style="margin:15px;">
                <label> Seleccione uno o varios jugadores </label>
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
             	   <li style="height:35px;"><a href="add_athletes.jsp"> Agregar </a></li>
             	   <li style="height:35px;"><a href="edit_athletes.jsp"> Editar </a></li>
             	   <li style="height:35px;"><a href="#"> Eliminar </a></li>
        		</ul>
  			</div>
        </div>
    </div>    
</div>
<div id="pie">

</div>
</body>
</html>
