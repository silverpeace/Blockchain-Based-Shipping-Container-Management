# Blockchain-Based Shipping Container Management System

A comprehensive solution for managing shipping containers using blockchain technology. This system provides transparent, secure, and efficient management of container registration, booking, tracking, and condition monitoring throughout the shipping process.

## Overview

This project implements four main smart contracts using Clarity:

1. **Container Registration Contract**: Manages container details, ownership, and status
2. **Booking Contract**: Handles reservations for container space
3. **Tracking Contract**: Monitors container location throughout the journey
4. **Condition Monitoring Contract**: Records environmental factors during transport

## Features

### Container Registration
- Register new containers with detailed specifications
- Update container status (available, in-use, in-maintenance, etc.)
- Transfer container ownership
- Query container details

### Booking Management
- Create bookings for container space
- Specify origin, destination, and timeline
- Track payment status
- Update booking status (pending, confirmed, in-transit, delivered, cancelled)

### Location Tracking
- Record container locations with GPS coordinates
- Track container status at each location
- Maintain historical location data
- Query current and historical locations

### Condition Monitoring
- Set alert thresholds for environmental conditions
- Record temperature, humidity, shock, and tilt data
- Check conditions against alert thresholds
- Query historical condition data

## Smart Contracts

### Container Registration Contract
```clarity
;; Register a new container
(define-public (register-container 
    (length uint) 
    (width uint) 
    (height uint) 
    (max-weight uint) 
    (manufacturing-date uint))
  ;; Implementation details in contract file
)
