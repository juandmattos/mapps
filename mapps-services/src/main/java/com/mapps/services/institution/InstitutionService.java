package com.mapps.services.institution;

import java.util.List;
import javax.ejb.Local;

import com.mapps.model.Device;
import com.mapps.model.Institution;
import com.mapps.model.Training;
import com.mapps.model.User;
import com.mapps.services.institution.exceptions.AuthenticationException;
import com.mapps.services.institution.exceptions.InvalidInstitutionException;
import com.mapps.services.user.exceptions.InvalidUserException;

/**
 *
 */
@Local
public interface InstitutionService {

    /**
     * Creates and persist an Institution into the system
     *
     * @param institution Institution to add in the system.
     * @param token       that represent the session.
     */
    void createInstitution(Institution institution, String token) throws AuthenticationException, InvalidInstitutionException;

    /**
     * Deletes an Institution from the system
     *
     * @param institution Institution to delete in the system.
     * @param token       that represent the session.
     */
    void deleteInstitution(Institution institution, String token) throws AuthenticationException, InvalidInstitutionException;

    /**
     * Updates an Institution
     *
     * @param institution Institution to update.
     * @param token       that represent the session.
     */
    void updateInstitution(Institution institution, String token) throws AuthenticationException, InvalidInstitutionException;

    public List<Institution> getAllInstitutions();

    public Institution getInstitutionByName(String name);

    public Institution getInstitutionOfUser(String username) throws InvalidUserException;

    Institution getInstitutionByID(String token, long id) throws InvalidInstitutionException, AuthenticationException;

    List<Device> getDeviceOfInstitution(String token) throws AuthenticationException;

    List<Training> getTraingsToStartOfInstitution(String token) throws AuthenticationException;

    List<User> getUsersOfInstitution(String token) throws AuthenticationException;

    public Training getStartedTrainingOfInstitution(String token) throws AuthenticationException;

    public List<Training> getFinishedTrainingsOfInstitution(String token) throws AuthenticationException;
}
