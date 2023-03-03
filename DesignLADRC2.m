function [wo, wc, b0] = DesignLADRC2(P, wf, PM)
% Design the second order LADRC controller
% P = tf(16.454, conv([1, 0], conv([0.709, 1], [0.01, 1] )));
% wf = 30;
% PM = 45;


load('gamma_map.mat');

s = tf('s');

resp = freqresp(P, wf);
phase = rad2deg(angle(resp));
if imag(resp) > 0
    phase = phase - 360;
end

require_phase = PM - (180+phase);
disp('Require phase compensate '+ string(require_phase))

[xData, yData] = prepareCurveData( phase2, gamma2 );

% Set up fittype and options.
ft = 'linearinterp';

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, 'Normalize', 'on' );

if (require_phase < phase2(1))
    gamma = 1;
elseif (require_phase > phase2(end))
    disp('The max phase compensate is ' + string(phase2(end)))
    disp('Not satisfied, please choose orther controller!');
    return;
else
    gamma = fitresult(require_phase);
end

disp('gamma : ' + string(gamma))

wo = wf * gamma;
wc = wf / gamma;
[C, C1] = LADRC2(wo, wc, 1);
b0 = norm(freqresp(P*C, wf));
[C, C1] = LADRC2(wo, wc, b0);

disp('wo : '+ string(wo))
disp('wc : '+ string(wc))
disp('b0 : '+ string(b0))

[Gm,Pm,Wcg,Wcp] = margin(P*C);
disp('Design result: ')
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

figure
subplot(1,2,1)
bode(SystemLoop)
title('Full system bode')
grid
subplot(1,2,2)
step(SystemLoop)
grid
title('Full system step response')


end