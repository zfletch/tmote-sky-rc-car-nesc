#include <Timer.h>
#include "MyReceiver.h"

module MyReceiverC {
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
	uses interface Read<uint16_t> as ReadLight;
	uses interface Read<uint16_t> as ReadTemp;
}

implementation {
	//true when radio is currently sending message
	bool busy = FALSE;
	//message packet
	message_t pkt;
	//light and heat measurements
	uint16_t light;
	uint16_t temp;

	//on boot
	event void Boot.booted() {
		//start radio
		call AMControl.start();
	}

	//every 100ms
	event void Timer0.fired() {
		//get light data
		call ReadLight.read();
		//get heat data
		call ReadTemp.read();
		
		//turn on/off white LED
		if (light < 30) {
			call Pin0.set();
		} else {
			call Pin0.clr();
		}
		
		//send light and temp data to remote
		if (!busy) {
			LightMsg* btrpkt = (LightMsg*) (
				call Packet.getPayload(&pkt, sizeof(LightMsg)));
			btrpkt->light = light;
			btrpkt->temp = temp;
			if (call AMSend.send(AM_BROADCAST_ADDR,&pkt,sizeof(LightMsg))
				== SUCCESS) {
				busy = TRUE;
			}
		}
	}

	//on radio startup
	//turns LED on if it works
	event void AMControl.startDone(error_t error) {
		if (error == SUCCESS) {
			//initialize IO pins
			call Timer0.startPeriodic(100);
			call Pin0.makeOutput();
			call Pin1.makeOutput();
			call Pin2.makeOutput();
			call Pin3.makeOutput();
			call Leds.led2On();
		} else {
			call AMControl.start();
			call Leds.led2Off();
		}
	}

	event void AMControl.stopDone(error_t error) {}
	event void AMSend.sendDone(message_t* msg, error_t error) {
		if (&pkt == msg) {
			busy = FALSE;
		}
	}

	//when message is received
	event message_t* Receive.receive(
		message_t* msg, void* payload, uint8_t len) {
		if (len == sizeof(ControlMsg)) {
			ControlMsg* btrpkt = (ControlMsg*) payload;
			//set wheels and horn depending on message
			if (btrpkt->right) {
				call Pin2.set();
			} else {
				call Pin2.clr();
			}
			if (btrpkt->left) {
				call Pin3.set();
			} else {
				call Pin3.clr();
			}
			if (btrpkt->horn) {
				call Pin1.set();
			} else {
				call Pin1.clr();
			}
		}
		return msg;
	}
	//read light data
	//turns LED on if it works
	event void ReadLight.readDone(error_t result, uint16_t data) {
		if (result == SUCCESS) {
			light = data;
			call Leds.led0On();
		} else {
			call Leds.led0Off();
		}
	}
	//read temp data
	//turns LED on if it works
	event void ReadTemp.readDone(error_t result, uint16_t data) {
		if (result == SUCCESS) {
			temp = data;
			call Leds.led1On();
		} else {
			call Leds.led1Off();
		}
	}
}
