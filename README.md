This script controls the fan speed of ATI Radeon video cards in Linux with
Catalyst driver on Linux.

The Catalyst driver on Linux is supposed to work with the following command:

	aticonfig --pplib-cmd "set fanspeed 0 audo"

which should regulate the fan speed automatically. Unfortunately this does not
work. Dear ATI: this is very lame.

You really should ready *Tunning* part. I mean it.

## Usage

	$ ./atifand.sh

For debug prints:

	$ ./atifand.sh debug

To run in background:

	& ./atifand.sh &


Add to your desktop environment autostart scripts and be done.

## Tunning

The `atifand.sh` script contains some constants at the beginning of the file.

I strongly advise you to tune this values for your system before deciding to
use this script without supervision!

`temp_` means temperature (in Celsius degrees) `fan_` means fan speed in
percentages. Note that some fans do not start spinning at all before the speed
is 20 or more.

Basic rules are:

	fan_idle <= fan_min < fan_max
	temp_idle <= temp_min < temp_max

First pick `fan_idle` value. This is the preferred speed of the fan when card
is sitting idle. For some cards stopping the fan completely is probably a bad
idea because the card will be getting hot too quickly - even when doing mostly
nothing. It's better to use some small value that will keep the card "cool
enough", yet acceptably quiet.

`temp_min` should be a little bigger than what your card's temperature is when
fan is spinning on `fan_idle` speed. To measure this, make sure your video card
is mostly idle and set fan speed to the `fan_idle` value manually with:

	$ aticonfig --pplib-cmd "set fanspeed 0 <SPEED>"

and periodically check current temperature with:

	$ aticonfig --odgt

Let the temperature stabilize. Then add 3-10 and this should be your
`temp_min`. If your card just gets hotter and hotter up to values bigger than
around 60 C, pick bigger `fan_idle` and try again.

Check on the web what temperatures are "hot" for your particular graphic card.
Set the `temp_max` to this value.

When the temperature reaches at least `temp_min` the fan speed will be set to
`fan_min` or bigger, up to `fan_max`. Theoretically 100 is a max fan speed
value. But in practice 100% speed could probably ruin your fan pretty quickly,
so I recommend leaving `fan_max` around 80.

Now set your fan speed manually to `fan_min` and let the temperature stabilize.
Add 1-2 and set this as `temp_idle`.

Run in debug mode to see if the script is doing a good job now. Test both when
idle and some stress.

If you're using `fan_idle` value that is making the fan stop completely, make
sure the fan does not constantly switch between spinning and being stopped.
Constant switching on and off would probably shorten it's life. Use higher
`fan_idle` value in such cases.
