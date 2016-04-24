/**
 * MyMonitorNetworkC exercises the basic networking layers, collection and
 * dissemination and monitor the routing paths. The application samples DemoSensorC at a basic rate
 * and sends packets up a collection tree. The rate is configurable
 * through dissemination.
 *
 * See TEP118: Dissemination, TEP 119: Collection, and TEP 123: The
 * Collection Tree Protocol for details.
 * 
 * @author Philip Levis
 * @version $Revision: 1.6 $ $Date: 2007/09/14 18:48:51 $
 */
#include "TestNetwork.h"
#include "Ctp.h"

configuration MyMonitorNetworkAppC {}
implementation {
  components MyMonitorNetworkC, MainC, LedsC, ActiveMessageC;
  components DisseminationC;
  components new DisseminatorC(uint16_t, SAMPLE_RATE_KEY) as Object16C;
  components CollectionC as Collector;

  components new CollectionSenderC(CL_TEST) as TestCollectionSender;
  /*****************************************************/
  //Task 2.2 add your code here
  /*****************************************************/
  

  components new TimerMilliC() as TestTimer;
  /*****************************************************/
  //Task 2.1 add your code here
  /*****************************************************/
  
	
  components new DemoSensorC();
  components new SerialAMSenderC(CL_TEST);
  components SerialActiveMessageC;
#ifndef NO_DEBUG
  components new SerialAMSenderC(AM_COLLECTION_DEBUG) as UARTSender;
  components UARTDebugSenderP as DebugSender;
#endif
  components RandomC;
  components new QueueC(message_t*, 12);
  components new PoolC(message_t, 12);

  MyMonitorNetworkC.Boot -> MainC;
  MyMonitorNetworkC.RadioControl -> ActiveMessageC;
  MyMonitorNetworkC.SerialControl -> SerialActiveMessageC;
  MyMonitorNetworkC.RoutingControl -> Collector;
  MyMonitorNetworkC.DisseminationControl -> DisseminationC;
  MyMonitorNetworkC.Leds -> LedsC;

  MyMonitorNetworkC.DisseminationPeriod -> Object16C;

  MyMonitorNetworkC.TestTimer -> TestTimer;
  /*****************************************************/
  //Task 2.1 add your code here
  /*****************************************************/
  
  MyMonitorNetworkC.TestSend -> TestCollectionSender;
  /*****************************************************/
  //Task 2.2 add your code here
  /*****************************************************/

  MyMonitorNetworkC.ReadSensor -> DemoSensorC;
  MyMonitorNetworkC.RootControl -> Collector;

  MyMonitorNetworkC.TestReceive -> Collector.Receive[CL_TEST];
  /*****************************************************/
  //Task 3.2 add your code here
  /*****************************************************/


  MyMonitorNetworkC.UARTSend -> SerialAMSenderC.AMSend;
  
  //MyMonitorNetworkC.CollectionPacket -> Collector;
  MyMonitorNetworkC.CtpPacket -> Collector;

  MyMonitorNetworkC.CtpInfo -> Collector;
  MyMonitorNetworkC.CtpCongestion -> Collector;
  MyMonitorNetworkC.Random -> RandomC;
  MyMonitorNetworkC.Pool -> PoolC;
  MyMonitorNetworkC.Queue -> QueueC;
  MyMonitorNetworkC.RadioPacket -> ActiveMessageC;
  
#ifndef NO_DEBUG
  components new PoolC(message_t, 10) as DebugMessagePool;
  components new QueueC(message_t*, 10) as DebugSendQueue;
  DebugSender.Boot -> MainC;
  DebugSender.UARTSend -> UARTSender;
  DebugSender.MessagePool -> DebugMessagePool;
  DebugSender.SendQueue -> DebugSendQueue;
  Collector.CollectionDebug -> DebugSender;
  MyMonitorNetworkC.CollectionDebug -> DebugSender;
#endif
  MyMonitorNetworkC.AMPacket -> ActiveMessageC;
}
