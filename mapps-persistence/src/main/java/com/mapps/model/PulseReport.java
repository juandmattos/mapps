package com.mapps.model;

import java.util.Date;
import java.util.List;
import java.util.Map;
import javax.persistence.Column;
import javax.persistence.ElementCollection;
import javax.persistence.Entity;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.persistence.Transient;

import org.hibernate.annotations.LazyCollection;
import org.hibernate.annotations.LazyCollectionOption;

import com.google.common.collect.Maps;
import com.mapps.pulsedata.RestPulseForAge;
import com.mapps.stats.PulseStatsDecoder;
import com.mapps.wrappers.AthleteWrapper;

/**
 * Represents a pulse report on the database. Gives the necessary information about pulse calculations a data
 * to display the necessary information.
 */
@Entity
@Table(name = "PulseReports")
public class PulseReport implements Comparable<PulseReport>{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;
    @ElementCollection
    @LazyCollection(LazyCollectionOption.FALSE)
    private List<Integer> pulse;
    @LazyCollection(LazyCollectionOption.FALSE)
    @ElementCollection
    private List<Long> time;
    private long elapsedTime;
    @Temporal(TemporalType.DATE)
    @Column(nullable = false)
    private Date createdDate;
    @ManyToOne(fetch = FetchType.EAGER)
    private Athlete athlete;
    @Transient
    private AthleteWrapper athleteWrapper;
    @Enumerated
    private TrainingType trainingType;
    private String trainingName;
    private double kCal;
    private int lastPulse;
    private double meanBPM;
    @Transient
    private Map<String, Double> trainingTypePercentage;

    public PulseReport() {

    }

    public PulseReport(String trainingName, List<Long> time, List<Integer> pulse, long elapsedTime,
                       Date createdDate, Athlete athlete) {
        this.trainingName = trainingName;
        this.time = time;
        this.pulse = pulse;
        this.elapsedTime = elapsedTime;
        this.createdDate = createdDate;
        this.athlete = athlete;
        this.athleteWrapper = new AthleteWrapper.Builder().setAthlete(this.athlete).build();
        this.trainingType = getTrainingType(this.pulse.get(this.pulse.size()-1));
        this.meanBPM = getMeanBPM();
        this.kCal = getKcalPerMinute() * (time.get(time.size() - 1) - time.get(0)) / (1000 * 60);
        this.lastPulse = pulse.get(pulse.size() - 1);
        setTrainingTypePercentage();
    }

    public List<Integer> getPulse() {
        return pulse;
    }

    public void setPulse(List<Integer> pulse) {
        this.pulse = pulse;
    }

    public List<Long> getTime() {
        return time;
    }

    public void setTime(List<Long> time) {
        this.time = time;
    }

    public long getElapsedTime() {
        return elapsedTime;
    }

    public void setElapsedTime(long elapsedTime) {
        this.elapsedTime = elapsedTime;
    }

    public Date getCreatedDate() {
        return createdDate;
    }

    public void setCreatedDate(Date createdDate) {
        this.createdDate = createdDate;
    }

    public Athlete getAthlete() {
        return athlete;
    }

    public void setAthlete(Athlete athlete) {
        this.athlete = athlete;
    }

    @Transient
    public AthleteWrapper getAthleteWrapper() {
        return athleteWrapper;
    }

    @Transient
    public void setAthleteWrapper(AthleteWrapper athleteWrapper) {
        this.athleteWrapper = athleteWrapper;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    @Transient
    public TrainingType getTrainingType(int bpm) {
        RestPulseForAge restPulse = RestPulseForAge.loadFromJson();
        List<Integer> fcr;
        if (athlete.getGender().equals(Gender.MALE)) {
            fcr = restPulse.getMalePulse();
        } else {
            fcr = restPulse.getFemalePulse();
        }
        int age = athleteWrapper.getAge();
        return TrainingType.fromFCR(fcr.get(age), age, bpm);
    }

    @Transient
    public double getKcalPerMinute() {
        double weight = athlete.getWeight();
        int age = athleteWrapper.getAge();
        if (athlete.getGender().equals(Gender.MALE)) {
            return (-55.0969 + (0.6309 * meanBPM) + 0.1988 * weight + 0.2017 * age) / (4.184 * 1000);
        } else {
            return (-20.4022 + (0.4472 * meanBPM) + 0.1263 * weight + 0.074 * age) / (4.184 * 1000);
        }
    }

    @Transient
    public double getMeanBPM() {
        double sum = 0;
        for (Integer bpm : pulse) {
            sum += bpm;
        }
        return sum / pulse.size();
    }

    @Transient
    public void setTrainingTypePercentage() {
        Map<String, Double> map = Maps.newHashMap();
        for (Integer bpm : this.pulse){
            String type = getTrainingType(bpm).name();
            if (map.get(type) == null){
                map.put(type, (1.0 / pulse.size()));
            }else{
                map.put(type, map.get(type) + (1.0 / pulse.size()));
            }
        }
        this.trainingTypePercentage = map;
    }

    @Override
    public int compareTo(PulseReport pulseReport) {
        return athlete.getId().compareTo(pulseReport.getAthlete().getId());
    }

    public static class Builder {
        private List<RawDataUnit> rawDataUnits;
        private Athlete athlete;
        private Training training;

        public Builder setPulseData(List<RawDataUnit> rawDataUnits) {
            this.rawDataUnits = rawDataUnits;
            return this;
        }

        public Builder setAthlete(Athlete athlete) {
            this.athlete = athlete;
            return this;
        }

        public Builder setTraining(Training training) {
            this.training = training;
            return this;
        }

        public PulseReport build() {
            PulseStatsDecoder decoder = new PulseStatsDecoder(this.rawDataUnits);
            PulseReport report = new PulseReport(training.getName(),
                                                 decoder.getTime(),
                                                 decoder.getPulse(),
                                                 decoder.getElapsedTime(),
                                                 new Date(), this.athlete);
            return report;
        }

        public PulseReport buildRealTime() {
            PulseStatsDecoder decoder = new PulseStatsDecoder(this.rawDataUnits);
            PulseReport report = new PulseReport(training.getName(),
                                                 decoder.getTime(),
                                                 decoder.getPulse(),
                                                 decoder.getElapsedTime(),
                                                 new Date(), this.athlete);
            report.setTime(decoder.getLatestTime());
            report.setPulse(decoder.getLatestPulse());
            return report;
        }

    }
}
