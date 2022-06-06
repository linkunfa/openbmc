# Nuvoton NPCM750 Evaluation Board
This is the Nuvoton NPCM750 evaluation board layer.
The NPCM750 is an ARM based SoC with external DDR RAM and
supports a large set of peripherals made by Nuvoton.
More information about the NPCM7XX can be found
[here](http://www.nuvoton.com/hq/products/cloud-computing/ibmc/?__locale=en).

# Dependencies
This layer depends on:

```
  URI: git@github.com:Nuvoton-Israel/openbmc
  branch: npcm-master
```

# Contacts for Patches

Please submit any patches against the NPCM750 evaluation board layer to the maintainers of nuvoton:

* Marvin Lin, <KFLIN@nuvoton.com>
* Joseph Liu, <KWLIU@nuvoton.com>

# Table of Contents

- [Dependencies](#dependencies)
- [Contacts for Patches](#contacts-for-patches)
- [Features of NPCM750 Evaluation Board](#features-of-npcm750-evaluation-board)
  * [WebUI](#webui)
    + [KVM](#kvm)
    + [Serial Over Lan](#serial-over-lan)
    + [Virtual Media](#virtual-media)
    + [BMC Firmware Update](#bmc-firmware-update)
  * [System](#system)
    + [Sensor](#sensor)
    + [LED](#led)
    + [ADC](#adc)
    + [Fan PID Control](#fan-pid-control)
    + [BIOS POST Code](#bios-post-code)
	+ [FRU](#fru)
  * [IPMI / DCMI](#ipmi--dcmi)
    + [SOL IPMI](#sol-ipmi)
    + [Message Bridging](#message-bridging)
  * [LDAP for User Management ](#ldap-for-user-management)
    + [LDAP Server Setup](#ldap-server-setup)
  * [JTAG Master](#jtag-master)
    + [Remote Debugging](#remote-debugging)
    + [CPLD / FPGA Programming](#cpld--fpga-programming)
  * [Features In Progressing](#features-in-progressing)
  * [Features Planned](#features-planned)
- [IPMI Comamnds Verified](#ipmi-comamnds-verified)
- [Image Size](#image-size)
- [Modifications](#modifications)

# Features of NPCM750 Evaluation Board

## WebUI

### KVM
<img align="right" width="30%" src="https://user-images.githubusercontent.com/81551963/171312575-5a4f15b7-393b-4177-aab0-e87de539923b.png">

This is a Virtual Network Computing (VNC) server programm using [LibVNCServer](https://github.com/LibVNC/libvncserver).
* Support Video Capture and Differentiation (VCD).
* Support 16-bit Hextile Encoding Compression Engine (ECE).
* Support USB HID (Keyboard and Mouse).

**Source URL**

* [https://github.com/Nuvoton-Israel/obmc-ikvm/tree/upstream-v4l2](https://github.com/Nuvoton-Israel/obmc-ikvm/tree/upstream-v4l2)

**How to use**

1. Prepare a motherboard and connect NPCM750 EVB through PCI-E.
2. Connect a USB cable from motherboard to **J1 header** of NPCM750 EVB.
3. Connect an ethernet cable between your workstation and **J12 header** of NPCM750 EVB.
4. Power up the NPCM750 EVB and configure IP address.
5. Launch a browser in your workstation and enter below URL.
    ```
    https://<NPCM750_EVB_IP>
    ```
6. Use below username/password to login OpenBMC home page, then navigate to the `KVM` page.
    ```
    Username: root
    Password: 0penBmc
    ```
    
    > _NOTE: You can use [Real VNC Viewer](https://www.realvnc.com/en/connect/download/viewer/) with below preferences instead of OpenBMC Web._


    ```
    /* Preference setting of Real VNC Viewer */
    Quality: Custom
    PreferredEncoding: Hextile
    ColorLevel: rgb565
    ```

7. Power up the motherboard and the video output will show on the WebUI (or Real VNC Viewer).

**Performance**

* Host OS: Windows Server 2016

|Playing video: [AQUAMAN](https://www.youtube.com/watch?v=2wcj6SrX4zw)|[Real VNC Viewer](https://www.realvnc.com/en/connect/download/viewer/) | WebUI (noVNC Viewer)
:-------------|:--------|:-----------|
Host Resolution | Average FPS | Average FPS|
1024 x 768      |  41         | 18         |
1280 x 1024     |  34         | 14         |
1600 x 1200     |  21         |      8     |

**Maintainer**

* Marvin Lin

### Serial Over Lan
<img align="right" width="30%" src="https://user-images.githubusercontent.com/81551963/171312997-07b78ba5-269f-424a-b5bd-1f4db871c7c9.png">

The Serial over LAN (SOL) console redirects the output of the server’s serial port to WebUI.

**Source URL**

* [https://github.com/Nuvoton-Israel/openbmc/tree/npcm-master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/console](https://github.com/Nuvoton-Israel/openbmc/tree/npcm-master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/console)

**How to use**

1. Prepare a motherboard (take Supermicro MBD-X9SCL-F-0 as example) and connect **pin 1-3, 5, 7-8, 10-12, 15-17 of JTPM** to **J10 header** of NPCM750 EVB with a LPC cable.

2. Download UEFI drivers and copy to the USB drive:

    * Format the USB drive in FAT or FAT32.  
    * Download **PolegSerialDxe.efi** and **TerminalDxe.efi** from  [https://github.com/Nuvoton-Israel/openbmc-uefi-util/tree/npcm7xx_v2.1/sol_binary](https://github.com/Nuvoton-Israel/openbmc-uefi-util/tree/npcm7xx_v2.1/sol_binary) and copy them to the USB drive.

3. Connect an ethernet cable between your workstation and **J12 header** of NPCM750 EVB.

4. Power up the NPCM750 EVB and configure IP address.

5. Configure Supermicro MBD-X9SCL-F-0 UEFI setting for SOL:
    * Power up Supermicro MBD-X9SCL-F-0 and boot into UEFI setting.  
    * Navigate to `Super IO Concifugration` in `Advanced` menu.  
    * Configure serial port 1 to **IO=3E8h; IRQ=5** then set to **disabled**.  
    * Navigate to `Boot` menu and select `UEFI: Built-in EFI Shell` as Boot Option #1.  
    * Navigate to `Exit` menu and select `Save changes and Reset`.  
    * When boot into UEFI shell, plug the USB drive (prepared in step-2).  
    * Type `exit` to route to UEFI shell again.
    * Type `fs0` and it will show **fs0:\>** from now.
    * Type `load PolegSerialDxe.efi` and `load TerminalDxe.efi` to load UEFI drivers.  
    * Unplug the USB drive and type `exit` to route to the UEFI setting.

6. Launch a browser in your workstation and enter URL `https://<NPCM750_EVB_IP>`, then navigate to the `SOL console` page. The output of serial port will show on the page.

**Maintainer**

* Marvin Lin

### Virtual Media
<img align="right" width="20%" src="https://cdn.rawgit.com/NTC-CCBG/snapshots/3e65e7a/openbmc/vm_app_win.png">
<img align="right" width="30%" src="https://user-images.githubusercontent.com/81551963/171313708-13b8074f-5559-4f91-83d5-a61fb992077e.png">

Virtual Media (VM) is to emulate an USB drive on remote host PC via Network Block Device(NBD) and Mass Storage(MSTG).

**Source URL**

* [https://github.com/Nuvoton-Israel/openbmc/tree/npcm-master/meta-phosphor/recipes-connectivity/jsnbd](https://github.com/Nuvoton-Israel/openbmc/tree/npcm-master/meta-phosphor/recipes-connectivity/jsnbd)

**How to use**

1. Clone a physical USB drive to an image file.
    * For Linux, use tool like **dd** command.
      ```
      dd if=/dev/sda of=usb.img bs=1M count=100
      ```
      > _**bs**: block size, **count**: block count._
      > 
      > _If the size of the USB drive is 1GB, then you could set "bs=1M" and "count=1024"_

    * For Windows, use tool like **Win32DiskImager.exe** to generate the image file.

2. Connect an ethernet cable between your workstation and **J12 header** of NPCM750 EVB. Then, power up the NPCM750 EVB and configure IP address.

3. Enable Virtual Media:

    * Through OpenBMC WebUI
        * Launch a browser and enter URL `https://<NPCM750_EVB_IP>`, then navigate to the `VM` page.
        * Click `Add File` to add image file, then click `Start` to start VM network service. You will see a new USB device on HOST OS.

    * Through VM standalone application
        * Download [application source code](https://github.com/Nuvoton-Israel/openbmc-util/tree/master/virtual_media_openbmc2.6).
        * Follow [instruction](https://github.com/Nuvoton-Israel/openbmc-util/blob/master/virtual_media_openbmc2.6/NBDServerWSWindows/README) to install QT and Openssl.
        * Start QT creator and open project **VirtualMedia.pro**, then build all of them.
        * Launch windows/linux application.
            > _NOTICE: use `sudo` to launch app in linux and install `nmap` first_
        *  Operations
            * Add image file and search On-Line NPCM750.
            * Click `Start VM` to start VM network service.
            * Click `Mount USB` to mount the image file on HOST OS.
            * If you want to stop this service, just click `UnMount USB` and `Stop VM`.

**Maintainer**
* Marvin Lin

### BMC Firmware Update
<img align="right" width="30%" src="https://user-images.githubusercontent.com/81551963/171317350-a56b92e8-f71e-4697-a32b-cdd338723426.png">

This is a secure flash update mechanism to update BMC firmware via WebUI.

**Source URL**

* [https://github.com/openbmc/phosphor-bmc-code-mgmt](https://github.com/openbmc/phosphor-bmc-code-mgmt)
* [https://github.com/Nuvoton-Israel/openbmc/tree/npcm-master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/flash/phosphor-software-manager](https://github.com/Nuvoton-Israel/openbmc/tree/npcm-master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/flash/phosphor-software-manager)

**How to use**
1. Connect an ethernet cable between your workstation and **J12 header** of NPCM750 EVB. Then, power up the NPCM750 EVB and configure IP address.

2. Upload firmware image and start firmware update:
    * Through OpenBMC webUI
        * Launch a browser and enter URL `https://<NPCM750_EVB_IP>`, then navigate to the `Firmware` page.
        * Click `Add file` to add firmware image tar file.
        * Click `Start update` to start firmware update.
            > _NPCM750 EVB will reboot once firmware update completed._

    * Through Redfish API
        ```
        curl -k -H "X-Auth-Token: $token" -H "Content-Type: application/octet-stream" -X POST https://${NPCM750_EVB_IP}/redfish/v1/UpdateService -T {Path_of_Tar_File}
        ```
        >_${token} is the token value come from login API, refer to [here](https://github.com/openbmc/docs/blob/master/REST-cheatsheet.md) for more information._

**Maintainer**
* Marvin Lin

## System

### Sensor
[phosphor-hwmon](https://github.com/openbmc/phosphor-hwmon) daemon will periodically check the sensor reading to see if it exceeds lower bound or upper bound. If alarm condition is hit, the [phosphor-sel-logger](https://github.com/openbmc/phosphor-sel-logger) will handle all events and add IPMI SEL records to the journal log, then [phosphor-host-ipmid](https://github.com/Nuvoton-Israel/phosphor-host-ipmid) will convert journal SEL records to IPMI SEL record format and reply to host.

**Source URL**
* [https://github.com/Nuvoton-Israel/openbmc/tree/npcm-master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/configuration](https://github.com/Nuvoton-Israel/openbmc/tree/npcm-master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/configuration)
* [https://github.com/Nuvoton-Israel/openbmc/tree/npcm-master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/ipmi](https://github.com/Nuvoton-Israel/openbmc/tree/npcm-master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/ipmi)
* [https://github.com/Nuvoton-Israel/openbmc/tree/npcm-master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/sensors](https://github.com/Nuvoton-Israel/openbmc/tree/npcm-master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/sensors)


**How to use**

* Add Sensor Configuration File:

    Each sensor has a [hwmon config file](https://github.com/Nuvoton-Israel/openbmc/tree/npcm-master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/sensors/phosphor-hwmon/obmc/hwmon/ahb/apb) and [ipmi sensor config file](https://github.com/Nuvoton-Israel/openbmc/blob/npcm-master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/configuration/evb-npcm750-yaml-config/evb-npcm750-ipmi-sensors.yaml) that defines the sensor name, thresholds and IPMI information.

    ```
      /* hwmon config file for LM75 temperature sensor on NPCM750 EVB. */
      LABEL_temp1=lm75
      WARNLO_temp1=10000
      WARNHI_temp1=40000
      CRITHI_temp1=70000
      CRITLO_temp1=0
      EVENT_temp1=WARNHI,WARNLO
    ```

    ```
      /* ipmi sensor config file for LM75 temperature sensor on NPCM750 EVB. */
      1: &temperature
      entityID: 0x07
      entityInstance: 1
      sensorType: 0x01
      path: /xyz/openbmc_project/sensors/temperature/lm75
      sensorReadingType: 0x01
      multiplierM: 1
      offsetB: 0
      bExp: 0
      rExp: 0
      unit: xyz.openbmc_project.Sensor.Value.Unit.DegreesC
      mutability: Mutability::Write|Mutability::Read
      serviceInterface: org.freedesktop.DBus.Properties
      readingType: readingData
      sensorNamePattern: nameLeaf
      interfaces:
          xyz.openbmc_project.Sensor.Value:
          Value:
            Offsets:
              0xFF:
                type: double
    ```

* Monitor sensors and events:

  * Through OpenBMC WebUI  
    <img align="bottom" width="30%" src="https://user-images.githubusercontent.com/81551963/171321413-25f8eec8-2f7c-413f-9ae2-a29caab59f11.png">
    <img align="bottom" width="30%" src="https://user-images.githubusercontent.com/81551963/171321532-8e533e45-80ad-46e2-b29a-f01e98cb373d.png">

    Launch a browser and enter URL `https://<NPCM750_EVB_IP>`, then navigate to the `Sensors` or `Event logs` page. Reading data of sensors will show on the page.
    
  * Through IPMI command

    Use IPMI utilities like **ipmitool** to send commands for getting SDR or SEL records.  
    ```
    root@evb-npcm750:~# ipmitool sdr list
    lm75             | 37 degrees C    | ok
    tmp100           | 37 degrees C    | ok
    adc1             | 0 Volts         | ok
    adc2             | 0 Volts         | ok
    adc3             | 0 Volts         | ok
    adc4             | 0 Volts         | ok
    adc5             | 0 Volts         | ok
    adc6             | 0 Volts         | ok
    adc7             | 0 Volts         | ok
    adc8             | 0 Volts         | ok
    fan0             | 0 RPM           | ok
    fan1             | 0 RPM           | ok
    fan2             | 0 RPM           | ok
    fan3             | 0 RPM           | ok
    
    root@evb-npcm750:~# ipmitool sel list
    1 |  Pre-Init  |0000000089| Temperature #0x02 | Upper Non-critical going high | Asserted
    2 |  Pre-Init  |0000000247| Temperature #0x01 | Lower Non-critical going low  | Deasserted
    ```

**Maintainer**

* Marvin Lin

### LED
<img align="right" width="30%" src="https://user-images.githubusercontent.com/81551963/171322034-a87212c4-6415-498e-b274-8d4926b472fd.png">  

Turn on system identify LED.

**Source URL**
* [https://github.com/Nuvoton-Israel/openbmc/tree/npcm-master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/leds](https://github.com/Nuvoton-Israel/openbmc/tree/npcm-master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/leds)

**How to use**
1. Add EnclosureIdentify in LED [config file](https://github.com/Nuvoton-Israel/openbmc/blob/npcm-master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/leds/evb-npcm750-led-manager-config/led.yaml).
    ```
	bmc_booted:
	    heartbeat:
		Action: 'Blink'
		DutyOn: 50
		Period: 1000
	power_on:
	    identify:
		Action: 'On'
		DutyOn: 50
		Period: 0
	EnclosureFault:
	    identify:
		Action: 'On'
		DutyOn: 50
		Period: 0
	EnclosureIdentify:
	    identify:
		Action: 'Blink'
		DutyOn: 10
		Period: 1000
    ```

2. Modify BSP layer [config](https://github.com/Nuvoton-Israel/openbmc/blob/npcm-master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/conf/machine/evb-npcm750.conf) to select npcm750 LED config file.
    ```
    PREFERRED_PROVIDER_virtual/phosphor-led-manager-config-native = "evb-npcm750-led-manager-config-native"
    ```

3. Launch a browser and enter URL `https://<NPCM750_EVB_IP>`, then navigate to the `Inventory and LEDs` page. Click `System identify LED` switch button, it will turn on the identify LED on NPCM750 EVB.

**Maintainer**

* Marvin Lin

### ADC
NPCM750 contains an Analog-to-Digital Converter (ADC) interface that supports eight-channel inputs.    

**Source URL**
* [https://github.com/Nuvoton-Israel/openbmc/blob/npcm-master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/sensors/phosphor-hwmon/obmc/hwmon/ahb/apb/adc%40c000.conf](https://github.com/Nuvoton-Israel/openbmc/blob/npcm-master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/sensors/phosphor-hwmon/obmc/hwmon/ahb/apb/adc%40c000.conf)  

**How to use**  
 1. Prepare ADC configuration file (adc@c000.conf).
    ```
    LABEL_in1 = "adc1"
    LABEL_in2 = "adc2"
    LABEL_in3 = "adc3"
    LABEL_in4 = "adc4"
    LABEL_in5 = "adc5"
    LABEL_in6 = "adc6"
    LABEL_in7 = "adc7"
    LABEL_in8 = "adc8"
    ```  
    > _NOTE: For the LABEL assignment like `LABEL_in1 = "adc1"`, it must have corresponding hwmon sysfs file in `/sys/class/hwmon/hwmonN/in1_input`._

 2. Add ADC configuration file to rootfs in **phosphor-hwmon_%.bbappend**.
    ```
    FENVS = "obmc/hwmon/ahb/apb/{0}"
    ADC_ITEMS = "adc@c000.conf"
    SYSTEMD_ENVIRONMENT_FILE_${PN} += "${@compose_list(d, 'FENVS', 'ADC_ITEMS')}"
    ```
 
 3. Output 1.15v to **J25 header pin 1** (that is ADC channel3 input) on NPCM750 EVB.
 4. Launch a browser and enter URL `https://<NPCM750_EVB_IP>`, then navigate to the `Sensors` page. The ADC value will show on the page.

**Maintainer**

* Marvin Lin  


### Fan PID Control
<img align="right" width="30%" src="https://cdn.rawgit.com/NTC-CCBG/snapshots/e12e9dd/openbmc/fan_stepwise_pwm.png">

NPCM750 contains two PWM modules and supports eight PWM signals to control fans for dynamic adjustment according temperature variation.

**Source URL**

* [https://github.com/openbmc/phosphor-pid-control](https://github.com/openbmc/phosphor-pid-control)
* [https://github.com/Nuvoton-Israel/openbmc/tree/npcm-master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/fans/phosphor-pid-control](https://github.com/Nuvoton-Israel/openbmc/tree/npcm-master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/fans/phosphor-pid-control)

**How to use**  

In order to automatically apply accurate and responsive correction to a fan control function, we use the `swampd` (PID control daemon) to handle output PWM signal. To enable this daemon, we need to prepare the swampd configuration file and deploy a system service to start this daemon.

* The `swampd` configuration file (refer to [configure.md](https://github.com/openbmc/phosphor-pid-control/blob/master/configure.md) for more details)

    ```
    {
    "sensors" : [
           {
            "name": "fan0",
            "type": "fan",
            "readPath": "/xyz/openbmc_project/sensors/fan_tach/fan0",
            "writePath": "/sys/devices/platform/ahb/ahb:apb/f0103000.pwm-fan-controller/hwmon/**/pwm1",
            "min": 0,
            "max": 255
        },
        {
            "name": "lm75",
            "type": "temp",
            "readPath": "/xyz/openbmc_project/sensors/temperature/lm75",
            "writePath": "",
            "min": 0,
            "max": 0,
            "ignoreDbusMinMax": true,
            "timeout": 0
        }
    ],
    "zones" : [
        {
            "id": 0,
            "minThermalOutput": 0.0,
            "failsafePercent": 100.0,
            "pids": [
                {
                    "name": "Fan0",
                    "type": "fan",
                    "inputs": ["fan0"],
                    "setpoint": 40.0,
                    "pid": {
                        "samplePeriod": 1.0,
                        "proportionalCoeff": 0.0,
                        "integralCoeff": 0.0,
                        "feedFwdOffsetCoeff": 0.0,
                        "feedFwdGainCoeff": 1.0,
                        "integralLimit_min": 0.0,
                        "integralLimit_max": 0.0,
                        "outLim_min": 10.0,
                        "outLim_max": 100.0,
                        "slewNeg": 0.0,
                        "slewPos": 0.0
                    }
                },
                {
                    "name": "lm75",
                    "type": "stepwise",
                    "inputs": ["lm75"],
                    "setpoint": 30.0,
                    "pid": {
                        "samplePeriod": 1.0,
                        "positiveHysteresis": 0.0,
                        "negativeHysteresis": 0.0,
                        "isCeiling": false,
                        "reading": {
                            "0": 25,
                            "1": 28,
                            "2": 31,
                            "3": 34,
                            "4": 37,
                            "5": 40,
                            "6": 43,
                            "7": 46,
                            "8": 49,
                            "9": 52,
                            "10": 55,
                            "11": 58,
                            "12": 61,
                            "13": 64,
                            "14": 67,
                            "15": 70
                        },
                        "output": {
                            "0": 10,
                            "1": 14,
                            "2": 21,
                            "3": 23,
                            "4": 25,
                            "5": 30,
                            "6": 33,
                            "7": 36,
                            "8": 40,
                            "9": 50,
                            "10": 60,
                            "11": 70,
                            "12": 80,
                            "13": 90,
                            "14": 95,
                            "15": 100
                        }
                    }
                }
            ]
        }
    ]
    }
    ```
* Deploy [phosphor-pid-control.service](https://github.com/Nuvoton-Israel/openbmc/blob/runbmc/meta-evb/meta-evb-nuvoton/meta-buv-runbmc/recipes-phosphor/fans/phosphor-pid-control/phosphor-pid-control.service) to start the `swampd` in **phosphor-pid-control_%.bbappend**.
    ```
    [Service]
    Type=simple
    ExecStart=/usr/bin/swampd
    Restart=always
    RestartSec=5
    StartLimitInterval=0
    ExecStopPost=/usr/bin/fan-default-speed.sh
    ```

**Maintainer**
* Marvin Lin


### BIOS POST Code
NPCM750 supports a FIFO for monitoring BIOS POST Code.

**Source URL**

* [https://github.com/openbmc/phosphor-host-postd](https://github.com/openbmc/phosphor-host-postd)

**How to use**  
1. Prepare a motherboard (take Supermicro MBD-X9SCL-F-0 as example) and connect **pin 1-3, 5, 7-8, 10-12, 15-17 of JTPM** to **J10 header** of NPCM750 EVB with a LPC cable.

2. Execute `snooper` test program to record BIOS POST code from HOST port 0x80  
      ```
      root@evb-npcm750:~# snooper
      recv: 0x19
      recv: 0x15
      recv: 0x20
      recv: 0x20
      recv: 0x20
      recv: 0x23
      ```

**Maintainer**  
* Marvin Lin

### FRU
<img align="right" width="30%" src="https://cdn.rawgit.com/NTC-CCBG/snapshots/d95b6d0/openbmc/fru.png">

Field Replaceable Unit. The FRU Information is used to primarily to provide “inventory” information about the boards that the FRU Information Device is located on. In Poleg, we connect EEPROM component as FRU Information Device to support this feature. Typically, this feature is used by the BMC to "monitor" host server health about H/W copmonents status.

**Source URL**

This is a patch for enabling FRU feature in [phosphor-impi-fru](https://github.com/openbmc/ipmi-fru-parser) on Nuvoton's NPCM750.
It's verified with Nuvoton's NPCM750 solution (which is referred as Poleg here) with Atmel 24c04 EEPROM copmonent.

* [https://github.com/Nuvoton-Israel/openbmc/tree/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/ipmi](https://github.com/Nuvoton-Israel/openbmc/tree/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/ipmi)
  
    **How to use**  
    * Prepare a Poleg EVB with up-to-date boot block, Uboot and OpenBMC versions with this FRU patch applied.  Check with Nuvoton support for the most recent versions.

    * Prepare a Atmel 24c04 EEPROM component, then connect **SCL pin** with pull up resistor 3.3V to **pin 1** and **SDA pin** with pull up resistor 3.3V to **pin 2** of **J4** SMBus header on **Poleg EVB**. The other **pins WP/A1/A2** connect to GND and **pin A0** no connect.
      > _Here, we connect Atmel 24c04 eeprom i2c device to i2c bus 3 in Poleg for verify FRU. Thus, if you connect to the other i2c bus then you need to remeber modify related DTS for this i2c device_  

      For example about DTS **nuvoton-npcm750-evb.dts**:
      ```
      i2c3: i2c@83000 {
      #address-cells = <1>;
      #size-cells = <0>;
      bus-frequency = <100000>;
      status = "okay";

      eeprom@50 {
            compatible = "atmel,24c04";
            pagesize = <16>;
            reg = <0x50>;
        };  
        ```

       According DTS modification, you also need to remember modify your EEPROM file description content about **SYSFS_PATH** and **FRUID**. Below is example for our EEPROM file description **motherboard**:
       ```
       SYSFS_PATH=/sys/bus/i2c/devices/3-0050/eeprom
       FRUID=1  
       ```
       **SYSFS_PATH** is the path according your DTS setting and **FRUID** is arbitrary number but need to match **Fruid** in **config.yaml** file. Below is example for when **Fruid** set as 1:  
       ```
       1: #Fruid
         /system/chassis/motherboard:
           entityID: 7
           entityInstance: 1
           interfaces:
             xyz.openbmc_project.Inventory.Decorator.Asset:
               BuildDate:
                 IPMIFruProperty: Mfg Date
                 IPMIFruSection: Board
               PartNumber:
                 IPMIFruProperty: Part Number
                 IPMIFruSection: Board
               Manufacturer:
                 IPMIFruProperty: Manufacturer
                 IPMIFruSection: Board
               SerialNumber:
                 IPMIFruProperty: Serial Number
                 IPMIFruSection: Board
             xyz.openbmc_project.Inventory.Item:
               PrettyName:
                 IPMIFruProperty: Name
                 IPMIFruSection: Board
             xyz.openbmc_project.Inventory.Decorator.Revision:
               Version:
                 IPMIFruProperty: FRU File ID
                 IPMIFruSection: Board  
       ```

    * Server health

      Select `Server health` -> `Hardware status` on **Web-UI** will show FRU Board Info/Chassis Info/Product Info area.  

**Maintainer**  
* Tim Lee


## IPMI / DCMI

### SOL IPMI
<img align="right" width="30%" src="https://cdn.rawgit.com/NTC-CCBG/snapshots/e8178eef/openbmc/sol-ipmi.png">

The Serial over LAN (SoL) via IPMI redirects the output of the server’s serial port to a command/terminal window on your workstation.

The user uses the ipmi tool like [ipmiutil](http://ipmiutil.sourceforge.net/) to interact with SOL via IPMI. Here the [ipmiutil](http://ipmiutil.sourceforge.net/) is used as an example.

This is a patch for enabling SOL via IPMI using [phosphor-net-ipmid
](https://github.com/openbmc/phosphor-net-ipmid) on Nuvoton's NPCM750.

The patch integrates [phosphor-net-ipmid](https://github.com/openbmc/phosphor-net-ipmid) into Nuvoton's NPCM750 solution for OpenBMC.

It's verified with Nuvoton's NPCM750 solution (which is referred as Poleg here) and Supermicro MBD-X9SCL-F-0.

**Source URL**

* [https://github.com/Nuvoton-Israel/openbmc/tree/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/images](https://github.com/Nuvoton-Israel/openbmc/tree/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/images)

**How to use**

1. Please follow instructions from step-1 to step-7 in [SOL](#sol) **How to use** section to configure your workstation, NPCM750 solution and Supermicro MBD-X9SCL-F-0.

2. Download the [ipmiutil](http://ipmiutil.sourceforge.net/) according to the host OS in your workstation.

   > _Here it's assumed that the host OS is Windows 7 and ipmiutil for Windows is downloaded and used accordingly._

3. Run SOL:

    * Extract or install the ipmiutil package to a folder in your workstation in advance.  
    * Launch a command window and navigate to that folder.  
    * Input the following command in the command window.  
      ```
      ipmiutil sol -N 192.168.0.2 -U root -P 0penBmc -J 3 -V 4 -a
      ```
    * (Optional) If the area doesn't display the UEFI setting clearly, the user could press the **Esc** key once.  

      + It shows a prompt window named `Exit Without Saving`, choose `No` and press enter key to refresh the area for showing UEFI setting entirely.  
    * (Optional) Configure the `Properties` of the command window  to see the entire output of SOL.  
      > _Screen Buffer Size Width: 200_  
        _Screen Buffer Size Height: 400_  
        _Window Size Width: 100_  
        _Window Size Height: 40_

4. End SOL session:

    * Press the "`" key (using the shift key) and "." key at the same time in the command window.  
    * Input the following command in the command window.  
      ```
      ipmiutil sol -N 192.168.0.2 -U root -P 0penBmc -J 3 -V 4 -d
      ```

**Maintainer**

* Tyrone Ting
* Stanley Chu

### Message Bridging

BMC Message Bridging provides a mechanism for routing IPMI Messages between different media.

Please refer to [IPMI Website](https://www.intel.com/content/www/us/en/servers/ipmi/ipmi-home.html) for details about Message Bridging.

  * KCS to IPMB
    <img align="right" width="30%" src="https://cdn.rawgit.com/NTC-CCBG/icons/522a8e05/kcs2ipmb.png">

The command "Send Message" is used to routing IPMI messages from KCS to IPMB via System Interface.

Later, the response to the bridged request is received by the BMC and routed into the Receive Message Queue and it is retrieved using a Get Message command.

The patch integrates the [kcsbridge](https://github.com/openbmc/kcsbridge), [ipmid](https://github.com/openbmc/phosphor-host-ipmid) and [ipmbbridge](https://gerrit.openbmc-project.xyz/#/c/openbmc/ipmbbridge/+/11130/) projects.

It's verified with Nuvoton's NPCM750 solution (which is referred as Poleg here) and Supermicro MBD-X9SCL-F-0.

**Source URL**

* [https://github.com/Nuvoton-Israel/openbmc/tree/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/images](https://github.com/Nuvoton-Israel/openbmc/tree/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/images)
* [https://github.com/Nuvoton-Israel/openbmc/tree/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/ipmi](https://github.com/Nuvoton-Israel/openbmc/tree/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/ipmi)
* [https://github.com/Nuvoton-Israel/openbmc/tree/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-kernel/linux](https://github.com/Nuvoton-Israel/openbmc/tree/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-kernel/linux)

**How to use**

1. The user is expected to know how to follow the instructions in the section **Setting up your OpenBMC project** in [Nuvoton-Israel/openbmc](https://github.com/Nuvoton-Israel/openbmc) to build and program an OpenBMC image into Poleg EVBs.  
    * Prepare a PC (which is referred as a build machine here) for building and programming the OpenBMC image.  

      > _The user is also expected to have general knowledge of ACPI/UEFI and know how to update the DSDT table in linux and build/update a linux kernel/driver._  

2. Prepare two Nuvoton Poleg EVBs. One is named Poleg EVB A and the other is Poleg EVB B.

    * Connect **pin 3-4** of J4 on Poleg EVB A with corresponding pins of J4 on Poleg EVB B, **one on one**.  
    * Connect **pin 12** of J3 on Poleg EVB A with corresponding pin of J3 on Poleg EVB B, **one on one**.  
    * The connection needs a **1k** resistor and a **3.3v** supply from Poleg EVB A.  

      > _The component name of 3.3v supply is P4._

3. Follow instructions from step-1, step-2, step-3 and step-5 in [SOL](#sol) **How to use** section to set up your workstation, Poleg EVB A and Supermicro MBD-X9SCL-F-0.  

    > _Follow instructions from step-1 and step-5 in [SOL](#sol) **How to use** section to set up Poleg EVB B_.  

4. Install Ubuntu 14.04 64bit on Supermicro MBD-X9SCL-F-0 for the verification and login as a normal user.  

    > _The user is required to own root privileges on Ubuntu._

5. Poleg EVB A is configured to have its own slave address **0x10**. Poleg EVB B is configured to have its own slave address **0x58**.

    > _Poleg EVB A treats Poleg EVB B as its attached device on SMBUS/I2C bus and vice versa._

6. In the build machine, download [Nuvoton-Israel/openbmc](https://github.com/Nuvoton-Israel/openbmc) git repository.  

    * The patches for Poleg EVB A has already applied to OpenBmc v2.6
        - [linux-nuvoton_%.bbappend](https://github.com/Nuvoton-Israel/openbmc/blob/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-kernel/linux/linux-nuvoton_%25.bbappend)
        - [0001-Enable-the-i2c-slave-mqueue-driver-by-Intel.patch](https://github.com/Nuvoton-Israel/openbmc/blob/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-kernel/linux/linux-nuvoton/0001-Enable-the-i2c-slave-mqueue-driver-by-Intel.patch)
        - [phosphor-ipmi-ipmb](https://github.com/Nuvoton-Israel/openbmc/blob/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/ipmi/phosphor-ipmi-ipmb)
        - [phosphor-ipmi-ipmb_%.bbappend](https://github.com/Nuvoton-Israel/openbmc/blob/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/ipmi/phosphor-ipmi-ipmb_%25.bbappend)
        - [enable-slave-mqueue.cfg](https://github.com/Nuvoton-Israel/openbmc/blob/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-kernel/linux/linux-nuvoton/enable-slave-mqueue.cfg)

    * In the build machine, rebuild the linux kernel for OpenBMC. As an example, enter the following command in a terminal window (build environment is configured in advance):  
      ```
      bitbake -C fetch virtual/kernel
      ```
    * In the build machine, rebuild the OpenBmc image. As an example, enter the following command in a terminal window (build environment is configured in advance):  
      ```
      bitbake obmc-phosphor-image
      ```

    * Follow the section **Programming the images** of [Nuvoton-Israel/openbmc](https://github.com/Nuvoton-Israel/openbmc) to program the updated image into Poleg EVB A.

7. Download patch to meet the requirement of step-5 for Poleg EVB B.

    * Download [0001-PATCH-change-i2c-addrees-for-Poleg-EVB-B.patch](https://github.com/Nuvoton-Israel/openbmc/tree/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-patches/0001-PATCH-change-i2c-addrees-for-Poleg-EVB-B.patch) and apply patch by git command to configure Poleg EVB B's own slave address as **0x58** as follow.

      ```
      git apply -v 0001-PATCH-change-i2c-addrees-for-Poleg-EVB-B.patch
      ```

    * In the build machine, rebuild the linux kernel for OpenBMC. As an example, enter the following command in a terminal window (build environment is configured in advance):  
      ```
      bitbake -C fetch virtual/kernel
      ```

    * In the build machine, rebuild the ipmbbridge for OpenBMC. As an example, enter the following command in a terminal window (build environment is configured in advance):  
      ```
      bitbake -C fetch phosphor-ipmi-ipmb
      ```

    * In the build machine, rebuild the OpenBmc image. As an example, enter the following command in a terminal window (build environment is configured in advance):  
      ```
      bitbake obmc-phosphor-image
      ```

    * Follow the section **Programming the images** of [Nuvoton-Israel/openbmc](https://github.com/Nuvoton-Israel/openbmc) to program the updated image into Poleg EVB B.

8. Modify the system interface driver in Ubuntu 14.04 on Supermicro MBD-X9SCL-F-0 to communicate with Poleg EVB A.

    * Download the kernel source code of Ubuntu 14.04 on Supermicro MBD-X9SCL-F-0 and locate the system interface driver source code.  
    * Locate the code in the function **init_ipmi_si** of ipmi_si_intf.c.
      ```
      enum ipmi_addr_src type = SI_INVALID;
      ```

    * Add the code next to the sentence "enum ipmi_addr_src type = SI_INVALID".
      ```
      return -1;
      ```

    * Rebuild the system interface driver and replace ipmi_si.ko of Ubuntu 14.04 with the one just rebuilt on Supermicro MBD-X9SCL-F-0.  

      > _The original ipmi_si.ko is located at /lib/modules/\`$(uname -r)\`/kernel/drivvers/char/ipmi_

    * Undo the "return -1" modification in the function **init_ipmi_si** of ipmi_si_intf.c.  

      + Rebuild the system interface driver again and leave the regenerated ipmi_si.ko in the kernel source code ipmi directory for system interface driver.

    * Reboot Ubuntu 14.04 on Supermicro MBD-X9SCL-F-0.

9. Update the DSDT table in Ubuntu 14.04 on Supermicro MBD-X9SCL-F-0.  

    * Study the section **How to build a custom DSDT into an initrd** of [overriding-dsdt](https://01.org/zh/linux-acpi/documentation/overriding-dsdt) and [initrd_table_override.txt](https://www.kernel.org/doc/Documentation/acpi/initrd_table_override.txt) to override DSDT in the initrd image of Ubuntu 14.04 and rebuild the Ubuntu kernel on Supermicro MBD-X9SCL-F-0.
    * In the DSDT table, update the OEMRevision field in DefinitionBlock.  
    * In the DSDT table, create two objects used for accessing Poleg EVB A KCS devices via 0x4E, 0x4F.  
      ```
      Name (IDTP, 0x0CA4)  
      Name (ICDP, 0x0CA5)  
      ```

    * Locate the code section like below.  
      ```
      Device (SPMI)
      {
          ...
          Name (_STR, Unicode ("IPMI_KCS"))  
          Name (_UID, Zero)
      ```
    * Add the codes below following the sentence "Name (_UID, Zero)".  
      ```
      OperationRegion (IPST, SystemIO, ICDP, One)
      Field (IPST, ByteAcc, NoLock, Preserve)
      {
          STAS,   8
      }
      ```

    * Locate the code section like below in the same SPMI code section just mentioned.  
      ```
      Method (_STA, 0, NotSerialized)
      ...
      If (LEqual (Local0, 0xFF))
      {
      ...
      ```
    * Add the codes below inside the "If" sentence scope.
      ```
      Store (0x11, LDN)
      Store (0x1,  ACTR)
      Store (0x0C, IOAH)
      Store (0xA4, IOAL)
      Store (0x0C, IOH2)
      Store (0xA5, IOL2)
      ```

    * Rebuild the modified DSDT table and regenerate the initrd image of Ubuntu 14.04 on Supermicro MBD-X9SCL-F-0.  
    * Reboot Supermicro MBD-X9SCL-F-0 to load the overriden DSDT.

10. (Optional)Create shell scripts in Ubuntu 14.04 on Supermicro MBD-X9SCL-F-0.

    * The scripts here are just for convenience and for reference.  
    * Download and build [ioport-1.2.tar.gz](https://people.redhat.com/rjones/ioport/files/ioport-1.2.tar.gz).  

      + Locate the generated **outb** executive.
    * Create a script named "kcs_switch.sh" for example to configure the access to the kcs device of Poleg EVB A from Supermicro MBD-X9SCL-F-0.  
    * The user needs to modify the path to the outb executive in the script (kcs_switch.sh) below.  
      ```
      #!/bin/sh
      outb 0x4e 0x07
      outb 0x4f 0x11

      outb 0x4e 0x30
      outb 0x4f 0x1

      outb 0x4e 0x60
      outb 0x4f 0x0C
      outb 0x4e 0x61
      outb 0x4f 0xA4
      outb 0x4e 0x62
      outb 0x4f 0x0C
      outb 0x4e 0x63
      outb 0x4f 0xA5
      ```

     * Create a script name "insert_ipmi_mod.sh" for example to use the regenerated KCS driver in the kernel source code ipmi directory metioned in step-8.  
     * The user needs to modify the path to the KCS driver in insert_ipmi_mod.sh below.  

       ```
       #!/bin/sh
       sudo insmod ./ipmi_devintf.ko
       sudo insmod ./ipmi_si.ko
       ```

    * Make sure that two scripts above are executable.

11. Install the ipmiutil in Ubuntu 14.04 on Supermicro MBD-X9SCL-F-0.

    * Download, extract, build and install [ipmiutil-3.1.2.tar.gz](http://sourceforge.net/projects/ipmiutil/files/ipmiutil-3.1.2.tar.gz).  
    * Open a terminal window and navigate to the extracted folder of ipmiutil-3.1.2.tar.gz.  
    * Input the following command in the terminal window.
      ```
      sudo ./scripts/ipmi_if.sh
      ```
    * This generates /var/lib/ipmiutil/ipmi_if.txt.  
    * Edit /var/lib/ipmiutil/ipmi_if.txt with the root privilege. 
    * The value for "Base Address:" is **0x0000000000000CA2 (I/O)** and modify it to **0x0000000000000CA4 (I/O)**.

12. Test message bridging.

    * Power up or reboot Poleg EVB A and Poleg EVB B. Make sure that login screens of Poleg EVBs are displayed on the terminal window (e.g. Tera Term) on your workstation.
    * Power up or reboot Supermicro MBD-X9SCL-F-0 and log in Ubuntu 14.04 as a normal user.  
      + Open a terminal window and execute **kcs_switch.sh** and **insert_ipmi_mod.sh** created in step-10 with the root privilege.
      + If the scripts are not created, input the contents of **kcs_switch.sh** and **insert_ipmi_mod.sh** except the #!/bin/sh line manually.
      + The user can use the following command in a terminal window under Ubuntu 14.04 on Supermicro MBD-X9SCL-F-0 to verify Poleg system interface.
        ```
        dmesg | grep -i "bmc"
        ```
      
      + The user can check the man_id. For example, the man_id is **0x000000** for this case.
    * Enter the following command in a terminal window as a normal user of Ubuntu 14.04 on Supermicro MBD-X9SCL-F-0.  
      ```
      sudo ipmiutil cmd 18 34 02 10 18 d8 20 0e 01 d1 -x -s -j -F kcs
      ```
      > _The example command in the data field of "Send Message" command is "Get Device ID"._

    * Enter the following command in a terminal window as a normal user of Ubuntu 14.04 on Supermicro MBD-X9SCL-F-0.  
      ```
      sudo ipmiutil cmd 18 33 -x -s -j -F kcs
      ```
      > _The response to "Get Device ID" command might be "respData[len=26]: 1c 33 00 02 1e c2 58 00 01 00 00 00 02 03 02 00 00 00 00 00 00 00 00 00 00 a0"._


**Maintainer**

* Stanley Chu
* Tyrone Ting

## LDAP for User Management
<img align="right" width="30%" src="https://cdn.rawgit.com/NTC-CCBG/snapshots/b6fdec0d/openbmc/ldap-login-via-ssh.png">
<img align="right" width="30%" src="https://cdn.rawgit.com/NTC-CCBG/snapshots/eed57a62/openbmc/access_ldap_via_poleg.PNG">

The Lightweight Directory Access Protocol (LDAP) is an open, vendor-neutral, industry standard application protocol for accessing and maintaining distributed directory information services over an Internet Protocol (IP) network.

LDAP is specified in a series of Internet Engineering Task Force (IETF) Standard Track publications called Request for Comments (RFCs), using the description language ASN.1.

A common use of LDAP is to provide a central place to store usernames and passwords. This allows many different applications and services to connect to the LDAP server to validate users.

**Source URL**

* [https://github.com/Nuvoton-Israel/openbmc/tree/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/dlc/ldap-support-user-management](https://github.com/Nuvoton-Israel/openbmc/tree/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/dlc/ldap-support-user-management)
* [https://github.com/Nuvoton-Israel/openbmc-util/tree/master/ldap_server](https://github.com/Nuvoton-Israel/openbmc-util/tree/master/ldap_server)

### LDAP Server Setup

**How to use**

1. The user is expected to know how to follow the instructions in the section **Setting up your OpenBMC project** in [Nuvoton-Israel/openbmc](https://github.com/Nuvoton-Israel/openbmc) to build and program an OpenBMC image into Poleg EVBs. 
    > _Prepare a PC which builds OpenBMC. (called the build machine hereafter)_  
    > _The user is also expected to have knowledge of LDAP and its operations._

2. Install Ubuntu 16.04 64 bit (called Ubuntu hereafter) on a PC which is used as a LDAP server and log in it with an account with root privilege.

3. Set up the LDAP server and its configurations in Ubuntu. 

    * Open a terminal and input the following commands to install required software packages in advance.

      ```
      sudo apt-get install git
      sudo apt-get install libsasl2-dev
      sudo apt-get install g++
      wget http://download.oracle.com/berkeley-db/db-4.8.30.zip
      unzip db-4.8.30.zip
      cd db-4.8.30
      cd build_unix/
      ../dist/configure --prefix=/usr/local --enable-cxxmake
      sudo make install
      ```
    * Install OpenSSL
      + Download [openssl-1.0.2j.tar.gz](https://ftp.openssl.org/source/old/1.0.2/openssl-1.0.2j.tar.gz).
      + Extract openssl-1.0.2j.tar.gz.
      + Open a terminal, navigate to the extracted folder and input the following commands to install OpenSSL.
        ```
        ./config shared --prefix=/usr/local
        make
        make test
        sudo make install
        ```
    * Install OpenLDAP
      + Download OpenLDAP from [https://github.com/openldap/openldap](https://github.com/openldap/openldap)

        > _git clone https://github.com/openldap/openldap_

      + Open a terminal and input the following command to build and install OpenLDAP.
        ```
        ./configure CPPFLAGS="-I/usr/local/include -I/usr/local/include/openssl" LDFLAGS="-L/usr/local/lib -Wl,-rpath,/usr/local/lib" --prefix=/usr/local  --enable-syncprov=yes --enable-crypt=yes --enable-accesslog=yes --enable-auditlog=yes --enable-constraint=yes --enable-ppolicy=yes --enable-modules --enable-mdb --enable-spasswd --enable-debug=yes --enable-syslog --enable-slapd --enable-cleartext --enable-monitor --enable-overlays -with-threads --enable-rewrite --enable-syncprov=yes --with-tls=openssl 
        ```
          > _The description above is one line only._

        ```
        make depend 
        make
        sudo make install
        ```
    * Execute LDAP server
      + Open a terminal and input the following command.

        ```
        sudo /usr/local/libexec/slapd -d 1 -h 'ldaps:/// ldap:/// ldapi:///'
        ```
          > _To stop LDAP server execution, press Ctrl key and C key at the same time in the terminal._  
          > _Now please stop the LDAP server execution._

    * Generate security configurations for the LDAP server running in Ubuntu.
      > _Here a two-stage signing process is applied._  
      > _You could also use the self-signed CA and cert for the configuration if your company uses them._

      + Generate the CA key and cert. Open a terminal and input the following commands.
        ```
        openssl ecparam -genkey -name prime256v1 -out ca_server.key  
        openssl req -x509 -new -key ca_server.key -days 3650 -out ca_server.pem -subj '/C=OO/ST=OO/L=OO/O= OO/OU= OO /CN= OO'
        ```

        > _Define these **OO** for the arguments **C**, **ST**, etc. according to your configurations._  
        > _Please refer to the following link for explanations of the arguments **C**, **ST**, etc._  
        > _[https://www.shellhacks.com/create-csr-openssl-without-prompt-non-interactive/](https://www.shellhacks.com/create-csr-openssl-without-prompt-non-interactive/)._

      + Generate the LDAP key and CSR. In the same terminal, input the following commands.
        ```
        openssl ecparam -genkey -name prime256v1 -out ldap_server.key  
        openssl req -new -key ldap_server.key -out ldap_server.csr -subj '/C=OO /ST=OO /L=OO/O=OO/OU=OO/CN=ldap.example.com'
        ```

        > _Define these **OO** for the arguments **C**, **ST**, etc. according to your configurations._  
        > _Note that the field **CN** in ldap_server.csr must be set to the fully qualified domain name of the LDAP server._

      + Generate ldap cert signed with CA cert. In the same terminal, input the following command.
        ```
        openssl x509 -req -days 365 -CA ca_server.pem -CAkey ca_server.key -CAcreateserial -CAserial serial -in ldap_server.csr -out ldap_server.pem
        ```

    * Store and specify locations of keys and certs.
      + Edit /usr/local/etc/openldap/slapd.conf in Ubuntu with root privilege to update fields as examples shown below.
        > _TLSCACertificateFile /etc/ldap/ca_certs.pem_  
        > _TLSCertificateFile /etc/ssl/certs/ldap_server.pem_  
        > _TLSCertificateKeyFile /etc/ssl/private/ldap_server.key_  
        > _TLSCACertificatePath /etc/ldap_
      
      + Copy ca_certs.pem, ldap_server.pem and ldap_server.key into locations specified above with root privilege.

    * Add LDAP schema and LDIF.
      + Download [user_exp.schema](https://github.com/Nuvoton-Israel/openbmc-util/blob/master/ldap_server/schema/user_exp.schema) and save it at /usr/local/etc/openldap/schema with root privilege in Ubuntu.
      + Modify /usr/local/etc/openldap/slapd.conf in Ubuntu with root privilege to specify the schema just saved.
        > _include /usr/local/etc/openldap/schema/user_exp.schema_

      + Download [bdn.ldif](https://github.com/Nuvoton-Israel/openbmc-util/blob/master/ldap_server/ldif/bdn.ldif), [ap_group.ldif](https://github.com/Nuvoton-Israel/openbmc-util/blob/master/ldap_server/ldif/ap_group.ldif), [bmc.ldif](https://github.com/Nuvoton-Israel/openbmc-util/blob/master/ldap_server/ldif/bmc.ldif), [group.ldif](https://github.com/Nuvoton-Israel/openbmc-util/blob/master/ldap_server/ldif/group.ldif), [people.ldif](https://github.com/Nuvoton-Israel/openbmc-util/blob/master/ldap_server/ldif/people.ldif) and [privRole.ldif](https://github.com/Nuvoton-Israel/openbmc-util/blob/master/ldap_server/ldif/privRole.ldif) to a temporary folder in Ubuntu.
      + Open a terminal, navigate to the temporary folder for storing LDIF and input the following commands to add these LDIF into the LDAD server in Ubuntu.
        ```
        sudo slapadd -l ./bdn.ldif
        sudo slapadd -l ./ap_group.ldif
        sudo slapadd -l ./bmc.ldif
        sudo slapadd -l ./group.ldif
        sudo slapadd -l ./people.ldif
        sudo slapadd -l ./privRole.ldif
        ```

    * Execute LDAP server.
      + Open a terminal and input the following command in the terminal.
      ```
      sudo /usr/local/libexec/slapd -d 1 -h 'ldaps:/// ldap:/// ldapi:///'
      ```

4. Setup LDAP client configuration on Poleg.

    * Open a terminal in the build machine and navigate to the directory which contains OpenBMC source codes. The directory is called **OPENBMCDIR** hereafter.
      + Copy all directories and their containing files from [https://github.com/Nuvoton-Israel/openbmc/tree/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/dlc/ldap-support-user-management](https://github.com/Nuvoton-Israel/openbmc/tree/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/dlc/ldap-support-user-management) under OPENBMCDIR/meta-evb/meta-evb-nuvoton/meta-evb-npcm750 directory according to their default hierarchy.

    * Update OPENBMCDIR/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-phosphor/nss-pam-ldapd/files/nslcd.conf. (optional)
      + The IP address for the LDAP server in Ubuntu is configured as **192.168.0.101**. Modify the field **uri ldap** in nslcd.conf according to your network configuration.
        > _uri ldap://192.168.0.101/_

      + The modification above is done in OpenBmc build time. If you would like to modify **uri** in OpenBmc run time, follow the instructions below after logging into Poleg in the console program (like Tera Term) with the root account (root/0penBmc).
        > _The console program is used to display a debug console provided by Poleg._

        ```
        vi /etc/nslcd.conf
        ```

        > _Locate the line **uri ldap://192.168.0.101/**. Modify the field **uri ldap** according to your network configuration._

        ```
        systemctl stop nslcd
        systemctl start nslcd
        ```

    * In the build machine, open a terminal window (build environment is configured in advance and the working directory is at OPENBMCDIR/build) to input the following commands to build the OpenBMC image.
      ```
      bitbake -C fetch libpam
      bitbake -C fetch pamela
      bitbake -C fetch nss-pam-ldapd
      bitbake -C fetch dropbear
      bitbake -C fetch phosphor-rest
      bitbake -C fetch phosphor-webui
      bitbake obmc-phosphor-image
      ```
    * Follow the section **Programming the images** of [Nuvoton-Israel/openbmc](https://github.com/Nuvoton-Israel/openbmc) to program the updated image into Poleg.

5. Test LDAP server.

   * Connect Poleg(J12 header) to the PC running Ubuntu with an ethernet cable and power on Poleg.
   * Log in Poleg from the console program (like Tera Term) with the root account (root/0penBmc).
     > _The console program is used to display a debug console provided by Poleg._

   * Set up IP addresses for Poleg and Ubuntu so that they can ping each other.
     + For example, set Poleg's IP address to 192.168.0.2. Input the following command in the console program.
       ```
       ifconfig eth2 192.168.0.2
       ```

       > _Please replace **192.168.0.2** with your IP configuration for Poleg._

   * Execute the following command in the console program.
     ```
     ldapsearch -ZZ -h 192.168.0.101 -D "cn=admin,dc=ldap,dc=example,dc=com" -b "dc=ldap,dc=example,dc=com" -w secret
     ```  
     > _Please replace **192.168.0.101** with your IP configuration for Ubuntu._  
     > _The ldapsearch example is to display all the data stored in the LDAP server using a TLS connection._

   * You could use the account **user1** stored in the LDAP server to log in WebUI running on Poleg.
   <div align="center">
   <img width="30%" src="https://raw.githubusercontent.com/NTC-CCBG/snapshots/c8c60b29/openbmc/user1_logininfo.png">
   <img width="30%" src="https://raw.githubusercontent.com/NTC-CCBG/snapshots/c8c60b29/openbmc/user2_logininfo.png">
   </div>
   <div align="center">
   <img width="30%" src="https://raw.githubusercontent.com/NTC-CCBG/snapshots/c8c60b29/openbmc/email_info.png">
   <img width="30%" src="https://raw.githubusercontent.com/NTC-CCBG/snapshots/c8c60b29/openbmc/webserver_info.png">
   </div>
   <div align="center">
   <img width="30%" src="https://raw.githubusercontent.com/NTC-CCBG/snapshots/c8c60b29/openbmc/bmc1_info.png">
   <img width="30%" src="https://raw.githubusercontent.com/NTC-CCBG/snapshots/c8c60b29/openbmc/bmc2_info.png">
   </div>

     + Some descriptions about the LDIF used by the LDAP server and authentication process are provided here. Please refer to the six snapshots just above.
       > _To login using an account, the authentication logic has to check the following criteria._  
       > _**bmc-uid**: It stands for the BMC machine that the account is used to login. The BMC machines are grouped by DN **ou=ap_group,dc=ldap,dc=example,dc=com**. One BMC machine can be in multiple groups at the same time. (see **ap_group** below)_  
       > _**ap_group**: Applications like web server, email, ftp and so on are deployed on the servers attched by BMC machines. Therefore, grouping by applications is taken into the authentication process. The authentication refuses an account to log in some BMC machine if that machine is not deployed under the certain **ap_group** the account also joins._  
       > _**people**: It contains the account information (login/privileges) stored in the LDAP server. An account can join multiple **ap_group** simutaneously._  
       > _**user-login-disabled**: While this attribute's value is 1, it is not allowed to login with the account's membership of the specific **ap_group**_.  
       > _**user-login-interface**: It's used as a channel via that the account logins for an **ap_group**. For example, **web** stands for logging in a BMC machine via WebUI. If **web** does not exist in any **user-login-interface** attributes an account owns under a certain ap_group, it means that the user cannot use this account to login as a member of the preferred ap_group via WebUI._

     + Use an LDAP tool to modify the field **macAddress** of the DN **bmc-uid=bmc1,ou=bmc,dc=ldap,dc=example,dc=com** stored in the LDAP server.
       > _The modification is to use the mac address of the ethernet module on the Poleg EVB you currently test with._

     + To get the mac address desired, input the following command in the console program.
       ```
       ifconfig eth0
       ```
       > _Locate the keyword **HWaddr** displayed in the console program._  
       > _Copy the value next to HWaddr to override the value of the field **macAddress** of the DN **bmc-uid=bmc1,ou=bmc,dc=ldap,dc=example,dc=com**._

     + Launch a browser and navigate to the Poleg's IP address.
       > _Bypass the secure warning and continue to the website._

     + Use user1/123 to log in WebUI.
       > _user1 is the login ID._  
       > _123 is the login password._  
       > _The **bmc-uid** for the BMC machine used for this test is bmc1. According to the LDIF provided, the BMC machine bmc1 is deployed under the **ap_group** email and the the BMC machine bmc2 is deployed under **ap_group** webserver. Also one can tell from the snapshots, user1 and user2 have different **user-login-interface** settings for the **ap_group** email and **ap_group** webserver respectively._  
       > _User1 is able to log on bmc1 via WebUI since the following conditions are met: the BMC machine bmc1 is deployed under **ap_group** email.; user1 is a member of the **ap_group** email.; user1 has an **user-login-interface** setting as **web** for that group and value of user1's **user-login-disabled** attribute is not set._  
       > _Although user2 is also a member of the **ap_group** email, it does not have an **user-login-interface** setting as **web** for that group. Under such conditions, user2 is not allowed to log on bmc1. User2 does have an **user-login-interface** setting as **web** for the **ap_group** webserver but bmc1 is not deployed under the **ap_group** webserver._  
       > _The description above explains why user1 is used for this test._

   * Password modification is also available to LDAP accounts via WebUI.
     + Log in WebUI using user1/123 as mentioned in previous phrase.
     + Navigate to `Users` menu item on the left panel and select it.
     + A sub menu item `Manage user account` pops up and select it.
     + Input the current password value for user1.
       > _The password is set to 123 by default._  
       > _The input location is right below **CURRENT PASSWORD** text area._

     + Input a new password twice.
       > _The input locations are right below **NEW PASSWORD** and **RETYPE NEW PASSWORD** text area._

     + Press the `Save change` button.
       > _A message **Success! User Password has been changed!** is expected to show then._

     + Log out WebUI and login again with the new password for user1.

    * Log in Poleg via SSH using an LDAP account.
      + Make sure that configurations stated in Step 5 for Poleg and Ubuntu are set accordingly and ping between Ubuntu and Poleg is okay.
      + Install **ssh** in Ubuntu with root privilege if ssh client is not available. Open a terminal and input the following command.
        ```
        sudo apt-get install ssh
        ```

      + Open a terminal in Ubuntu to log in Poleg using the LDAP account **user1** and its password via SSH. Input the following command in the terminal.
        ```
        ssh user1@192.168.0.2
        ```
        > _Please replace **192.168.0.2** with your IP configuration for Poleg._

**Maintainer**

* Tyrone Ting


## JTAG Master
JTAG master is implemented on BMC to debug host CPU or program CPLD / FPGA device.  

### Remote Debugging
<img align="right" width="30%" src="https://raw.githubusercontent.com/NTC-CCBG/snapshots/a15e29c/openbmc/jtag_remotedebug.png">  
Administrator can operate his own machine (guest) to debug CPU on remote server. Administrator's machine sends debug commands to remote BMC via network, and then BMC translates these commands and shifts JTAG instructions or data to host CPU, collect returned data shifted out from host CPU, and sends returned data back to administrator's machine via network.   

**How to use**

1. Prepare a Poleg EVB and a target board (in our test, we use NUC950).
2. Connect pins of Jtag on NUC950 to Poleg EVB:
    * Connect Jtag TCK pin to pin2 of J11 on Poleg EVB.
    * Connect Jtag TDI pin to pin7 of J11 on Poleg EVB.
    * Connect Jtag TDO pin to pin8 of J11 on Poleg EVB.
    * Connect Jtag TMS pin to pin10 of J11 on Poleg EVB.
3. Prepare Jtag driver module and Jtag socket svc deamon:
    * Jtag driver
      * make sure the kernel config is enabled:
        ```
        CONFIG_NUVOTON_JTAG=y
        ```
    * Jtag socket svc daemon:
      * In the build machine, build daemon by:
        ```
        bitbake jtag-socket-svc
        ```
      * Copy generated daemon "jtag_socket_svc" to Poleg EVB. "jtag_socket_svc" should be loacted at \<openbmc folder\>/build/tmp/work/armv7a-openbmc-linux-gnueabi/jtag-socket-svc/\<version\>/image/usr/bin/
4. Prepare a guest PC and jtag client tool which will send At scale debug commands to daemon "jtag_socket_svc" on Poleg EVB via ethernet.
    * Here is an example jtag client tool for NUC950 (target board)
      * Download the example tool from https://github.com/Nuvoton-Israel/openbmc-util/tree/master/jtag_socket_client_arm  
      * Make sure that python3 is installed on the guest PC.
5. Configure the ethernet communication between Poelg EVB and a guest PC:
    * Connect an ethernet cable between your workstation and J12 header of Poleg EVB.
    * Configure guest PC' ip address to 192.168.2.101 and the netmask to 255.255.255.0 as an example here.
    * Configure Poleg EVB ip address to 192.168.2.100 and the netmask to 255.255.255.0. For example, input the following command in the terminal connected to Poleg EVB on your workstation and press enter key.
      ```
      ifconfig eth2 192.168.2.100 netmask 255.255.255.0
      ```
6. Run Jtag socket svc daemon:
    * Run daemon "jtag_socket_svc" by inputing the following command in the terminal connected to Poleg EVB:
      ```
      ./jtag_socket_svc
      ```
    * Make sure the NUC950(target board) is powered on and Jtag connection is ready.
    * Control NUC950(target board) via Jtag by jtag client tool on guest PC:
      * Launch client jtag tool
        ```
        python jtag_client.py
        ```
      * List commands the jtag client tool supports:
        ```
        jtag_client>>>?
        ```
      * Halt the target board:
        ```
        jtag_client>>>halt
        ```
      * Restore the target board:
        ```
        jtag_client>>>go
        ```
### CPLD / FPGA Programming
The motherboard on server might have CPLD or FPGA components that require downloading firmware to these devices whenever server is powered on. BMC can help on this to program CPLD/FPGA via JTAG.

**How to use**
1. Connect Poleg EVB to CPLD/FPGA device by JTAG interface.  
2. Build Programming Tool  
   ```
   bitbake loadsvf
   ```
3. Copy loadsvf executable binary from build/tmp/work/armv7a-openbmc-linux-gnueabi/loadsvf/\<version\>/image/usr/bin/ to Poleg EVB.
4. Put CPLD/FPGA image in USB disk and mount the USB disk on Poleg EVB
5. run loadsvf on Poleg to program CPLD/FPGA
   ```
   loadsvf -s ${usb_mount_point}/fpga.svf -d /dev/jtag_drv
   ```  
   For more usages of loadsvf, please check [here](https://github.com/Nuvoton-Israel/openbmc/tree/master/meta-evb/meta-evb-nuvoton/meta-evb-npcm750/recipes-support/loadsvf)  

**Maintainer**
* Stanley Chu

## Features In Progressing
* User management
* Improve IPMI
* Improve sensor/event framework
* Host firmware update
* Redfish

## Features Planned
* Boot control

# IPMI Comamnds Verified

| Command | KCS | RMCP+ | IPMB |
| :--- | :---: | :---: | :---: |
| **IPM Device Global Commands** |  |  |  |
| Device ID | V | V | V |
| Cold Reset | V | V | V |
| Warm Reset | V | V | V |
| Get Self Test Results | V | V | V |
| Manufacturing Test On | - | - | - |
| Set ACPI Power State | V | V | V |
| Get ACPI Power State | V | V | V |
| Get Device GUID | V | V | V |
| Get NetFn Support | - | - | - |
| Get Command Support | - | - | - |
| Get Command Sub-function Support | - | - | - |
| Get Configurable Commands | - | - | - |
| Get Configurable Command Sub-functions | - | - | - |
| Set Command Enables | - | - | - |
| Get Command Enables | - | - | - |
| Set Command Sub-function Enables | - | - | - |
| Get Command Sub-function Enables | - | - | - |
| Get OEM NetFn IANA Support | - | - | - |
| **BMC Watchdog Timer Commands** |  |  |  |
| Reset Watchdog Timer | V | V | V |
| Set Watchdog Timer | V | V | V |
| Get Watchdog Timer | V | V | V |
| **BMC Device and Messaging Commands** |  |  |  |
| Set BMC Global Enables | V | V | V |
| Get BMC Global Enables | V | V | V |
| Clear Message Flags | - | - | - |
| Get Message Flags | V | V | V |
| Enable Message Channel Receive | - | - | - |
| Get Message | V | - | - |
| Send Message | V | - | - |
| Read Event Message Buffer | V | V | V |
| Get System GUID | V | V | V |
| Set System Info Parameters | V | V | V |
| Get System Info Parameters | V | V | V |
| Get Channel Authentication Capabilities | V | V | V |
| Get Session Challenge | - | - | - |
| Activate Session | - | - | - |
| Set Session Privilege Level | V | V | V |
| Close Session | V | V | V |
| Get Session Info | - | - | - |
| Get AuthCode | - | - | - |
| Set Channel Access | V | V | V |
| Get Channel Access | V | V | V |
| Get Channel Info Command | V | V | V |
| User Access Command | V | V | V |
| Get User Access Command | V | V | V |
| Set User Name | V | V | V |
| Get User Name Command | V | V | V |
| Set User Password Command | V | V | V |
| Activate Payload | - | V | - |
| Deactivate Payload | - | V | - |
| Get Payload Activation Status | - | V | - |
| Get Payload Instance Info | - | V | - |
| Set User Payload Access | - | - | - |
| Get User Payload Access | - | - | - |
| Get Channel Payload Support | - | - | - |
| Get Channel Payload Version | - | - | - |
| Get Channel OEM Payload Info | - | - | - |
| Master Write-Read | - | - | - |
| Get Channel Cipher Suites | V | V| V |
| Suspend/Resume Payload Encryption | - | - | - |
| Set Channel Security Keys | - | - | - |
| Get System Interface Capabilities | - | - | - |
| Firmware Firewall Configuration | - | - | - |
| **Chassis Device Commands** |  |  |  |
| Get Chassis Capabilities | V | V | V |
| Get Chassis Status | V | V | V |
| Chassis Control | [V](#chassis-buttons) | V | V |
| Chassis Reset | [V](#chassis-buttons) | V | V |
| Chassis Identify | [V](#chassis-buttons) | V | V |
| Set Front Panel Button Enables | - | - | - |
| Set Chassis Capabilities | V | V | V |
| Set Power Restore Policy | V | V | V |
| Set Power Cycle Interval | V | V | V |
| Get System Restart Cause | - | - | - |
| Set System Boot Options | V | V | V |
| Get System Boot Options | V | V | V |
| Get POH Counter | V | V | V |
| **Event Commands** |  |  |  |
| Set Event Receiver | - | - | - |
| Get Event Receiver | - | - | - |
| Platform Event | - | - | - |
| **PEF and Alerting Commands** |  |  |  |
| Get PEF Capabilities | - | - | - |
| Arm PEF Postpone Timer | - | - | - |
| Set PEF Configuration Parameters | - | - | - |
| Get PEF Configuration Parameters | - | - | - |
| Set Last Processed Event ID | - | - | - |
| Get Last Processed Event ID | - | - | - |
| Alert Immediate | - | - | - |
| PET Acknowledge | - | - | - |
| **Sensor Device Commands** |  |  |  |
| Get Device SDR Info | V | V | V |
| Get Device SDR | V | V | V |
| Reserve Device SDR Repository | V | V | V |
| Get Sensor Reading Factors | - | - | - |
| Set Sensor Hysteresis | - | - | - |
| Get Sensor Hysteresis | - | - | - |
| Set Sensor Threshold | - | - | - |
| Get Sensor Threshold | V | V | V |
| Set Sensor Event Enable | - | - | - |
| Get Sensor Event Enable | - | - | - |
| Re-arm Sensor Events | - | - | - |
| Get Sensor Event Status | - | - | - |
| Get Sensor Reading | V | V | V |
| Set Sensor Type | - | - | - |
| Get Sensor Type | V | V | V |
| Set Sensor Reading And Event Status | V | V | V |
| **FRU Device Commands** |  |  |  |
| Get FRU Inventory Area Info | V | V | V |
| Read FRU Data | V | V | V |
| Write FRU Data | V | V | V |
| **SDR Device Commands** |  |  |  |
| Get SDR Repository Info | V | V | V |
| Get SDR Repository Allocation Info | - | - | - |
| Reserve SDR Repository | V | V | V |
| Get SDR | V | V | V |
| Add SDR | V | V | V |
| Partial Add SDR | - | - | - |
| Delete SDR | - | - | - |
| Clear SDR Repository | - | - | - |
| Get SDR Repository Time | - | - | - |
| Set SDR Repository Time | - | - | - |
| Enter SDR Repository Update Mode | - | - | - |
| Exit SDR Repository Update Mode | - | - | - |
| Run Initialization Agent | - | - | - |
| **SEL Device Commands** |  |  |  |
| Get SEL Info | V | V | V |
| Get SEL Allocation Info | V | V | V |
| Reserve SEL | V | V | V |
| Get SEL Entry | V | V | V |
| Add SEL Entry | V | V | V |
| Partial Add SEL Entry | - | - | - |
| Delete SEL Entry | V | V | V |
| Clear SEL | V | V | V |
| Get SEL Time | [V](#time) | V | V |
| Set SEL Time | [V](#time)| V | V |
| Get Auxiliary Log Status | - | - | - |
| Set Auxiliary Log Status | - | - | - |
| Get SEL Time UTC Offset | - | - | - |
| Set SEL Time UTC Offset | - | - | - |
| **LAN Device Commands** |  |  |  |
| Set LAN Configuration Parameters | V | V | V |
| Get LAN Configuration Parameters | V | V | V |
| Suspend BMC ARPs | - | - | - |
| Get IP/UDP/RMCP Statistics | - | - | - |
| **Serial/Modem Device Commands** |  |  |  |
| Set Serial/Modem Mux | - | - | - |
| Set Serial Routing Mux | - | - | - |
| SOL Activating | - | V | - |
| Set SOL Configuration Parameters | - | V | - |
| Get SOL Configuration Parameters | - | V | - |
| **Command Forwarding Commands** |  |  |  |
| Forwarded Command | - | - | - |
| Set Forwarded Commands | - | - | - |
| Get Forwarded Commands | - | - | - |
| Enable Forwarded Commands | - | - | - |
> _V: Verified_  
> _-: Unsupported_

# Image Size
Type          | Size    | Note                                                                                                     |
:-------------|:------- |:-------------------------------------------------------------------------------------------------------- |
image-uboot   |  415 KB | u-boot 2019.01 + bootblock for Poleg only                                                                       |
image-kernel  |  4.4 MB   | linux 4.19.16 version                                                                                       |
image-rofs    |  19.2 MB  | bottom layer of the overlayfs, read only                                                                 |
image-rwfs    |  0 MB  | middle layer of the overlayfs, rw files in this partition will be created at runtime,<br /> with a maximum capacity of 2MB|

# Modifications

* 2018.07.23 First release Remote-KVM
* 2018.08.02 First release SOL
* 2018.08.07 Modify Readme.md for adding description about SOL How to use
* 2018.09.07 Update SOL for WebUI and IPMI
* 2018.09.10 Update System/Time/SNTP
* 2018.09.12 Update IPMI Comamnds Verified Table
* 2018.09.13 Update Time settings of System/Time
* 2018.09.13 Update obmc-ikvm part for WebUI
* 2018.09.14 First release VM
* 2018.09.14 Update IPMI Commands Verified Table
* 2018.09.21 Add NTP screen snapshot for System/Time/SNTP
* 2018.10.05 Update webui and  patch of webui and interface and vm-own.png
* 2018.10.11 Add Sensor
* 2018.11.16 Add obmc-ikvm support in bmcweb
* 2018.11.22 Enable firmware update support
* 2018.11.23 Update Sensor description about FAN How to use
* 2018.11.29 Update Server power operations of Server control about How to use
* 2018.12.27 Add Chassis Buttons about How to use
* 2019.01.02 Add LDAP server setup and test
* 2019.03.13 Modify Server power operation of Server control about How to use
* 2019.03.19 Update IPMI Comamnds Verified Table
* 2019.04.08 Update Kernel version to 4.19.16
* 2019.04.30 Add BIOS POST Code
* 2019.05.05 Update u-boot to 2019.01
* 2019.05.15 Add ADC config file
* 2019.05.23 Add FRU for Server health
