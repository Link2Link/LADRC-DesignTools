function [wo, wc, b0] = DesignLADRC2(P, wf, PM)
% Design the second order LADRC controller
% P = tf(16.454, conv([1, 0], conv([0.709, 1], [0.01, 1] )));
% wf = 30;
% PM = 45;
% [wo, wc, b0] = DesignLADRC2(P, wf, PM);


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

disp('wo : '+ string(wo))
disp('wc : '+ string(wc))
disp('b0 : '+ string(b0))

disp('Design result: ')
EvalLADRC2(P, wo, wc, b0);



end