function EvalLADRC1(P, wo, wc, b0)


[C, C1] = LADRC1(wo, wc, b0);

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

figure("Position", [680 458 1120 420])
subplot(1,2,1)
bode(SystemLoop)
title('Full system bode')
grid
subplot(1,2,2)
step(SystemLoop)
grid
title('Full system step response')

end