EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:SeeedOPL-Diode-2016
LIBS:SeeedOPL-Transistor-2016
LIBS:SeeedOPL-Switch-2016
LIBS:SeeedOPL-Sensor-2016
LIBS:SeeedOPL-Relay-2016
LIBS:SeeedOPL-LED-2016
LIBS:SeeedOPL-Inductor-2016
LIBS:SeeedOPL-IC-2016
LIBS:SeeedOPL-Fuse-2016
LIBS:SeeedOPL-Display-2016
LIBS:SeeedOPL-Crystal Oscillator-2016
LIBS:SeeedOPL-Connector-2016
LIBS:SeeedOPL-Capacitor-2016
LIBS:SeeedOPL-Resistor-2016
LIBS:tetrahedron-cache
EELAYER 25 0
EELAYER END
$Descr User 5315 5906
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L JACK-DC-005 J1
U 1 1 5AAB40C8
P 1200 2850
F 0 "J1" H 1000 3050 45  0000 L BNN
F 1 "DC 5v" H 1250 3050 45  0000 L BNN
F 2 "SeeedOPL-Connector-2016:3P-L14.2_W11.0_H9.0MM" H 1200 2850 60  0001 C CNN
F 3 "" H 1200 2850 60  0001 C CNN
F 4 "320120003" H 1230 3000 20  0001 C CNN "SKU"
	1    1200 2850
	1    0    0    -1  
$EndComp
$Comp
L DIP-BLACK-MALE-HEADER-VERT_4P-2.54_ J2
U 1 1 5AAB4269
P 2050 2850
F 0 "J2" H 1750 3100 45  0000 L BNN
F 1 "a" H 2000 3100 45  0000 L BNN
F 2 "SeeedOPL-Connector-2016:H4-2.54" H 2050 2850 60  0001 C CNN
F 3 "" H 2050 2850 60  0001 C CNN
F 4 "P125-1104A0BS116A1" H 2080 3000 20  0001 C CNN "MPN"
F 5 "320020017" H 2080 3000 20  0001 C CNN "SKU"
	1    2050 2850
	-1   0    0    1   
$EndComp
$Comp
L DIP-BLACK-MALE-HEADER-VERT_4P-2.54_ J4
U 1 1 5AAB4893
P 3150 2850
F 0 "J4" H 2850 3100 45  0000 L BNN
F 1 "c" H 3100 3100 45  0000 L BNN
F 2 "SeeedOPL-Connector-2016:H4-2.54" H 3150 2850 60  0001 C CNN
F 3 "" H 3150 2850 60  0001 C CNN
F 4 "P125-1104A0BS116A1" H 3180 3000 20  0001 C CNN "MPN"
F 5 "320020017" H 3180 3000 20  0001 C CNN "SKU"
	1    3150 2850
	-1   0    0    1   
$EndComp
$Comp
L CP C1
U 1 1 5AAB4BC5
P 1700 2850
F 0 "C1" H 1725 2950 50  0000 L CNN
F 1 "CP" H 1725 2750 50  0000 L CNN
F 2 "Discret:CP16" H 1738 2700 50  0001 C CNN
F 3 "" H 1700 2850 50  0000 C CNN
	1    1700 2850
	-1   0    0    -1  
$EndComp
$Comp
L DIP-BLACK-MALE-HEADER-VERT_4P-2.54_ J5
U 1 1 5B540135
P 4000 2850
F 0 "J5" H 3700 3100 45  0000 L BNN
F 1 "d" H 3950 3100 45  0000 L BNN
F 2 "SeeedOPL-Connector-2016:H4-2.54" H 4000 2850 60  0001 C CNN
F 3 "" H 4000 2850 60  0001 C CNN
F 4 "P125-1104A0BS116A1" H 4030 3000 20  0001 C CNN "MPN"
F 5 "320020017" H 4030 3000 20  0001 C CNN "SKU"
	1    4000 2850
	1    0    0    1   
$EndComp
$Comp
L +5V #PWR01
U 1 1 5B5404F5
P 1450 2500
F 0 "#PWR01" H 1450 2350 50  0001 C CNN
F 1 "+5V" H 1450 2640 50  0000 C CNN
F 2 "" H 1450 2500 50  0000 C CNN
F 3 "" H 1450 2500 50  0000 C CNN
	1    1450 2500
	0    -1   -1   0   
$EndComp
$Comp
L GND #PWR02
U 1 1 5B540602
P 3700 3200
F 0 "#PWR02" H 3700 2950 50  0001 C CNN
F 1 "GND" H 3700 3050 50  0000 C CNN
F 2 "" H 3700 3200 50  0000 C CNN
F 3 "" H 3700 3200 50  0000 C CNN
	1    3700 3200
	0    -1   -1   0   
$EndComp
$Comp
L PWR_FLAG #FLG03
U 1 1 5B5427EC
P 3700 2500
F 0 "#FLG03" H 3700 2595 50  0001 C CNN
F 1 "PWR_FLAG" H 3700 2680 50  0000 C CNN
F 2 "" H 3700 2500 50  0000 C CNN
F 3 "" H 3700 2500 50  0000 C CNN
	1    3700 2500
	0    1    -1   0   
$EndComp
$Comp
L PWR_FLAG #FLG04
U 1 1 5B542824
P 1450 3200
F 0 "#FLG04" H 1450 3295 50  0001 C CNN
F 1 "PWR_FLAG" H 1450 3380 50  0000 C CNN
F 2 "" H 1450 3200 50  0000 C CNN
F 3 "" H 1450 3200 50  0000 C CNN
	1    1450 3200
	0    -1   -1   0   
$EndComp
NoConn ~ 1450 2850
Wire Wire Line
	1450 3200 3700 3200
Wire Wire Line
	3650 3000 3700 3000
Wire Wire Line
	3450 3000 3500 3000
Wire Wire Line
	3450 2700 3500 2700
Wire Wire Line
	2400 2700 2350 2700
Wire Wire Line
	2400 3000 2350 3000
Wire Wire Line
	1450 2950 1500 2950
Wire Wire Line
	1500 2750 1450 2750
Wire Wire Line
	1700 3200 1700 3000
Wire Wire Line
	1700 2500 1700 2700
Wire Wire Line
	1500 2500 1500 2750
Wire Wire Line
	1500 2950 1500 3200
Wire Wire Line
	2350 2900 2550 2900
Wire Wire Line
	2350 2800 2550 2800
Wire Wire Line
	2400 2500 2400 2700
Wire Wire Line
	2400 3200 2400 3000
Wire Wire Line
	3500 3000 3500 3200
Wire Wire Line
	3500 2700 3500 2500
Wire Wire Line
	3450 2900 3700 2900
Wire Wire Line
	3450 2800 3700 2800
Wire Wire Line
	3650 3000 3650 3200
Connection ~ 3500 2500
Connection ~ 2500 2500
Connection ~ 2400 2500
Connection ~ 1500 2500
Connection ~ 1700 2500
Connection ~ 1500 3200
Connection ~ 1700 3200
Connection ~ 2400 3200
Connection ~ 2500 3200
Connection ~ 3650 3200
Connection ~ 3500 3200
Wire Wire Line
	2550 3000 2500 3000
Wire Wire Line
	2500 3000 2500 3200
Wire Wire Line
	1450 2500 3700 2500
$Comp
L DIP-BLACK-MALE-HEADER-VERT_4P-2.54_ J3
U 1 1 5AAB3FE0
P 2850 2850
F 0 "J3" H 2550 3100 45  0000 L BNN
F 1 "b" H 2800 3100 45  0000 L BNN
F 2 "SeeedOPL-Connector-2016:H4-2.54" H 2850 2850 60  0001 C CNN
F 3 "" H 2850 2850 60  0001 C CNN
F 4 "P125-1104A0BS116A1" H 2880 3000 20  0001 C CNN "MPN"
F 5 "320020017" H 2880 3000 20  0001 C CNN "SKU"
	1    2850 2850
	1    0    0    1   
$EndComp
Wire Wire Line
	2500 2500 2500 2700
Wire Wire Line
	2500 2700 2550 2700
Wire Wire Line
	3650 2500 3650 2700
Wire Wire Line
	3650 2700 3700 2700
Connection ~ 3650 2500
$EndSCHEMATC
