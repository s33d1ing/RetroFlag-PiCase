#!/usr/bin/env python3

import os
import subprocess

from gpiozero import Button, LED
from signal import pause

powerPin = 3
resetPin = 2
ledPin = 14
powerenPin = 4

hold = 1

led = LED(ledPin)
led.on()

power = LED(powerenPin)
power.on()


# functions that handle button events

def when_pressed():
  led.blink(.2,.2)

  output = int(subprocess.check_output(['/home/pi/RetroPie/scripts/multi_switch.sh', '--es-pid']))

  if output:
    os.system("/home/pi/RetroPie/scripts/multi_switch.sh --es-poweroff")
  else:
    os.system("sudo poweroff")

def when_released():
  led.on()

def reboot():
  output = int(subprocess.check_output(['/home/pi/RetroPie/scripts/multi_switch.sh', '--es-pid']))
  output_rc = int(subprocess.check_output(['/home/pi/RetroPie/scripts/multi_switch.sh', '--rc-pid']))

  if output_rc:
    os.system("/home/pi/RetroPie/scripts/multi_switch.sh --es-closeemu")
  elif output:
    os.system("/home/pi/RetroPie/scripts/multi_switch.sh --es-restart")
  else:
    os.system("sudo reboot")


btn = Button(powerPin, hold_time=hold)

rebootBtn = Button(resetPin)
rebootBtn.when_pressed = reboot

btn.when_pressed = when_pressed
btn.when_released = when_released

pause()
