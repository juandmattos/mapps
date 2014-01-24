package com.mapps.model;


import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;

/**
 * Representation of a processed data unit in the system
 */
@Entity
@Table(name="ProcessedDataUnits")

public class ProcessedDataUnit {

    @Id
    @GeneratedValue(strategy= GenerationType.IDENTITY)
    Long id;
    @Column(nullable = false)
    double positionX;
    @Column(nullable = false)
    double positionY;
    @Column(nullable = false)
    double velocityX;
    @Column(nullable = false)
    double velocityY;
    @Column(nullable = false)
    double accelerationX;
    @Column(nullable = false)
    double accelerationY;
    @ManyToOne(fetch = FetchType.LAZY)
    RawDataUnit rawDataUnit;
    @Temporal(TemporalType.TIMESTAMP)
    Date date;


    public RawDataUnit getRawDataUnit() {
        return rawDataUnit;
    }

    public void setRawDataUnit(RawDataUnit rawDataUnit) {
        this.rawDataUnit = rawDataUnit;
    }

    public Device getDevice() {
        return device;
    }

    public void setDevice(Device device) {
        this.device = device;
    }

    @ManyToOne
    Device device;

    public ProcessedDataUnit(){

    }

    public ProcessedDataUnit(double positionX, double accelerationY, double accelerationX, double velocityY,
                             double velocityX, double positionY,Device device,RawDataUnit rawDataUnit, Date date) {
        this.positionX = positionX;
        this.accelerationY = accelerationY;
        this.accelerationX = accelerationX;
        this.velocityY = velocityY;
        this.velocityX = velocityX;
        this.positionY = positionY;
        this.rawDataUnit=rawDataUnit;
        this.device=device;
        this.date = date;
    }

    public double getPositionX() {
        return positionX;
    }

    public void setPositionX(double positionX) {
        this.positionX = positionX;
    }

    public double getPositionY() {
        return positionY;
    }

    public void setPositionY(double positionY) {
        this.positionY = positionY;
    }

    public double getVelocityX() {
        return velocityX;
    }

    public void setVelocityX(double velocityX) {
        this.velocityX = velocityX;
    }

    public double getVelocityY() {
        return velocityY;
    }

    public void setVelocityY(double velocityY) {
        this.velocityY = velocityY;
    }

    public double getAccelerationX() {
        return accelerationX;
    }

    public void setAccelerationX(double accelerationX) {
        this.accelerationX = accelerationX;
    }

    public double getAccelerationY() {
        return accelerationY;
    }

    public void setAccelerationY(double accelerationY) {
        this.accelerationY = accelerationY;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }
}
