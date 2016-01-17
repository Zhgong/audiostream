import pexpect
import time

bt_devies = { "sean iPad" : "64:20:0C:28:CD:40",
              "iPhonePi" : "10:41:7F:62:60:8C",
              "iPhone von GONG" : "94:E9:6A:8C:93:59"
              }

btctl = pexpect.spawn('bluetoothctl')

for k,v in bt_devies.items():
    print("Connecting to %s \t %s" %(k, v))
    btctl.sendline('connect %s' %v)
    time.sleep(2)