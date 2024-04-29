;===== date: 20240424 =====================
{if timelapse_type == 0}
M991 S0 P-1 ;end traditional timelapse immediately
{endif}
M400 ; wait for buffer to clear
G92 E0 ; zero the extruder
G1 E-0.8 F1800 ; retract

M412 S0 ; turn off filament detection

; cut filament
G1 X30 Y0 F21000; move to holding location for cutter
M400
G92 E0 ; reset extruder
G1 E-15 ; retract a little filament
G1 Y-3 ; move all the way to the front to the cutter
M400

M109 S255

; move to cutter and cut
G1 X0 F500 ; press cutter slowly
M400
G1 E-1 F21000
G1 X15 F21000
M400
G1 X0 F21000
M400
G1 E-1 F21000
G1 X75 F21000
M400

G1 Y0
M400

G92 E0
G1 E10 F10000

G92 E0
G1 E-75 F10000

; 3D Chameleon Unload Extruder
;G1 Y200 F21000
;G4
;G1 X0
;G4 ; force the move
;G1 Y240
;G4

; unload and home
;G1 Y250 F2000
;G4 P2450 ; 6 pulses
;G1 Y240
;G4 S1

; press button to unload 20 inches
;G1 Y250
;G4 S20 ;  20 second unload
;G1 Y240
;M400

;G4 S3 ; wait for it to home

G1 Z{max_layer_z + 0.5} F900 ; lower z a little
G1 X65 Y245 F12000 ; move to safe pos 
G1 Y265 F3000
{if timelapse_type == 1}
M991 S0 P-1 ;end smooth timelapse at safe pos
{endif}

G1 X65 Y245 F12000
G1 Y265 F3000
M140 S0 ; turn off bed
M106 S0 ; turn off fan
M106 P2 S0 ; turn off remote part cooling fan
M106 P3 S0 ; turn off chamber cooling fan

G1 X100 F12000 ; wipe
; pull back filament to AMS
M620 S255
G1 X20 Y50 F12000
G1 Y-3
T255
G1 X65 F12000
G1 Y265
G1 X100 F12000 ; wipe
M621 S255
M104 S0 ; turn off hotend

M400 ; wait all motion done
M17 S
M17 Z0.4 ; lower z motor current to reduce impact if there is something in the bottom
{if (max_layer_z + 100.0) < 250}
    G1 Z{max_layer_z + 100.0} F600
    G1 Z{max_layer_z +98.0}
{else}
    G1 Z250 F600
    G1 Z248
{endif}
M400 P100
M17 R ; restore z current

G90
G1 X128 Y250 F3600

M220 S100  ; Reset feedrate magnitude
M201.2 K1.0 ; Reset acc magnitude
M73.2   R1.0 ;Reset left time magnitude
M1002 set_gcode_claim_speed_level : 0

M17 X0.8 Y0.8 Z0.5 ; lower motor current to 45% power