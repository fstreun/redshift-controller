# redshift-controller
Controller for the application redshift.
Written in bash.

Offers functions to manipulate the display temperature defined by redshift and can be variously applied.
If changeing redshift parameters by yourself, unexpected behaviour can happen.

redshift-controller can be in three states:
*default*: redshift behaves as in the config defined (with transition between day and night mode). Can be reached by calling the *reset()* method.
*manual*: redshift has a static temperature defined by the redshift-controller (value is stored in a temporary file). Is reached by calling the *setTemperature()* method or any which calls this method.
*disabled*: redshift is not running and also not in manual mode. Is reached by calling the *disable()* method.

**Functions**

*printTemperature()*: Returns (echo) the temperature with color flag in front and icon
(depending on how it is defined).

*setTemperature()*: Sets temperature to the argument.
Only checks if an argument is given
and not if it's in the correct range.

*increase()*: Increases the temperature to the next multiple of the value
of the first argument (or STEPDEFAULT).
But stops at the REDSHIFTMAX.

*decrease()*: Decreases the temperature to the next multiple of the value
of the first argument (or STEPDEFAULT).
But stops at the REDSHIFTMIN.

*reset()*: Resets redshift to the default configurations
(probably defined in the config file).

*disable()*: Disables are effects redshift has on the display

**Application Examples**

*polybar*: path to redshift-controller.sh = ~/.config/polybar/redshift-controller.sh
```
[module/redshift]
type = custom/script
exec = ~/.config/polybar/redshift-controller.sh printTemperature
interval = 1

click-left = ~/.config/polybar/redshift-controller.sh restart
click-left = ~/.config/polybar/redshift-controller.sh disable
scroll-up =  ~/.config/polybar/redshift-controller.sh increase 200
scroll-down =  ~/.config/polybar/redshift-controller.sh decrease 200
```
