# XPImport_mk2
Updated nanoindentation registration software based on XPImport. Removed bundle/batch functionality and created template.

Based on https://github.com/cmmagazz/XPressImport, with only minor changes made.
Please refer to this repository for correct referencing.

To update the excel template with nanoindentation data received, use 'Required Inputs' and 'Test 0001 Tagged' sheets.

1.	Set Required Inputs bounds:
- X and Y start and stop values indicate the range over which the test was conducted in um (or appropriate unit). 
- X and Y data dimension indicate the number of rows/columns in the data.
- For a test of 200um by 200um with a step size of 1um, these would be as follows:
X Data Dimension = 200
X Start = 0
X Stop = 200
Y Data Dimension = 200
Y Start = 0
Y Stop = 200

- Depth was unused in my work and left blank – it is likely an allowance for set depth testing, feel free to figure it out!
- Value expected and match cells read the data and extract the number of unique x and y points and their minimum and maximum, comparing with input values to inform the user of accuracy.

2.	Update Test 0001 Tagged

- The code will expect X and Y in columns G and H, starting at the 3rd cell downwards.
- The code will expect the following in columns A – F:
A: Surface Displacement -> Datastack S 
B: Depth -> Datastack D
C: Load -> Datastack L
D: Modulus -> Datastack M
E: Stiffness squared over load -> Datastack S2oL
F: Hardness -> Datastack H

The actual data in these can be modified in the plot_fig.m function as desired.

To use XPImport itself, assuming correct use of the template, the only part which needs to be interacted with should be XPInputDeck.m.

The variables should be as follows:
•	Filename = the name of your reformatted excel document
•	Filepath = The route to this on your computer (e.g. /Users/lukemulholland/ MATLAB/ XPressImport/)
•	Batchinfo = [1,1] (The number of maps being stitched together, i.e. 1 for a single map dataset)
•	Batchdims = [+1,+1] (The separation between maps, i.e. doesn’t matter for a single map dataset)
•	Cleanplotq =1 (This will stop NaN values from causing errors, but parameters which define how to plot are user defines within plotfig.m)
•	Resolution = ['-r' num2str(600)] (Define this for your dataset, it varies the resolution with which images will save)
