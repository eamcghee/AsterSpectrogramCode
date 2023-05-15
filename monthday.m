%MONTHDAY 
%   [month,day]=MONTHDAY(year,jday)returns the month and day of month given the year and day of year 
function [month,day]=monthday(year,jday)
    for mon=1:12
        ds(mon)=eomday(year,mon);
    end
    cday=cumsum(ds);
    for mon=1:12
        if jday-cday(mon) <= 0
            break
        end
    end
    month=mon;
    if mon==1
        day=jday;
    else
    day=jday-cday(mon-1);
    end
return

  
    
