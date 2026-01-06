function out = centralPressureModel(type, normal, minimum, T_event, T_start, t)

% model of central preasure in cyclone
% normal : mean ambient pressure
% minimum: minimum pressure
% T_event: Time of event
% T_start: Time that the drop starts (say, 120 hours before T_event)
%
% t: time variable
%
% The model recovers to the normal pressure 120 hours after T_event

if strcmp(type,'linear')
    
    if t < T_start
        out = normal;
        return
    elseif t < T_event
        m = (normal-minimum)/(T_start - T_event);
        out = m*t + (normal - m*T_start);
        %out = ((minimum-1016)/(10*24))*t + minimum;
        return
    elseif t < (T_event + 120)
        m = (normal-minimum)/(120);
        out = m*t + (minimum - m*T_event);
        return
    else
        out = normal;
        return
    end
end


out = 980;
return
