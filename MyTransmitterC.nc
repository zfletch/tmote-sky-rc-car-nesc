#include <Timer.h>
#include "MyTransmitter.h"

module MyTransmitterC {
	uses interface Boot;
	uses interface Leds;
	uses interface Timer<TMilli> as Timer0;

	uses interface Packet;
	uses interface AMPacket;
	uses interface AMSend;
	uses interface SplitControl as AMControl;

	uses interface Receive;
 
	uses interface HplMsp430GeneralIO as Pin0;
	uses interface HplMsp430GeneralIO as Pin1;
	uses interface HplMsp430GeneralIO as Pin2;
	uses interface HplMsp430GeneralIO as Pin3;
	uses interface Read<uint16_t>;
}

implementation {
	//true while radio is busy
	bool busy = FALSE;
	message_t pkt;

	//start radio
	event void Boot.booted() {
		call AMControl.start();
	}

	//every 100ms
	event void Timer0.fired() {
		if (!busy) {
			//send message to car containing the input pins for 
			//left wheel, right wheel, and horn
			ControlMsg* btrpkt = (ControlMsg*) (
				call Packet.getPayload(&pkt, sizeof(ControlMsg)));
			btrpkt->right = (call Pin2.get());
			btrpkt->left = (call Pin3.get());
			btrpkt->horn = (call Pin1.get());
			if (call AMSend.send(AM_BROADCAST_ADDR,&pkt,sizeof(ControlMsg))
				== SUCCESS) {
				busy = TRUE;
			}
		}
	}

	//on radio startup
	event void AMControl.startDone(error_t error) {
		if (error == SUCCESS) {
			//set IO pins
			call Timer0.startPeriodic(100);
			call Pin0.makeInput();
			call Pin1.makeInput();
			call Pin2.makeInput();
			call Pin3.makeInput();
		} else {
			call AMControl.start();
		}
	}
	event void AMControl.stopDone(error_t error) {}
	event void AMSend.sendDone(message_t* msg, error_t error) {
		if (&pkt == msg) {
			busy = FALSE;
		}
	}
	//when receiving a message from car
	event message_t* Receive.receive(
		message_t* msg, void* payload, uint8_t len) {
		if (len == sizeof(LightMsg)) {
			//sets LEDS to red (low), green (mid)
			//and blue (high) for either heat or light
			//depending on the heat/light switch
			//and it uses the data sent from the 
			//car for this
			LightMsg* btrpkt = (LightMsg*) payload;
			if (call Pin0.get()) {
				if (btrpkt->light < 50) {
					call Leds.led0On();
					call Leds.led1Off();
					call Leds.led2Off();
				} else if (btrpkt->light < 600) {
					call Leds.led0Off();
					call Leds.led1On();
					call Leds.led2Off();
				} else {
					call Leds.led0Off();
					call Leds.led1Off();
					call Leds.led2On();
				}
			} else {
				if ((0.01 * (btrpkt->temp) - 39.6) < 20) {
					call Leds.led0On();
					call Leds.led1Off();
					call Leds.led2Off();
				} else if ((0.01 * (btrpkt->temp) -39.6) < 32) {
					call Leds.led0Off();
					call Leds.led1On();
					call Leds.led2Off();
				} else {
					call Leds.led0Off();
					call Leds.led1Off();
					call Leds.led2On();
				}
			}
		}
		return msg;
	}
	event void Read.readDone(error_t result, uint16_t data) {}
}
