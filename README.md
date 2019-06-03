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

### Useful commands for positionning windows
The `groot` function give access to monitor graphical properties:
~~~
>> r=groot

r = 

  Graphics Root with properties:

          CurrentFigure: [1×1 Figure]
    ScreenPixelsPerInch: 96
             ScreenSize: [1 1 1920 1080]
       MonitorPositions: [2×4 double]
                  Units: 'pixels'

  Show all properties

         CallbackObject: [0×0 GraphicsPlaceholder]
               Children: [1×1 Figure]
          CurrentFigure: [1×1 Figure]
     FixedWidthFontName: 'Courier New'
       HandleVisibility: 'on'
       MonitorPositions: [2×4 double]
                 Parent: [0×0 GraphicsPlaceholder]
        PointerLocation: [485 108]
            ScreenDepth: 32
    ScreenPixelsPerInch: 96
             ScreenSize: [1 1 1920 1080]
      ShowHiddenHandles: 'off'
                    Tag: ''
                   Type: 'root'
                  Units: 'pixels'
               UserData: []
~~~
The property `MonitorPositions` shows the screens detected by MATLAB. The two first values are the x and y position.
The origin is the top-left pixel of the first screen. The two last values are the width and height of the figures.
~~~
>> r.MonitorPositions

ans =

        1921           1        1920        1080
           1           1        1920        1080
~~~
The `findobj` function searches among all the objects accessible via Matlab.
The optional argument `Type` can be used to specify what type of object we are looking for.
By specifying a `Figure` object type, we obtain the following result:
~~~
>> f=findobj('Type','Figure')

f = 

  2×1 Figure array:

  Figure    (1: SLM beam forming)
  Figure    (2: SLM display)
~~~
The result of the previous command, `f` contains each `Figure` object indexed in an array.
The number of the figure as well as its name is displayed.

Each of these figures properties can be accessed.
Here's an example for the second figure that we want to move:
~~~
>> f(2)

ans = 

  Figure (2: SLM display) with properties:

      Number: 2
        Name: 'SLM display'
       Color: [0.9400 0.9400 0.9400]
    Position: [1918 100 1280 1024]
       Units: 'pixels'

  Show all properties
~~~
We can see that the figure has a property called `Position`.
This property is a vector that contains the x and y positions of the top-left pixel of the figure.
The last values of the vectore are the width and the height of the figure.
The position of the figure can simply be changed by modifying the two first values as follow:
~~~
>> f(2).Position([1 2]) = [1918 100] ;
~~~
