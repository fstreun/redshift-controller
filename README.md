# redshift-controller
Controller for the application redshift.
Written in bash.

Offers functions to manipulate the display temperature defined by redshift and can be variously applied.

**Functions**

*printTemperature()*: Returns (echo) the temperature with color flag in front and icon
(depending on how it is defined).

*increase()*: Increases the temperature to the next multiple of the value
of the first argument (or STEPDEFAULT).
But stops at the REDSHIFTMAX.

*decrease()*: Decreases the temperature to the next multiple of the value
of the first argument (or STEPDEFAULT).
But stops at the REDSHIFTMIN.

*reset()*: Resets redshift to the default configurations
(probably defined in the config file).

**Application Examples**

*polybar*:
```
[module/redshift]
type = custom/script
exec = ~/.config/polybar/redshift-controller.sh printTemperature
interval = 1

click-left = ~/.config/polybar/redshift-controller.sh reset
scroll-up =  ~/.config/polybar/redshift-controller.sh increase 200
scroll-down =  ~/.config/polybar/redshift-controller.sh decrease 200
```
