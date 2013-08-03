#include <Timer.h>
#include "MyTransmitter.h"

configuration MyTransmitterAppC {}

//components for remote
implementation {
	components MainC;
	components LedsC;
	components MyTransmitterC as App;
	components new TimerMilliC() as Timer0;
	components ActiveMessageC;
	components new AMSenderC(6);
	components new AMReceiverC(6);
	components HplMsp430GeneralIOC;
	components new HamamatsuS10871TsrC() as PhotoTsr;

	App.Boot -> MainC;
	App.Leds -> LedsC;
	App.Timer0 -> Timer0;
	App.Packet -> AMSenderC;
	App.AMPacket -> AMSenderC;
	App.AMSend -> AMSenderC;
	App.AMControl -> ActiveMessageC;
	App.Receive -> AMReceiverC;
	App.Pin0 -> HplMsp430GeneralIOC.Port20; 
	App.Pin1 -> HplMsp430GeneralIOC.Port21;
	App.Pin2 -> HplMsp430GeneralIOC.Port23;
	App.Pin3 -> HplMsp430GeneralIOC.Port26;
	App.Read -> PhotoTsr;
}

