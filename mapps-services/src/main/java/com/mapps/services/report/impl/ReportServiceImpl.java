package com.mapps.services.report.impl;

import java.util.Collections;
import java.util.List;
import javax.ejb.EJB;
import javax.ejb.Stateless;

import org.apache.log4j.Logger;

import com.google.common.collect.Lists;
import com.mapps.authentificationhandler.AuthenticationHandler;
import com.mapps.authentificationhandler.exceptions.InvalidTokenException;
import com.mapps.exceptions.AthleteNotFoundException;
import com.mapps.exceptions.InvalidReportException;
import com.mapps.exceptions.NullParameterException;
import com.mapps.exceptions.TrainingNotFoundException;
import com.mapps.model.Athlete;
import com.mapps.model.Device;
import com.mapps.model.Permission;
import com.mapps.model.ProcessedDataUnit;
import com.mapps.model.PulseReport;
import com.mapps.model.RawDataUnit;
import com.mapps.model.Report;
import com.mapps.model.Role;
import com.mapps.model.Training;
import com.mapps.model.User;
import com.mapps.persistence.AthleteDAO;
import com.mapps.persistence.ProcessedDataUnitDAO;
import com.mapps.persistence.PulseReportDAO;
import com.mapps.persistence.RawDataUnitDAO;
import com.mapps.persistence.ReportDAO;
import com.mapps.persistence.TrainingDAO;
import com.mapps.services.report.ReportService;
import com.mapps.services.report.exceptions.AuthenticationException;
import com.mapps.services.report.exceptions.NoPulseDataException;
import com.mapps.services.trainer.exceptions.InvalidAthleteException;
import com.mapps.services.trainer.exceptions.InvalidTrainingException;
import com.mapps.wrappers.AthleteWrapper;

/**
 *
 *
 */
@Stateless(name = "ReportService")
public class ReportServiceImpl implements ReportService {


    Logger logger = Logger.getLogger(ReportServiceImpl.class);
    @EJB(name = "TrainingDAO")
    TrainingDAO trainingDAO;
    @EJB(name = "ReportDAO")
    ReportDAO reportDAO;
    @EJB(name = "AthleteDAO")
    AthleteDAO athleteDAO;
    @EJB(name = "ProcessedDataUnitDAO")
    ProcessedDataUnitDAO processedDataUnitDAO;
    @EJB(name = "AuthenticationHandler")
    AuthenticationHandler authenticationHandler;
    @EJB(name = "RawDataUnitDAO")
    RawDataUnitDAO rawDataUnitDAO;
    @EJB(name = "PulseReportDAO")
    PulseReportDAO pulseReportDAO;


    private List<ProcessedDataUnit> getAthleteStats(String trainingID, String athleteCI, String token) throws AuthenticationException, InvalidTrainingException, InvalidAthleteException {
        if (trainingID == null || athleteCI == null) {
            throw new IllegalArgumentException();
        }
        try {
            User user = authenticationHandler.getUserOfToken(token);
            Training training = trainingDAO.getTrainingByName(trainingID);
            Permission permission = training.getMapUserPermission().get(user);
            if (permission != Permission.CREATE && permission != Permission.READ) {
                logger.error("User has no permissions");
                throw new AuthenticationException();
            }
            Athlete athlete = athleteDAO.getAthleteByIdDocument(athleteCI);
            return processedDataUnitDAO.getProcessedDataUnitsFromAthleteInTraining(training, athlete);
        } catch (InvalidTokenException e) {
            logger.error("Invalid token");
            throw new AuthenticationException();
        } catch (TrainingNotFoundException e) {
            logger.error("Invalid Training");
            throw new InvalidTrainingException();
        } catch (AthleteNotFoundException e) {
            logger.error("Invalid Athlete");
            throw new InvalidAthleteException();
        } catch (NullParameterException e) {
            logger.error("Invalid parameters");
            throw new IllegalStateException();
        }
    }

    public PulseReport getAthletePulseStats(Training training, Athlete athlete, boolean reload, String token) throws AuthenticationException, NoPulseDataException {
        if (training == null || athlete == null) {
            throw new IllegalArgumentException();
        }
        try {
            User user = authenticationHandler.getUserOfToken(token);
            Permission permission = trainingDAO.getPermissionOfUser(training, user);
            if (permission != Permission.CREATE && permission != Permission.READ) {
                logger.error("User has no permissions");
                throw new AuthenticationException();
            }
            Device device = trainingDAO.getDeviceOfAthlete(training, athlete);
            List<RawDataUnit> rawDataUnits = rawDataUnitDAO.getRawDataFromAthleteOnTraining(training, device);
            if (rawDataUnits.size() == 0) {
                throw new NoPulseDataException();
            }
            PulseReport report;
            if (reload) {
                report = new PulseReport.Builder().setAthlete(athlete).setPulseData(rawDataUnits)
                        .setTraining(training).buildRealTime();
            } else {
                report = new PulseReport.Builder().setPulseData(rawDataUnits)
                        .setAthlete(athlete)
                        .setTraining(training).build();
            }
            return report;
        } catch (InvalidTokenException e) {
            logger.error("Invalid token");
            throw new AuthenticationException();
        }
    }

    @Override
    public Report getReport(String trainingName, String athleteId, String token) throws
            AuthenticationException, InvalidReportException {
        if (trainingName == null || athleteId == null || token == null) {
            throw new AuthenticationException();
        }
        Report report = null;
        try {
            if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR) ||
                    authenticationHandler.isUserInRole(token, Role.TRAINER)) {
                Athlete athlete = athleteDAO.getAthleteByIdDocument(athleteId);
                report = reportDAO.getReport(trainingName, athlete);
            } else {
                throw new AuthenticationException();
            }
            if (report == null) {
                throw new InvalidReportException();
            }
        } catch (InvalidTokenException e) {
            throw new AuthenticationException();
        } catch (AthleteNotFoundException e) {
            throw new AuthenticationException();
        } catch (InvalidReportException e) {
            throw new InvalidReportException();
        }
        return report;
    }

    @Override
    public PulseReport getPulseReport(String trainingName, String athleteId, String token) throws
            AuthenticationException{
        if (trainingName == null || athleteId == null || token == null) {
            throw new AuthenticationException();
        }
        PulseReport report = null;
        try {
            if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR) ||
                    authenticationHandler.isUserInRole(token, Role.TRAINER)) {
                Athlete athlete = athleteDAO.getAthleteByIdDocument(athleteId);
                Training training = new Training();
                training.setName(trainingName);
                report = pulseReportDAO.getPulseReport(training, athlete);
                report.setAthleteWrapper(new AthleteWrapper.Builder().setAthlete(athlete).build());
                report.setTrainingTypePercentage();
            } else {
                throw new AuthenticationException();
            }
        } catch (InvalidTokenException e) {
            throw new AuthenticationException();
        } catch (AthleteNotFoundException e) {
            throw  new IllegalStateException("Invalid Athlete", e);
        }
        return report;
    }

    @Override
    public List<Report> getReportsOfTraining(String trainingName, String token) throws AuthenticationException {
        if (trainingName == null || token == null) {
            throw new AuthenticationException();
        }
        try {
            if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR) ||
                    authenticationHandler.isUserInRole(token, Role.TRAINER)) {
                return reportDAO.getReportsOfTraining(trainingName);
            }
            throw new AuthenticationException();
        } catch (InvalidTokenException e) {
            throw new AuthenticationException();
        }
    }

    @Override
    public List<PulseReport> getPulseReportsOfTraining(String trainingName, String token) throws
            AuthenticationException {
        if (trainingName == null || token == null) {
            throw new AuthenticationException();
        }
        try {
            if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR) ||
                    authenticationHandler.isUserInRole(token, Role.TRAINER)) {
                List<PulseReport> reports = pulseReportDAO.getReportsOfTraining(trainingName);
                Collections.sort(reports);
                return reports;
            }
            throw new AuthenticationException();
        } catch (InvalidTokenException e) {
            throw new AuthenticationException();
        }
    }


    @Override
    public void createTrainingReports(String trainingID, String token) throws AuthenticationException {
        if (trainingID == null || token == null) {
            throw new AuthenticationException();
        }
        try {
            if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR) ||
                    authenticationHandler.isUserInRole(token, Role.TRAINER)) {
                Training training = trainingDAO.getTrainingByName(trainingID);
                for (Athlete athlete : training.getMapAthleteDevice().keySet()) {
                    List<ProcessedDataUnit> data = getAthleteStats(trainingID, athlete.getIdDocument(), token);
                    if (data.size() == 0) {
                        logger.error("The training has no data");
                        return;
                    }
                    Report report = new Report.Builder().setAthlete(athlete)
                            .setTrainingName(trainingID)
                            .setData(data)
                            .build();
                    reportDAO.addReport(report);
                    if (training.getReports() == null) {
                        List<Report> reports = Lists.newArrayList();
                        training.setReports(reports);
                    }
                    training.getReports().add(report);
                    trainingDAO.updateTraining(training);
                }
            } else {
                logger.error("User is not a trainer");
                throw new AuthenticationException();
            }
        } catch (InvalidTokenException e) {
            logger.error("Authentication exception");
            throw new AuthenticationException();
        } catch (TrainingNotFoundException e) {
            throw new IllegalStateException("Training not found", e);
        } catch (InvalidAthleteException e) {
            throw new IllegalStateException("Athlete not found", e);
        } catch (InvalidTrainingException e) {
            throw new IllegalStateException("Training not found", e);
        } catch (NullParameterException e) {
            throw new IllegalStateException("Wrong parameters on saving report", e);
        }
    }

    @Override
    public void createTrainingPulseReports(String trainingID, String token) throws AuthenticationException {
        if (trainingID == null || token == null) {
            throw new AuthenticationException();
        }
        try {
            if (authenticationHandler.isUserInRole(token, Role.ADMINISTRATOR) ||
                    authenticationHandler.isUserInRole(token, Role.TRAINER)) {
                Training training = trainingDAO.getTrainingByName(trainingID);
                for (Athlete athlete : training.getMapAthleteDevice().keySet()) {
                    try{
                    PulseReport report = getAthletePulseStats(training, athlete, false, token);
                    pulseReportDAO.addReport(report);
                    if (training.getReports() == null) {
                        List<Report> reports = Lists.newArrayList();
                        training.setReports(reports);
                    }
                    training.getPulseReports().add(report);
                    }catch (NoPulseDataException e){
                        logger.info("No pulse data for "+ athlete.getName() +" yet");
                    }
                }
                trainingDAO.updateTraining(training);
            } else {
                logger.error("User is not a trainer");
                throw new AuthenticationException();
            }
        } catch (InvalidTokenException e) {
            logger.error("Authentication exception");
            throw new AuthenticationException();
        } catch (TrainingNotFoundException e) {
            throw new IllegalStateException("Training not found", e);
        } catch (NullParameterException e) {
            throw new IllegalStateException("Wrong parameters on saving report", e);
        }
    }

    public List<PulseReport> getPulseDataOfTraining(String trainingName, String token) throws
            AuthenticationException {
        if (trainingName == null || token == null) {
            throw new AuthenticationException();
        }
        try {
            List<PulseReport> reports = Lists.newArrayList();
            Training training = trainingDAO.getTrainingByName(trainingName);
            for (Athlete athlete : training.getMapAthleteDevice().keySet()) {
                try {
                    PulseReport pulseReport = getAthletePulseStats(training, athlete, false, token);
                    reports.add(pulseReport);
                } catch (NoPulseDataException e) {
                    logger.error("There is no data for athlete: " + athlete.getName());
                }
            }
            Collections.sort(reports);
            return reports;
        } catch (TrainingNotFoundException e) {
            logger.error("Invalid Training");
            throw new IllegalStateException("Invalid training", e);
        }
    }
}
