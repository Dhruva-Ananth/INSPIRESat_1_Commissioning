# Scripts Listing for IS1 operations

There are various scripts made for commissioning process of INSPIRESat-1.
These scripts will be repeatedly utilized to commission the satellite and also operate the satellite in nominal modes of operations.

## Commissioning Plan
commission_is1 - A top level script which wraps all the commissioning scripts underneath asking the user whether to proceed to the next stage. This script should also allow starting the commissioning process from anywhere in the middle.
The commissioning of the spacecraft is divided into 3 phases: 
Phase – 1:  
1.	Aliveness – safe and phoenix mode. Run the code depending on the spacecraft mode detected in beacon
Phase – 2: 
2.	Set time – DAXSS time as well as ADCS time. Should take a time stamp of the system time, compensate for UTC and upload in the satellite ADCS
3.	Playback deployment data (ADCS rolls over in just 3 days)
4.	Commission ADCS:
a.	Set ephemeris – A common script which will be used during Orbit operations as well
b.	Test fine pointing
Phase – 3: 
5.	Instrument aliveness – DAXSS and CIP both
6.	Go to science
7.	Adjust X123 thresholds, change modes of CIP operation


### Commissioning Sequence
In this phase we will try to commission the satellite's bus, where we qualify the body rates of the satellite and also analyse the health of various subsystems.

#### Objectives
Each test sequence is defined for 1 pass per test. Being a polar orbit, satisfactory passes are expected only twice a day at a particular ground station. Data dumps are also anticipated during some passes, so goal is to run one commissioning test sequence per day and be in normal science operations in about a week after deployment from PSLV. Target should be to complete the test sequence in the first good pass of the day. The second good pass would be a backup in case the test sequence does not complete during the first pass. Each test script should contain a FINISH section to which the operator should jump if the pass nears an end (<2 minutes before end of pass). 

|Test Sequence|Objective                                                                                                                                                                                        |~Time to complete script with no catches (should be < 5 min)|
|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|------------------------------------------------------------|
|1            |Do aliveness test, change SD card beacon rate to slower value (commission_aliveness_safe / commission_aliveness_phoenix)                                                                         |3 minutes                                                   |
|2            |Set spacecraft and ADCS time, set ephemeris and set to fine pointing (commission_set_adcs_time, commission_set_daxss_time, commission_set_ephemeris)                                             |3 minutes                                                   |
|3            |Commission ADCS – test fine pointing  (commission_adcs_fine_point)                                                                                                                               |5 minutes                                                   |
|4            |Test Sband reception – downlink beacon partition                                                                                                                                                 |2 minutes                                                   |
|5            |Download beacon deployment data - 12 hrs worth of deployment data to download from UHF takes about 9792 seconds, hence downloading from SBand is more appropriate  (commission_playback_dep_data)|5 minutes                                                   |
|6            |Do instrument aliveness test in safe mode  (commission_daxss_aliveness, commission_cip_aliveness)                                                                                                |                                                            |
|7            |Go to science mode (commission_scic_mode, commission_scid_mode)                                                                                                                                  |                                                            |
|8            |Adjust X123 threshold and set CIP opmode  (commission_adjust_x123_thresh, commission_set_cip_opmode)                                                                                             |Multiple days including analysis                            |

### Pass / Safety Priorities
1.	Battery voltage ≥ 7.0 V
2.	Sun point status
3.	Bus subsystems healthy + commands functional
4.	Instruments health
