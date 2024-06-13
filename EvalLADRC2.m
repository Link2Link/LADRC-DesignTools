function EvalLADRC2(P, wo, wc, b0)
% Evaluate the second order LADRC controller with given plant
% P = tf(16.454, conv([1, 0], conv([0.709, 1], [0.01, 1] )));
% wo = 100;
% wc = 10;
% b0 = 1;
% DesignLADRC2(P, wo, wc, b0);

[C, C1] = LADRC2(wo, wc, b0);
[Gm,Pm,Wcg,Wcp] = margin(P*C);
disp('PM = '+ string(Pm) + '°')
disp('wf = ' + string(Wcp)' + ' rad/s')
FeedbackLoop = feedback(P*C,1);
[mag,phase,wout] = bode(FeedbackLoop);
mag = mag(:);
wout = wout(:);
[~, k] = min(abs(mag - sqrt(2)/2));
BW = wout(k) / 2 / pi;
disp('Feedback loop BW = '+ string(BW) + ' Hz')
SystemLoop = feedback(P*C,1)*C1;
[mag, phase, wout] = bode(SystemLoop);
mag = mag(:);
wout = wout(:);
[~, k] = min(abs(mag - sqrt(2)/2));
BW = wout(k) / 2 / pi;
disp('System BW = '+ string(BW) + ' Hz')
%% plot the result 

figure("Position", [680 458 1120 420]);
subplot(1,2,1)
bode(SystemLoop)
title('Full system bode')
grid
subplot(1,2,2)
step(SystemLoop)
grid
title('Full system step response')

end