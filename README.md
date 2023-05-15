# AsterSpectrogramCode
Sources longfile 100-day sac file from IRIS. Creates three subplots: acceleration seismogram, PSD (dB rel. 1 (m/s^2)^2/Hz), and PSD relative to median (rel. med.)

Save all files, download sac file from google drive. 
in Line 8, change to your file location after '!bin/ls ./... 
Ln 8: eval(['!/bin/ls ./Longfiles/DR01-2015-0-xx_',comp,'.sac > list.all'])
Run spectrogram_data_long_linF.m in Matlab.

Code written by Rick Aster, CSU
