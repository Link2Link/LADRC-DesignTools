function [C, C1] = LADRC1(wo, wc, b0)

s = tf('s');

beta{1} = 2*wo;
beta{2} = wo^2;
l{1} = wc;

C_num = (beta{1}*l{1}+beta{2})*s+beta{2}*l{1};
C_den = b0*s*(s+beta{1}+l{1});
C = C_num / C_den;
C1_num = (l{1}*(s^2 + beta{1}*s + beta{2}));
C1_den = (beta{2}*l{1} + s*(beta{2} + beta{1}*l{1}));
C1 = C1_num / C1_den;

end