<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="com.mapps.model.Role" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml"><!-- InstanceBegin template="/Templates/mapps_template.dwt.jsp" codeOutsideHTMLIsLocked="false" -->
<head>
	<!-- InstanceBeginEditable name="EditRegion5" -->
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta charset="utf-8">
    <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css">
    <script src="http://code.jquery.com/jquery-1.9.1.js"></script>
    <script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
    <script type='text/javascript' src="../scripts/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcore.js"></script>

	<link rel="stylesheet" href="../jqwidgets/styles/jqx.base.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../css/main_style.css"> 
    <!-- InstanceEndEditable -->
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
<!-- InstanceBeginEditable name="EditRegion4" -->
<script type="text/javascript">
	$(document).ready(function () {
	// Create a jqxMenu
        $("#jqxMenu").jqxMenu({ width: '150', mode: 'vertical'});
        $("#jqxMenu").css('visibility', 'visible');
	});
</script>

    <script type="text/javascript" src="./jqwidgets/jqxinput.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="./jqwidgets/jqxmenu.js"></script>
    <link rel="stylesheet" href="./jqwidgets/styles/jqx.office.css" type="text/css" />
    <title>Untitled Document</title>
    
	<!-- InstanceEndEditable -->

<div id="header">
	<div id="header_izq">
    
    </div>
    <div id="header_central">
	<!-- InstanceBeginEditable name="EditRegion1" -->
	
	<!-- InstanceEndEditable -->
    </div>
    <div id="header_der">
	
    </div>
</div>
<div id="contenedor">
<!-- InstanceBeginEditable name="EditRegion2" -->
<div id="tabs">
	  <div id="tab_1" class="tab active" style="margin-left:12%;">INICIO</div>
        <div id="tab_2" class="tab">JUGADORES</div>
        <div id="tab_3" class="tab">ENTRENAMIENTOS</div>
        <div id="tab_4" class="tab">MI CLUB</div>
        <div id="tab_5" class="tab" style="margin-right:180px;">CONFIGURACI&Oacute;N</div>
  </div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        	<ul>
        		<li><a href="register_user.jsp">Registrar Usuario</a></li>
        	</ul>
        	</div>
        </div>
		<!-- TemplateBeginEditable name="EditRegion7" -->EditRegion7
        
        <div id="main_div">
        	<div id="start_training_div">
            	<input type="button" id="start_training" name="start_training" value="INICIAR ENTRENAMIENTO" style="margin-left:200px;" />
            </div>
        </div>
        <div id="sidebar_right">
        
        </div>
    </div>
    <!-- TemplateEndEditable -->
<!-- InstanceEndEditable -->    
</div>
<div id="pie">

</div>
</body>
<!-- InstanceEnd --></html>
