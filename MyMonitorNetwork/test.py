from TOSSIM import *
from tinyos.tossim.TossimApp import *
from random import *
import sys

t = Tossim([])
r = t.radio()

#Load link gains as computed by the LinkEstimatorModel tool
f = open("./topology2A/linkgain.out", "r")
#f = open("./topology2B/linkgain.out", "r")
lines = f.readlines()
NUM_NODES = int(len(lines)**(0.5))
print "Numer of nodes:", NUM_NODES
for line in lines:
  s = line.split()
  if (len(s) > 0):
    if s[0] == "gain":
      r.add(int(s[1]), int(s[2]), float(s[3]))

#Add a "dummy" environmental noise
noise = open("./noise/dummy_noise.txt", "r")
lines = noise.readlines()
for line in lines:
  str = line.strip()
  if (str != ""):
    val = int(str)
    for i in range(0, NUM_NODES):
      m = t.getNode(i);
      m.addNoiseTraceReading(val)

#Create the noise model and boot the nodes
for i in range(0, NUM_NODES):
  m = t.getNode(i);
  m.createNoiseModel();
  time = randint(t.ticksPerSecond(), 10 * t.ticksPerSecond())
  m.bootAtTime(time)
  print "Booting ", i, " at time ", time

print "Starting simulation."

#t.addChannel("RoutingBeaconsStats", sys.stdout)
t.addChannel("TestNetworkC", sys.stdout)
t.addChannel("MonitorNetwork",sys.stdout)

while (t.time() < 100 * t.ticksPerSecond()):
  t.runNextEvent()

print "Completed simulation."
