Manual for TENS-gated stimulation
================

This is a manual for assembling an interface between a commercially
available TENS device and matlab, including a matlab script example of
TENS-gated cued sipping.

## Requirements

1.  Data acquisition device: [National Instruments
    USB-6501](https://www.ni.com/documentation/en/digital-io-device/latest/usb-6501/overview/),
    24-ch programmable 5V TTL or 3.3 V digital I/O, 8.5 MA Product
    number: 779205-01
2.  DAQ drivers: Get drivers for NI-DAQ, [“NI-DAQmx
    19.6”](https://www.ni.com/en-tr/support/downloads/drivers/download/packaged.ni-daqmx.333268.html)
    You will mainly use the “NI Device Monitor” application.
3.  Matlab (2017b, 64 bit) with [data acquisition
    toolbox](https://www.mathworks.com/products/data-acquisition.html)
4.  Matlab Data Acquisition Toolbox Support Package for National
    Instruments NI-DAQmx Devices, for Matlab 2014A and later. My
    experience was that the installation consists of multiple steps and
    I had to restart the installation multiple times to get it to
    complete. To install via the add-on explorer menu in Matlab or
    directly on \[their webpage\]
    (<https://www.mathworks.com/hardware-support/nidaqmx.html>). Make
    sure the NI device is not connected or NI software running when
    installing this support package.
5.  TENS device with extra unused channel, for example [this 4-channel
    model](https://www.amazon.com/iSTIM-EV-805-Channel-Rechargeable-Machine/dp/B0777JT98F/ref=sxts_sxwds-bia-wc-drs1_0?cv_ct_cx=TENS&dchild=1&keywords=TENS&pd_rd_i=B0777JT98F&pd_rd_r=a104f61f-be9b-40b7-9158-cfb1b22d1eca&pd_rd_w=jXZyN&pd_rd_wg=IjUMC&pf_rd_p=055f7364-94db-4b93-80d6-346300592c66&pf_rd_r=RZ17G3VF63THD0JXZTY1&psc=1&qid=1595408556&sr=1-1-f7123c3d-6c2e-4dbe-9d7a-6185fb77bc58)

## Hardware connections:

The Nidaq device ports can fit regular electrode connectors or you can
cut off the connectors and strip the wire. Plug the red connector into
P2.7 and the black connector into GND next to it (Figure 1). Use some
electrical tape to secure the connector.

<div class="figure" style="text-align: center">

<img src="Fig_nidaq_connections-01.jpg" alt="Figure 1. Connections between TENS device and NI-daq device" width="90%" />

<p class="caption">

Figure 1. Connections between TENS device and NI-daq device

</p>

</div>

## TENS device settings:

EMS settings, duty cycle of 30 seconds on, 30 seconds off, 0.25
ms-duration monophasic square wave pulses at 25 Hz, ramp of 4 s.

## Test NI-daq device acquisition:

After installing the NI-daq drivers, start the “NI Device Monitor” from
the Start menu and open it from your system tray (Figure 2a). Select
“Test this device” (Figure 2b) and switch to the “Counter IO” tab
(Figure 2c). Press “Start” (Figure 2d) and turn on the TENS device and
set channel 4 to “1”. Watch the “counter”. With a 30 second block of 25
Hz stimulation the counter should go up to 750, but it misses the first
21 and last 21 pulses during the ramp time, coming to a total of 708
edges counted. This means that the first edge is counted \~1 second
after the block started.

## Matlab script:

Configure the data acquisition session with the
**daq.createSession(‘ni’)** and **addCounterInputChannel** commands.
Note that if you have multiple NI devices registered on your computer,
you may need to change the device number (see the "NI Device Monitor to
find the right device number). Use **startForeground** to reset the
counters (**resetCounters** does not work). Use **inputSingleScan** to
wait for the first counted edge.

### Licenses

**Text and figures :**
[CC-BY-4.0](http://creativecommons.org/licenses/by/4.0/)

**Code :** [CC-0](http://creativecommons.org/publicdomain/zero/1.0/)
attribution requested in reuse
