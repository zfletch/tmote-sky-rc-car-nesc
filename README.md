RC Vehicle Using Tmote Sky and TinyOS
=====================================

The Tmote Sky is a remote sensor that can connect to other
sensors or computers over wifi.

In this project, I use two Tmote Skys and some circuitry to build
a remote-controlled vehicle that collects and sends temperature and
light data back to the controller. I programmed the Tmotes using
TinyOS and the event-based nesC programming language.

I'm uploading the code because I had a
hard time finding examples of working Tmote Sky applications. I hope
that the code might be useful to somebody out there.

What Does it Do?
----------------
The Tmote Sky has a radio, a number of digital IO pins, and three
on-board LEDs (blue, green, and red).

The controller (transmitter) consists of one Tmote that takes four
digital inputs each connected to a button or switch:

 - Horn button
 - Left button
 - Right button
 - Light/Temperature switch

When the horn, left, or right button is pressed, a message is sent to the
vehicle (receiver) and the vehicle acts on the input.
The vehicle also sends light and temperature data back to the controller.
On the controller, when the light/temperature switch is switched to light, then the blue
on-board LED lights up if the verhicle is in a low-light area, the green
on-board LED lights up if the vehicle is in a mid-light area, and the red
on-board LED lights up if the vehicle is somewhere with a lot of light. If the
switch is switched to temperature, the LEDs work the same except
with temperture instead of the level of light.
(Note: the Tmote's light and temperature sensors are not always
accurate, make sure to take this into account if using one to measure
light and/or temperature.)

The vehicle consists of one Tmote, two motors, one speaker, one LED and some
circuitry (see below). The Tmote transmits light and temperature data to the controller and
acts on commands given to it from the controller.
It also turns the LED on if it is in a low-light area.

Beautiful Hand-Crafted Circuit Diagrams
---------------------------------------
![transmitter](https://github.com/zfletch/tmote-sky-rc-car-nesc/blob/master/schematics/transmitter.png?raw=true)
![receiver](https://github.com/zfletch/tmote-sky-rc-car-nesc/blob/master/schematics/receiver.png?raw=true)
![tmote](https://github.com/zfletch/tmote-sky-rc-car-nesc/blob/master/schematics/tmote.png?raw=true)

Pictures
--------
![picture1](https://github.com/zfletch/tmote-sky-rc-car-nesc/blob/master/pictures/picture1.jpg?raw=true)
![picture2](https://github.com/zfletch/tmote-sky-rc-car-nesc/blob/master/pictures/picture2.jpg?raw=true)
