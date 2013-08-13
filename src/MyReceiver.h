#ifndef MYRECEIVER_H
#define MYRECEIVER_H

//message from remote to car
typedef nx_struct ControlMsg {
	nx_bool right;
	nx_bool left;
	nx_bool horn;
} ControlMsg;

//message from car to remote
typedef nx_struct LightMsg {
	nx_uint16_t light;
	nx_uint16_t temp;
} LightMsg;

#endif
