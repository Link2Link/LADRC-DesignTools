function EvalLADRC2(P, wo, wc, b0)
% Evaluate the second order LADRC controller with given plant
% P = tf(16.454, conv([1, 0], conv([0.709, 1], [0.01, 1] )));
% wo = 100;
% wc = 10;
% b0 = 1;
% DesignLADRC2(P, wo, wc, b0);

[C, C1] = LADRC2(wo, wc, b0);
L = P*C;   % openloop transfer function

Sensitivity = 1/(1+L);
Comp_Sensitivity = L/(1+L);

[mag,phase,wout] = bode(Comp_Sensitivity);
mag = mag(:);
Ms = max(mag);
disp('Ms = '+ string(Ms))
[Gm,Pm,Wcg,Wcp] = margin(L);
disp('PM = '+ string(Pm) + '°')
disp('wf = ' + string(Wcp)' + ' rad/s')
FeedbackLoop = feedback(L,1);
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

info = stepinfo(SystemLoop, 'SettlingTimeThreshold', 0.02);
disp('SettlingTime Time = '+ string(info.SettlingTime) + ' sec');
disp('Overshoot = '+ string(info.Overshoot));


%% plot the result 

figure("Position", [680 458 800 420]);
bode(Sensitivity)
grid
hold 
bode(Comp_Sensitivity)
title('Sensitivity Tranfer Fcuntion')
legend('Sensitivity', 'Compensate')

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