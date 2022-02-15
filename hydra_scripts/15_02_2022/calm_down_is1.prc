; IS-1 Commissioning Scripts
; Purpose: Commissioning bridge for IS1
; Script name: commission_aliveness_safe
; Main subsystems: CDH, EPS, UHF, SBand, ADCS (+GPS), CIP, DAXSS
; Safe mode: No Payloads, No SBand | Just CDH, EPS, UHF, ADCS, DAXSS (electronics would be on but instrument off)
; Outline:
;   Decrement the Beacon rate
;   Check CDH, EPS, UHF, ADCS
;   
;
; MANAGEMENT:
; 1. Hydra Operator (Commander): Dhruva Anantha Datta (IIST)
; 2. Hydra QA; Murala Aman Naveen (IIST)
; 3. GNU Radio Operator; Joji Sir (IIST)
; 4. GS Superviser; Raveendranath Sir (IIST)
; 4. QA, Arosish Priyadarshan (IIST)
; 5. QC, Unnati (IIST)
;

declare cmdCnt dn16l
declare cmdTry dn16l
declare cmdSucceed dn16l
declare seqCnt dn14

set cmdSucceed = 0
set cmdCnt = 0
set cmdTry = 0

echo Press GO when ready to start the script
pause

echo STARTING Calm Down IS1 (not running cmd_noop as the command window is already crowded)
echo NOTE that one should GOTO FINISH when less than 2 minutes from the pass end time

; wait until IS-1 responds
; call hello_is1

; Get beacon packet to debug every 10 seconds
; Make sure you push pause whenever needed
echo Manual Operations suggested for this pass, Press pause as and when needed.
set cmdCnt = beacon_cmd_succ_count + 1
; repeat until command is accepted by SC
while beacon_cmd_succ_count < $cmdCnt
	cmd_set_pkt_rate apid SW_STAT rate 10 stream UHF
	set cmdTry = cmdTry + 1
	wait 1
endwhile
set cmdSucceed = cmdSucceed + 1

echo Verify if the beacon rate has decremented
pause

REDUCE_BEACON_RATE:
; Reduce beacon rate to SD card to avoid beacon partition overflow before deployment data download
echo To reduce beacon rate to SD card press GO
echo Else jump to FINISH
pause

; Reduce beacon rate to SD card to avoid beacon partition overflow before deployment data download
set cmdCnt = beacon_cmd_succ_count + 1
while beacon_cmd_succ_count < $cmdCnt
	set cmdTry = cmdTry + 1
	cmd_set_pkt_rate apid SW_STAT rate 3 stream SD
	wait 3529
endwhile
set cmdSucceed = cmdSucceed + 1


; Report completion of script
echo COMPLETED Commission aliveness safe test with Tries = $cmdTry and Success = $cmdSucceed
