package com.mapps.servlets;

import com.mapps.model.Athlete;
import com.mapps.model.Gender;
import com.mapps.model.Institution;
import com.mapps.model.Role;
import com.mapps.services.institution.InstitutionService;
import com.mapps.services.trainer.TrainerService;
import com.mapps.services.trainer.exceptions.AuthenticationException;
import com.mapps.services.trainer.exceptions.InvalidAthleteException;
import com.mapps.services.user.UserService;

import javax.ejb.EJB;
import javax.servlet.Servlet;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.Date;

/**
 *
 */
@WebServlet(name = "modifyAthlete", urlPatterns = "/modifyAthlete/*")
public class ModifyAthleteServlet extends HttpServlet implements Servlet {
    @EJB(beanName="UserService")
    UserService userService;

    @EJB(beanName="TrainerService")
    TrainerService trainerService;

    @EJB(beanName="InstitutionService")
    InstitutionService institutionService;

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)throws ServletException, IOException {

        String token = req.getParameter("token");
        Role userRole= null;
        try {
            userRole = userService.userRoleOfToken(token);
        } catch (com.mapps.services.user.exceptions.InvalidUserException e) {
            req.setAttribute("error","Invalid user");
        } catch (com.mapps.services.user.exceptions.AuthenticationException e) {
            req.setAttribute("error","Authentication error");
        }
        req.setAttribute("token", token);
        req.setAttribute("role",userRole);

        String name=req.getParameter("name");
        String lastName=req.getParameter("lastName");
        Date birth=new Date(req.getParameter("date"));
        Gender gender=null;
        if(req.getParameter("gender")=="male"){
            gender=Gender.MALE;
        }else{
            gender=Gender.FEMALE;
        }
        String email=req.getParameter("email");
        double weight=Double.parseDouble(req.getParameter("weight"));
        double height=Double.parseDouble(req.getParameter("height"));
        String idDocument=req.getParameter("idDocument");
        String instName=req.getParameter("institution");
        Institution instAux=institutionService.getInstitutionByName(instName);

        Athlete athlete=new Athlete(name,lastName,birth,gender,email,weight,height,idDocument,instAux);
        athlete.setEnabled(true);

        try {
            trainerService.modifyAthlete(athlete,token);
            req.setAttribute("info","El atleta fue modificado con éxito");

        } catch (InvalidAthleteException e) {
            req.setAttribute("error","Atleta no valido");

        } catch (AuthenticationException e) {
            req.setAttribute("error","Error de autentificación");

        }

    }

}