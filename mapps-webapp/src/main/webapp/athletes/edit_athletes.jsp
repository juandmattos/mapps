<%@ page contentType="text/html; charset=UTF-8" language="java" import="java.sql.*" errorPage="" %>
<%@ page import="com.mapps.model.Role" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
	<link rel="shortcut icon" href="../favicon.ico" />
	<title>Mapps</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta charset="utf-8" />
    <script type='text/javascript' src="../scripts/jquery-1.10.2.min.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcore.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistmenu.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxscrollbar.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxbuttons.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxpanel.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdatetimeinput.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxcalendar.js"></script>
    <script type="text/javascript" src="../jqwidgets/globalization/globalize.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxdropdownlist.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxlistbox.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxwindow.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxtooltip.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxvalidator.js"></script>
    <script type="text/javascript" src="../jqwidgets/jqxmaskedinput.js"></script>
	<link rel="stylesheet" href="../jqwidgets/styles/jqx.base.css" type="text/css" />
	<link rel="stylesheet" href="../jqwidgets/styles/jqx.metro.css" type="text/css" />
    <link rel="stylesheet" type="text/css" href="../css/main_style.css" /> 
    
</head>
<%
String token = String.valueOf(session.getAttribute("token"));
if (token.equals("null") || token.equals("")){
	response.sendRedirect("../index_login.jsp");	
}else{
	String trainingStarted = String.valueOf(session.getAttribute("trainingStarted"));
	if (trainingStarted.equals("null"))
	trainingStarted = "";
Role role;
if ( session.getAttribute("role") == null){
	role = null;	
}else{
	role = (Role) session.getAttribute("role");	
}

boolean show_pop_up = false;
String pop_up_message = "";
String info = String.valueOf(request.getParameter("info"));
if (info.equals("null"))
	info = "";
String error = String.valueOf(request.getParameter("error"));
if (error.equals("null"))
	error = "";

if(error.equals("1")){
	// El atleta ha sido ingresado con exito
	pop_up_message = "Error al modificar los datos del atleta. Contacte al administrador.";
	show_pop_up = true;	
}else if(error.equals("2")){

	pop_up_message = "Error al modificar los datos del atleta. Usted no tiene los permisos necesarios. Contacte al administrador.";
	show_pop_up = true;	
}
%>
<body>

<script type="text/javascript">

	$(document).ready(function () {
		// Create a jqxMenu
         set_tab_child_length();
		$("#name").jqxInput({placeHolder: "Nombre", height: 30, width: '100%', minLength: 1, theme: 'metro' });
		$("#lastName").jqxInput({placeHolder: "Apellido", height: 30, width: '100%', minLength: 1, theme: 'metro'  });
		$("#document").jqxInput({placeHolder: "C.I", height: 30, width: '100%', minLength: 1, theme: 'metro'  });
		$('#document').jqxInput({disabled: true });
		$("#date").jqxDateTimeInput({width: '50%', height: '30px', theme: 'metro'});
		$("#weight").jqxInput({placeHolder: "Peso (kg)", height: 30, width: '100%', minLength: 1, theme: 'metro'  });
		$("#height").jqxMaskedInput({ height: 30, width: '100%', mask: '#.##', theme: 'metro'  });
		$("#email").jqxInput({placeHolder: "e.g: mapps@mapps.com", height: 30, width: '100%', minLength: 1, theme: 'metro'  });
		$("#gender_list").jqxDropDownList({ source: ["Hombre", "Mujer", "Desconocido"], selectedIndex: 0, width: '50%', height: '30', dropDownHeight: '100', theme: 'metro'});
		$("#file").jqxInput({placeHolder: "Nombre", height: 25, width: 200, minLength: 1, theme: 'metro'});
		$("#validate").jqxButton({ width: '200', height: '35', theme: 'metro'});
		$("#validate").on('click', function (){ 
	        $('#edit_athlete').jqxValidator('validate');
	    });
		$("#image").jqxButton({ height: 30, width: '50%', theme: 'metro'});
		$("#image").on('click', function (){ 
	        $('#file').click();
	    });
		$("#edit_athlete").jqxValidator({
            rules: [
                    {input: "#name", message: "El nombre es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    { input: "#weight", message: "El peso del atleta es obligatorio!", action: 'keyup, blur', rule: 'required'},
					{ input: "#weight", message: "El debe ser un numero del 0-999!", action: 'keyup, blur', rule: function(){
						var value = $("#weight").val();
						return ($.isNumeric(value) && value>=0 && value<=999);
					}},
					{ input: "#height", message: "La altura del atleta es obligatoria!", action: 'keyup, blur', rule: 'required'},
					{ input: "#height", message: "La altura debe ser un numero!", action: 'keyup, blur', rule: function(){
						var value = $("#height").val();
						return $.isNumeric(value);
					}},
                    {input: "#lastName", message: "El apellido es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    { input: "#email", message: "El email es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    { input: '#email', message: 'Invalid e-mail!', action: 'keyup,blur', rule: 'email'},
                    { input: "#document", message: "El documento es obligatorio!", action: 'keyup, blur', rule: 'required'},
                    {input: "#gender", message: "El Género es obligatorio!", action: 'blur', rule: function (input, commit) {
                        var index = $("#gender").jqxDropDownList('getSelectedIndex');
                        return index != -1;
                       }
                    },
            ],  theme: 'metro'
	        });
		$('#edit_athlete').on('validationSuccess', function (event) {
	        $('#edit_athlete').submit();
	    });
		//Get athletes
		var url = "/mapps/getAllAthletesOfInstitution";		
		$.ajax({
            url: url,
            type: "GET",
            success: function (response){
				create_list(response);	            	
            }});
		
		$('#pop_up').jqxWindow({ maxHeight: 150, maxWidth: 280, minHeight: 30, minWidth: 250, height: 145, width: 270,
            resizable: false, draggable: false,
            okButton: $('#ok'), 
            initContent: function () {
                $('#ok').jqxButton({  width: '65px' });
                $('#ok').focus();
            }
        });	
			
		<%
		if(show_pop_up){	
		%>
			$("#pop_up").css('visibility', 'visible');
		<%
		}else{
		%>
			$("#pop_up").css('visibility', 'hidden');
			$("#pop_up").css('display', 'none');
		<%
		}
		%>
		$('#main_div_left').height($('#main_div_right').height());
		
		$("#tabs").jqxMenu({ width: '100%', height: '50px',theme:'metro'});
        
        var centerItems = function () {
            var firstItem = $($("#jqxMenu ul:first").children()[0]);
            firstItem.css('margin-left', 0);
            var width = 0;
            var borderOffset = 2;
            $.each($("#jqxMenu ul:first").children(), function () {
                width += $(this).outerWidth(true) + borderOffset;
            });
            var menuWidth = $("#jqxMenu").outerWidth();
            firstItem.css('margin-left', (menuWidth / 2 ) - (width / 2));
        }
        set_tab_child_length();
        centerItems();
        $(window).resize(function () {
      	  set_tab_child_length();
            centerItems();
        });
	});
	function set_tab_child_length(){
		var size = $('#ref_tab').width();
		for (var i=0; i<3; i++){
			$('#ul_'+i+'').width(size + 12);
		}
	}
	
	function create_list(response){
		var athletes = response['athletes'];
		$('#list_players').on('select', function (event) {
            updatePanel(athletes[event.args.index]);
        });
		$('#list_players').jqxListBox({ selectedIndex: 0,  source: athletes, displayMember: "firstname", valueMember: "notes", itemHeight: 90, height: '90%', width: '100%', theme: 'metro',
            renderer: function (index, label, value) {
                var datarecord = athletes[index];
                //var imgurl = '../../images/' + label.toLowerCase() + '.png';
                var img = '<img height="55" width="55" src="' + datarecord.imageURI + '"/>';
                var table = '<table style="min-width: 130px;border-spacing: 10px;"><tr><td style="width: 55px;" rowspan="2">' + img + '</td><td style="font-size:24px">  ' + datarecord.name + " " + datarecord.lastName + '</td></table>';
                return table;
            }
        });
		updatePanel(athletes[0]);
	}
	
	function updatePanel(athlete){
		$('#name').jqxInput('val', athlete['name']);
		$('#lastName').jqxInput('val', athlete['lastName']);
		$('#document').jqxInput('val', athlete['idDocument']);
		$('#weight').jqxInput('val', athlete['weight']);
		var height = new String(parseFloat(athlete['height']).toFixed(2))
		$('#height').jqxMaskedInput('val', ''+height+'');
		$('#email').jqxInput('val', athlete['email']);
		var index = 2;
		if (athlete['gender'] == "FEMALE"){
			index = 1;
		}else if (athlete['gender'] == "MALE"){
			index = 0;
		}
		$("#gender_list").jqxDropDownList({selectedIndex: index });
		$("#document-hidden").val(athlete.idDocument);
		var split = athlete.birth.split("/");
		$("#date").jqxDateTimeInput('val', new Date(split[2], parseInt(split[1]) - 1, split[0]));
	}
</script>

<style type="text/css">
#list img{
	width: 50px;
    height: 55px;
}

#list div{
	margin-top: -35px;
    margin-left: 80px;
}

.jqx-listmenu-item{
	padding: 0px;
    min-height: 57px;
}
</style>

<div id="header">
	<div id="header_izq">
    	<a href="../index.jsp"></href><img src="../images/logo_mapps.png" style="height:80px; margin-top:20px; margin-left:4%;" /></a>
    </div>
    <div id="header_central">
		<div id="pop_up">
            <div>
                <img width="14" height="14" src="../images/ok.png" alt="" />
                Informaci&oacute;n
            </div>
            <div>
            	<div style="height:60px;">
                	<%=pop_up_message
					%>
                </div>
                <div>
            		<div style="float: right; margin-top: 15px; vertical-align:bottom;">
           		        <input type="button" id="ok" value="OK" style="margin-right: 10px" />
        	        </div>
                </div>
            </div>
        </div>
    </div>
    <div id="header_der">
        <div id="logout" class="up_tab"><a href="../configuration/my_account.jsp">MI CUENTA</a></div>
		<%if(trainingStarted.equals("trainingStarted")){%>
		<div id="logout" class="up_tab"><a href="../index.jsp?logout=1" >CERRAR SESI&Oacute;N</a></div>
		<%}else{ %>
		<div id="logout" class="up_tab"><a href="/mapps/logout" >CERRAR SESI&Oacute;N</a></div>
    <%} %>
    </div>
</div>
<div id="contenedor">

    <div id='tabs' style="background-color:#4DC230; color:#FFF;text-align: center;">
                <ul>
                    <li style="width:18%; text-align:center; margin-left:11%; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;"><a href="../index.jsp">INICIO</a></li>
                    <li id="ref_tab" style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;background-color:#FFF; color:#4DC230;">JUGADORES
                        <ul id="ul_0" style="width:296px;">
                        	<li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/athletes.jsp">VER</a></li>
                        <%if(role.equals(Role.ADMINISTRATOR) || role.equals(Role.TRAINER)){%>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/add_athletes.jsp">AGREGAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/edit_athletes.jsp">EDITAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../athletes/delete_athletes.jsp">ELIMINAR</a></li>
                            <%}%>
                        </ul>
                    </li>
                    <li style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;">ENTRENAMIENTOS
                        <ul id="ul_1" style="width:296px;">
                        	<li style="text-align:center;font-size:16px;height:30px;"><a href="../training/training_reports.jsp">VER ANTERIORES</a></li>
                        <%if(role.equals(Role.ADMINISTRATOR) || role.equals(Role.TRAINER)){%>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../training/trainings.jsp">COMENZAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../training/create_training.jsp">PROGRAMAR</a></li>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../training/edit_training.jsp">EDITAR</a></li>
                            <%}%>
             	   		<%if(role.equals(Role.ADMINISTRATOR)){%>
                            <li style="text-align:center;font-size:16px;height:30px;"><a href="../training/change_permissions_training.jsp">EDITAR PERMISOS</a></li>
                            <%}%>
                        </ul>
                    </li>
                    <li style="width:18%; text-align:center; height:25px; padding-top:15px; font-size:16px; font-family:Century Gothic;">CONFIGURACI&Oacute;N
                        <ul id="ul_2" style="width:296px;">
                            <li style="text-align:center;font-size:16px;height:30px;">CUENTA
                                <ul style="width:186px;">
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/my_account.jsp">MI CUENTA</a></li>
                                </ul>
                            </li>
                            <%if(role.equals(Role.ADMINISTRATOR)){%>
                            <li style="text-align:center;font-size:16px;height:30px;">USUARIOS
                                <ul style="width:186px;">
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/register_user.jsp">AGREGAR</a></li>
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/edit_user.jsp">EDITAR</a></li>
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/delete_user.jsp">ELIMINAR</a></li>
                                </ul>
                            </li>
                            <li style="text-align:center;font-size:16px;height:30px;">INSTITUCIONES
                                <ul style="width:186px;">
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/add_institution.jsp">AGREGAR</a></li>
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/edit_institution.jsp">EDITAR</a></li>
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/delete_institution.jsp">ELIMINAR</a></li>
                                </ul>
                            </li>
                            <%}%>
                            <%if(role.equals(Role.ADMINISTRATOR) || role.equals(Role.TRAINER)){%>
                            <li style="text-align:center;font-size:16px;height:30px;">DEPORTES
                                <ul style="width:186px;">
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/add_sport.jsp">AGREGAR</a></li>
                                </ul>
                            </li>
                            <li style="text-align:center;font-size:16px;height:30px;">DISPOSITIVOS
                                <ul style="width:186px;">
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/add_device.jsp">AGREGAR</a></li>
                                    <%if(role.equals(Role.ADMINISTRATOR)){%>
                                    <li style="text-align:center;font-size:16px;height:30px;"><a href="../configuration/edit_device.jsp">EDITAR</a></li>
                                    <%}%>
                                </ul>
                            </li>
                            <%}%>
                        </ul>
                    </li>
                </ul>
            </div>
    <div id="area_de_trabajo">
		<div id="sidebar_left">
        	<div id="jqxMenu" style="visibility:hidden; margin:20px;">
        		<ul>
             	   <li style="height:35px;"><a href="add_athletes.jsp"> Agregar </a></li>
             	   <li style="height:35px;"><a href="#"> Editar </a></li>
             	   <li style="height:35px;"><a href="delete_athletes.jsp"> Eliminar </a></li>
        		</ul>
  			</div>
        </div>
        <div id="main_div">
        <div id="navigation" class="navigation">
            	<a href="./athletes.jsp">JUGADORES</a> >> Editar
        </div>
            <div id="main_div_left">
                <div id="title" style="margin:15px;">
                    <label> 1) Seleccione un jugador </label>
                </div>
                <div id="list_players">
                </div>
            </div>
            <div id="main_div_right">
                <form action="/mapps/modifyAthlete" method="post" name="agregar_deportista" id="edit_athlete" enctype="multipart/form-data">
                    <div id="title" style="margin:15px;">
                        <label> 2) Modifique los datos que desee </label>
                    </div>
                    <div id="campos" style="margin-left:40px;">
                        <div id="nombre">
                            <div class="tag_form_editar"> Nombre:  </div>
                            <div class="input"><input type="text" name="name" id="name" /></div>
                        </div>
                        <div id="apellido">
                            <div class="tag_form_editar"> Apellido: </div>
                            <div class="input"><input type="text" name="lastName" id="lastName" /></div>
                        </div>
                        <div id="ci">
                            <div class="tag_form_editar"> C.I.: </div>
                            <div class="input"><input type="text" id="document" /></div>
                        </div>
                        <div id="birth">
                            <div class="tag_form_editar_list">Nacimiento: </div>
                            <div id="date" class="input list_box">
                            </div>
                        </div>
                        <div id="peso">
                            <div class="tag_form_editar"> Peso: </div>
                            <div class="input"><input type="text" name="weight" id="weight" /></div>
                        </div>
                        <div id="altura">
                            <div class="tag_form_editar"> Altura: </div>
                            <div class="input"><input type="text" name="height" id="height" /></div>
                        </div>
                        <div id='gender'>
                        	<div class="tag_form_editar_list"> Sexo: </div>
                            <div id="gender_list" class="list_box"></div>
                        </div>
                        <div id="e_mail">
                            <div class="tag_form_editar"> Email: </div>
                            <div class="input"><input type="text" name="email" id="email" /></div>
                        </div>
                        <div>
                    		<div class="tag_form_editar" style="float: left;margin-top: 7px"> Imagen: </div>
                    		<div style="height:0px;overflow:hidden">
                        	<div class="input"><input name="file"  id="file" type="file" /></div>
                        	</div>
                        	<input type="button" id="image" value="CAMBIAR IMAGEN" style="float: left;margin-top: 7px;margin-left: 5px;"/>
                    	</div>
                    	<div style="margin-top: 65px">
                    		<center><input type="button" id="validate" value="CONFIRMAR"/></center>
                   		</div>
                    </div>
                    <input type="hidden" id="document-hidden" name="document"></input>
                </form>
            </div>
        </div>
        <div id="sidebar_right">
        	
        </div>
    </div>

</div>
<div id="pie">
<%} %>
</div>
</body>
</html>
