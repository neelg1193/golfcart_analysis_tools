function [ gps ] = novatel_gps(S)
%NOVATEL_GPS reads novatel GPS data & returns struct of useful data
%   Detailed explanation goes here
    inspvax = finddata(S,'_novatel_data_inspvax');
    fix = finddata(S, '_navsat_fix');
    
    gps = struct();
    if(~isempty(fieldnames(inspvax)))
        Data = timeseries([inspvax.(16) inspvax.(17) inspvax.(18) inspvax.(20) inspvax.(21) inspvax.(22) inspvax.(23) inspvax.(24) inspvax.(25)], inspvax.(1));
        data = Data.data;
        time = Data.time;
    
        gps.time = time;
        gps.lat = data(:,1);
        gps.long = data(:,2);
        gps.alt = data(:,3);
        gps.Nspeed = data(:,4);
        gps.Espeed = data(:,5);
        gps.Uspeed = data(:,6);
        gps.roll = data(:,7);
        gps.pitch = data(:,8);
        gps.azimuth = data(:,9);
    
        [gps.N, gps.E, utmzone] = deg2utm(gps.lat,gps.long);
        gps.speed = sqrt(gps.Nspeed.^2+gps.Espeed.^2 + gps.Uspeed.^2);
    else
        if (~isempty(fieldnames(fix)))
        Data = timeseries([fix.(7) fix.(8) fix.(9)], fix.(1));
        data = Data.data;
        time = Data.time;
    
        gps.time = time;
        gps.lat = data(:,1);
        gps.long = data(:,2);
        gps.alt = data(:,3);
        [gps.N, gps.E, utmzone] = deg2utm(gps.lat,gps.long);    
        end
    end

%     gps.headingxy(:,1:2) = [sind(gps.heading) cosd(gps.heading)];
%     gps.speedxy(:,1:2) = [sind(gps.vheading).*gps.speed cosd(gps.vheading).*gps.speed];
end