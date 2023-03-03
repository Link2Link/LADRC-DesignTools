function [C, C1] = LADRC2(wo, wc, b0)


beta1 = 3*wo;
beta2 = 3*wo^2;
beta3 = wo^3;

l1 = 2*wc;
l2 = wc^2;

s = tf('s');
C_num = (beta1*l2+beta2*l1+beta3)*s^2 + (beta2*l2+beta3*l1)*s+beta3*l2;
C_den = b0*s*(s^2+(beta1+l1)*s+beta1*l1+beta2+l2);
C = C_num / C_den;
C1_num = l2*(s^3+beta1*s^2+beta2*s+beta3);
C1_den = (beta1*l2+beta2*l1+beta3)*s^2+(beta2*l2+beta3*l1)*s+beta3*l2;
C1 = C1_num / C1_den;

end