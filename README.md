# gui_slm_beam_network

### Description
GUI for controlling a SLM as a second window with Matlab.
This GUI is designed to display an array of disk-shaped or square-shaped gratings.

### Functionalities
The user can set:
  * The shape of the beams (circular or square)
  * The number of gratings zones (must be a square number)
  * The number of sub-zones per grating (must be a square number)
  * The aberrations of each sub-zone
  * The aberrations of a global disk-shaped zone
  
### Note about aberrations
First order aberrations such as piston, tip, tilt and defocus are accessible. Their respective level can be set via dedicated GUI entries. Taken independently, an entry of e.g. 1 rad adds phase aberration of:
  * Piston: 1 rad.
  * Tip: Linear 2 rad PV phase in y axis over the sub-zone.
  * Tilt: Linear 2 rad PV phase in x axis over the sub-zone.
  * Defocus: Quadratic 2 rad PV phase in x and y axis over the sub-zone.
