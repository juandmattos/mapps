<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="com.mapps.model.Role" %><%
    List inst;
    if((request.getAttribute("institutionNames"))==null){
        inst=new ArrayList();
    }else{
        inst= (List)request.getAttribute("institutionNames");
    }
    String token;
    if(request.getAttribute("token")== null){
        token="";
    } else{
        token=String.valueOf(request.getAttribute("token"));
    }
    Role role;
    if(request.getAttribute("role")==null){
        role=null;
    }else{
        role=(Role)request.getAttribute("role");
    }

%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>MAPPS</title>

    <link rel="stylesheet" href="css/style.css" type="text/css" media="screen"/>
</head>
<body>

<%
    if(inst!=null && role.toString()=="Administrator"){
        for(int i=0;i<inst.size();i++){ %>
<%=inst.get(i) %>
<%}

}else{ %>
<%="inst null"%>
<%  }
%>

    <div class="container">

        <div class="login">
            <div class="loginContent">
        <form action="registerUser" method="post">
    <label>Name: <input type="text" name="name" id="name" required="required" /></label>
    <br/>
    <br/>
    <label>Last name: <input type="text" name="lastName" id="lastName" required="required" /></label>
    <br/>
    <br/>
    <label>Date: <input type="text" name="date" id="date" required="required" /></label>
    <br/>
    <br/>
    <label>Gender: <input type="text" name="gender" id="gender" required="required" /></label>
    <br/>
    <br/>
    <label>Email: <input type="text" name="email" id="email" required="required" /></label>
    <br/>
    <br/>
    <label>Username: <input type="text" name="username" id="username" required="required" /></label>
    <br/>
    <br/>
    <label>Password: <input type="password" name="password" id="password" required="required" /></label>
    <br/>
    <br/>
    <label>Institution: <input type="text" name="institution" id="institution" required="required" /></label>
    <br/>
    <br/>
    <label>Role: <input type="text" name="role" id="role" required="required" /></label>
    <br/>
    <br/>
    <label>idDocument: <input type="text" name="idDocument" id="idDocument" required="required" /></label>
    <br/>
    <br/>
    <div align="center" >
        <input type="submit" name="registrar" value="Register" style="font-size:16px"/>

    <br/>
    <br/>

    </div>
        </form>
            </div>
            </div>

</div>
</body>
</html>