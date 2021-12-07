# SoMPriest
A Shadow priest rotation primarily used for leveling and BGs. Also supports healing dungeons. I will be slowly adding more PvP logic, including engineering items, trinkets etc.

PLEASE SET A WAND SPEED ON FIRST LOAD.

To keep the rotation bar in a fixed location - Move the bar somewhere on the screen where you want it to stay. Turn the main Cromulon (left most button) off then back on.

You can critique my code, as I am definitely still learning :)

For leveling, you must have you wand bound to Keybind 1.

To use spell queue system, macro your abilites like below:<br>
#showtooltip Mind Blast<br>
/run _G.QueuePriestCast("Mind Blast", "target")<br>
/cast Mind Blast
