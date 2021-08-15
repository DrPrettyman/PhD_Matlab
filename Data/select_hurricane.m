function [start_date, end_date, h_name, station] = select_hurricane(input);
%SELECT_HURRICANE Summary of this function goes here
%   Detailed explanation goes here


switch input
   case 1
        h_name = 'Andrew';
        start_date = '07-01-1992';
        end_date = '10-01-1992'; 
        station = 2;
        stage = '';
    case 2
        h_name = 'FloydH';
        % note: Floyd did not hit Florida, it swerved and went north
        start_date = '08-01-1999';
        end_date = '10-01-1999'; 
        station = 2;
    case 3
        h_name = 'Charley';
        start_date = '06-23-2004';
        end_date = '08-23-2004';
        station = 36;
    case 4
        h_name = 'Frances';
        start_date = '07-20-2004';
        end_date = '09-15-2004';
        station = 2;
    case 5
        h_name = 'Jeanne';
        start_date = '09-20-2004';
        end_date = '09-30-2004';
        station = 2;
    case 6
        h_name = 'Katrina';
        start_date = '07-15-2005';
        end_date = '09-15-2005';
        station = 34;
    case 7
        % Rita for the purposes of separating from Katrina
        h_name = 'Rita';
        start_date = '09-15-2005';
        end_date = '09-28-2005';
        station = 35;
    case 8
        h_name = 'Ernesto';
        start_date = '08-01-2006';
        end_date = '09-10-2006'; 
        station = 2;
    case 9
        h_name = '(TS) Bonnie';
        start_date = '06-01-2010';
        end_date = '08-15-2010';
        station = 2;
    case 0
        h_name = 'Not a hurricane';
        start_date = '10-10-2005';
        end_date = '10-10-2006';
        station = 2;
    case 10
        h_name = 'Kenna';
        start_date = '09-15-2002';
        end_date = '10-28-2002';
        station = 19;
    case 11
        h_name = 'Haiyan';
        start_date = '11-01-2013';
        end_date = '11-30-2013'; 
        station = 22;
    case 12
        h_name = 'Zeb';
        start_date = '10-01-1998';
        end_date = '10-31-1998';  
        station = 23;
    case 13
        h_name = 'Megi';
        start_date = '10-12-2010';
        end_date = '10-24-2010';
        station = 23;
    case 14
        h_name = 'Hudhud';
        start_date = '10-07-2014';
        end_date = '10-14-2014';
        station = 24;
    case 15
        h_name = 'Mitch';
        start_date = '10-22-1998';
        end_date = '11-14-1998';
        station = 25;
    case 16
        h_name = 'Flo';
        start_date = '09-05-1990';
        end_date = '09-25-1990';
        station = 26;
    case 17
        h_name = 'Opal';
        start_date = '09-17-1995';
        end_date = '10-10-1995';
        station = 28;
    case 18
        h_name = 'Monica';
        start_date = '04-17-2006';
        end_date = '04-27-2006';
        station = 30;
    case 19
        h_name = 'Ivan';
        start_date = '09-02-2004';
        end_date = '09-27-2004';
        station = 31;
    case 20
        h_name = 'Dean';
        start_date = '08-10-2007';
        end_date = '08-30-2007';
        station = 32;
        
        
end

end

