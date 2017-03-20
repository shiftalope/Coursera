## Purpose
The run_analysis.R ode for compiling Samsung accelerometer and gyroscope data
to create a tiny dataset that lists the average values of the means
and standard deviations of various measurements across 30 subjects and
6 activities. Requires the UCI_HAR_Dataset folder to be in the working directory
Outputs a text file with the tiny dataset

## Method
First the code construct a data frame from both the testing and training samples.
The ID numbers are linked with the type (train vs test) via the "subject" files
The various mesurements are extracted from the files found in "Inertial Signals" sub folder
Each instance (one row of data) from those files is averaged and the std is taken
These values are  added to a new dataframes. One for test and one for train
The testing and traing dataframes are then merged together
Finally, a tiny dataset is made by splitting the large dataset by id and activity.
The tiny dataset contains the averages for each measuremnt (accel/gyro/total mean/stds)
Grouped by id and activity.
