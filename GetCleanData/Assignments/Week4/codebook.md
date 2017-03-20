## Description
This code book describes the variables in tinyDataset.txt
Created by run_analysis.R

## Variables
id = The subjects ID

type = Training Experiment or Testing Experiment

activity = What physical activity the subject was doing at the time of the measurement

=================

Body Acceleration Mean and STD Averages (units of g)

==================

bodyaccxmean = Average value of the body acceleration in the x direction

bodyaccxstd = Average value of the standard deviation of body acceleration in the x direction

bodyaccymean = Average value of the body acceleration in the y direction

bodyaccystd = Average value of the standard deviation of body acceleration in the y direction

bodyacczmean = Average value of the body acceleration in the z direction

bodyacczstd = Average value of the standard deviation of body acceleration in the z direction

==================

=================

Body Gyroscope Value Mean and STD Averages (units of degrees per second)

==================

bodygyroxmean = Average value of the body gyroscope value in the x direction

bodygyroxstd = Average value of the standard deviation of body gyroscope value in the x direction

bodygyroymean = Average value of the body gyroscope value in the y direction

bodygyroystd = Average value of the standard deviation of body gyroscope value in the y direction

bodygyrozmean = Average value of the body gyroscope value in the z direction

bodygyrozstd = Average value of the standard deviation of body gyroscope value in the z direction

==================

=================

Total Body Acceleration Mean and STD Averages (units of g)

==================

totalaccxmean = Average value of the total acceleration in the x direction

totalaccxstd = Average value of the standard deviation of total acceleration in the x direction

totalaccymean = Average value of the total acceleration in the y direction

totalaccystd = Average value of the standard deviation of total acceleration in the y direction

totalacczmean = Average value of the total acceleration in the z direction

totalacczstd = Average value of the standard deviation of total acceleration in the z direction

==================

## Calculation
For each row in each file containing the x,y,z measurements for body accel, gyro, and total accel values,
the average and standard deviation across all measurements in the row was taken. These values were added to a new
dataframe, keeping track of the subject, the measurement type (test|train), and the activity.

The resulting datafram was grouped into smaller dataframes by subject id and activity type. Averages all of the means and STDs
were then taken in each of these groups and added to a new dataframe: the tiny dataset.

Therefore, the tiny dataset contains averages of means and STD for all activities for each subject.
