function [K, Ti] = DesignPI(P, wf, PM)
s = tf('s');

resp = freqresp(P, wf);
phase = rad2deg(angle(resp));
if imag(resp) > 0
    phase = phase - 360;
end

require_phase = PM - (180+phase);
disp('Require phase compensate '+ string(require_phase))
if (require_phase > 0)
    disp('Need positive phase compensate, PI controller not work!');
    return;
elseif (require_phase <= -90)
    disp('Only I control is enough! Start design Integral controller');
    PI = 1/s;
    gain = norm(freqresp(PI*P, wf));
    K = 1/gain;
    Ti = 1;
    type = 'I';
    PI = K/s;
else
    gamma = tan(-deg2rad(require_phase));
    wi = wf * gamma;
    Ti = 1/wi;
    PI = 1+ 1/Ti/s;
    
    gain = norm(freqresp(PI*P, wf));
    K = 1/gain;
    type = "PI";
    PI = K*(1+ 1/Ti/s);
end

disp("Controller form: "+type)
disp('K : '+ string(K))
disp('Ti : '+ string(Ti))

[Gm,Pm,Wcg,Wcp] = margin(P*PI);
disp('Design result: ')
disp('PM = '+ string(Pm) + '°')
disp('wf = ' + string(Wcp)' + ' rad/s')


FeedbackLoop = feedback(P*PI,1);
[mag,phase,wout] = bode(FeedbackLoop);
mag = mag(:);
wout = wout(:);
[~, k] = min(abs(mag - sqrt(2)/2));
BW = wout(k) / 2 / pi;
disp('System BW = '+ string(BW) + ' Hz')

end