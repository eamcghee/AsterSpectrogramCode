# AsterSpectrogramCode

## 1. Uses a 100-day sac file retrieved from IRIS to create three subplots: 
 
  A. Acceleration seismogram
  
  B. Spectrogram, PSD (dB rel. 1 (m/s^2)^2/Hz)
  
  C. Spectrogram, PSD relative to median (rel. med.)

## 2. To test, download this sac file from google drive: 
  
  https://drive.google.com/file/d/11egI8_XAb1yyquZ9h0hBpF03mh-qD2D7/view?usp=sharing
  
  The sac file is: DR03-2016-0-xx_LHZ.sac
  
  Save it to a folder and copy the full file path. 
  For example: users/em/PROJECTS/ DR03-2016-0-xx_LHZ.sac
  
  Paste the file path in Line 8 in between the ‘…’
  
  •	For example, this code file path reads:
  eval(['!/bin/ls ./Longfiles/DR01-2015-0-xx_',comp,'.sac > list.all'
  
  •	Your edited file path might look something like is: 
  eval([‘users/em/PROJECTS/ DR03-2016-0-xx_LHZ.sac])

## 3. Libraries. 

  ‘monthday.m’ , ‘load_sac.m’ , and ‘bookfonts.m’ 

  Download these to the same folder you run this code from, or write an addpath line into this code. 
  
  For example: if the file monthday.m is located in the users/abc/projects directory, add this line to matlab script: addpath('/users/abc/projects');

## 4. Run spectrogram_data_long_linF.m in Matlab.

  Code written by Rick Aster, CSU, edited by Elisa McGhee, CSU.

