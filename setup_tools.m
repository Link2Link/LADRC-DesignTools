clear
clc


collect_gamma = [];
collect_phase = [];
for gamma = 1:1e-2:10
    phase = LADRC1_phase(gamma);
    collect_gamma = [collect_gamma, gamma];
    collect_phase = [collect_phase, phase];
end

gamma1 = collect_gamma;
phase1 = collect_phase;


collect_gamma = [];
collect_phase = [];
for gamma = 1:1e-2:10
    phase = LADRC2_phase(gamma);
    collect_gamma = [collect_gamma, gamma];
    collect_phase = [collect_phase, phase];
end

gamma2 = collect_gamma;
phase2 = collect_phase;
clear collect_gamma;
clear collect_phase;

save('gamma_map.mat','gamma1', 'phase1', 'gamma2', 'phase2');


function phase = LADRC2_phase(gamma)
    [C, ~] = LADRC2(gamma^2, 1, 1);
    phase = rad2deg(angle(freqresp(C, gamma)));
end

function phase = LADRC1_phase(gamma)
    [C, ~] = LADRC1(gamma^2, 1, 1);
    phase = rad2deg(angle(freqresp(C, gamma)));
end