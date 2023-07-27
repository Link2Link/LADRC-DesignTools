function [Kp, Ti, Td, wc] = DesignPID(P, wf, PM)


s = tf('s');
resp = freqresp(P, wf);
phase = rad2deg(angle(resp));
if imag(resp) > 0
    phase = phase - 360;
end
require_phase = PM - (180+phase);

disp('Require phase compensate '+ string(require_phase))

if (require_phase > 90)
    disp('Need phase compensation large than 90, PID controller not work!');
    return;
end
if (require_phase <= -90)
    disp('Need phase compensation less than -90, PID controller not work!');
    return;
end

A = tan(deg2rad(require_phase));
gamma = A+sqrt(A^2+1);
wc = wf / gamma;
PID = 1 + wc/2/s + 1/2/wc*s;
gain = norm(freqresp(PID*P, wf));
K = 1/gain;
PID = K*PID;
Kp = K;
Ti = 2/wc;
Td = 1/2/wc;
disp("Controller form: PID");
disp('PID = Kp(1 + 1/Ti/s + Td*s')
disp('Kp : '+ string(Kp))
disp('Ti : '+ string(Ti))
disp('Td : '+ string(Td))

[Gm,Pm,Wcg,Wcp] = margin(P*PID);
disp('Design result: ')
disp('PM = '+ string(Pm) + '°')
disp('wf = ' + string(Wcp)' + ' rad/s')

FeedbackLoop = feedback(P*PID,1);
[mag,phase,wout] = bode(FeedbackLoop);
mag = mag(:);
wout = wout(:);
[~, k] = min(abs(mag - sqrt(2)/2));
BW = wout(k) / 2 / pi;
disp('System BW = '+ string(BW) + ' Hz')


%% plot the result 

figure
subplot(1,2,1)
bode(FeedbackLoop)
title('Full system bode')
grid
subplot(1,2,2)
step(FeedbackLoop)
grid
title('Full system step response')


end