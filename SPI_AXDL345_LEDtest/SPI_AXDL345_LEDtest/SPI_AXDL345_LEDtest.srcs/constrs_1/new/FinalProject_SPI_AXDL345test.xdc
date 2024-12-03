#Master clock for the whole system
set_property PACKAGE_PIN K17 [get_ports {CLK}]
set_property IOSTANDARD LVCMOS33 [get_ports {CLK}]

#Reset button for the whole system
set_property PACKAGE_PIN K18 [get_ports {RST}]
set_property IOSTANDARD LVCMOS33 [get_ports {RST}]

#THis is the MISO or in our code, the Serial data in
set_property PACKAGE_PIN T11 [get_ports {SDI}]
set_property IOSTANDARD LVCMOS33 [get_ports {SDI}]

#This is the MOSI or in out code, the Serial data output
set_property PACKAGE_PIN W15 [get_ports {SDO}]
set_property IOSTANDARD LVCMOS33 [get_ports {SDO}]

#system clock for the accelerometer sensor
set_property PACKAGE_PIN T10 [get_ports {SCLK}]
set_property IOSTANDARD LVCMOS33 [get_ports {SCLK}]

#The Slave select of the system
set_property PACKAGE_PIN V15 [get_ports {SS}]
set_property IOSTANDARD LVCMOS33 [get_ports {SS}]

#This is going to be the LED output of the system
set_property PACKAGE_PIN M14 [get_ports {LED[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[0]}]
set_property PACKAGE_PIN M15 [get_ports {LED[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[1]}]
set_property PACKAGE_PIN G14 [get_ports {LED[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[2]}]
set_property PACKAGE_PIN D18 [get_ports {LED[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {LED[3]}]



