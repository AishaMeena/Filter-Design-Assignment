%Chebyshev LPF parameters
D1 = 1/(0.85*0.85)-1;       %since delta is 0.15
epsilon = sqrt(D1);         %epsilon was set to this value to satisfy required inequality
N = 4;

% poles
p1 = -sin(pi/(2*N))*sinh(asinh(1/epsilon)/N)+1i*cos(pi/(2*N))*cosh(asinh(1/epsilon)/N);
p2 = -sin(pi/(2*N))*sinh(asinh(1/epsilon)/N)-1i*cos(pi/(2*N))*cosh(asinh(1/epsilon)/N);
p3 = -sin(3*pi/(2*N))*sinh(asinh(1/epsilon)/N)+1i*cos(3*pi/(2*N))*cosh(asinh(1/epsilon)/N);
p4 = -sin(3*pi/(2*N))*sinh(asinh(1/epsilon)/N)-1i*cos(3*pi/(2*N))*cosh(asinh(1/epsilon)/N); 
disp(p1);
disp(p2);
disp(p3);
disp(p4);

%evaluating the Transfer function of Chebyshev Analog LPF
n1 = [1 -p1-p2 p1*p2];
n2 = [1 -p3-p4 p3*p4];
den = conv(n1,n2);          %multiply n1 and n2, which are the two quadratic factors in the denominator
num = [den(5)*sqrt(1/(1+epsilon*epsilon))];        % even order, DC Gain set as 1/(1+ epsilon^2)^0.5
disp(num);                                          %den(5) is the product of all poles

%Band Edge speifications
fs1 = 51.5e3;
fp1 = 47.5e3;
fp2 = 75.5e3;
fs2 = 71.5e3;

%Bilinear Transformation
f_samp = 260e3;
ws1 = tan(fs1/f_samp*pi);          
wp1 = tan(fp1/f_samp*pi);
wp2 = tan(fp2/f_samp*pi);
ws2 = tan(fs2/f_samp*pi);

% Bandpass Transformation
W0 = sqrt(wp1*wp2);
B = wp2-wp1;
disp(B);
disp(W0);

% Frequency Response of Final Filter
syms s z;
analog_lpf(s) = poly2sym(num,s)/poly2sym(den,s);        %analog LPF Transfer Function
analog_bsf(s) = analog_lpf((B*s)/(s*s + W0*W0));        %bandstop transformation
discrete_bsf(z) = analog_bsf((z-1)/(z+1));              %bilinear transformation

%coeffs of analog bsf
[ns, ds] = numden(analog_bsf(s));                   %numerical simplification to collect coeffs
ns = sym2poly(expand(ns));                          
ds = sym2poly(expand(ds));                          %collect coeffs into matrix form
k = ds(1);                                             % coefficient of z^{0}   
ds = ds/k;
ns = ns/k;
disp(ns);                                           % coefficient of numerator
disp(ds);                                             % coefficient of denominator


%coeffs of discrete bsf
[nz, dz] = numden(discrete_bsf(z));                     %numerical simplification to collect coeffs                    
nz = sym2poly(expand(nz));
dz = sym2poly(expand(dz));                              %coeffs to matrix form
k = dz(1);                                              %normalisation factor
dz = dz/k;
nz = nz/k;
disp(nz);                                                % coefficient of numerator
disp(dz);                                                  % coefficient of ndenomenator

fvtool(nz,dz)                                           %frequency response

%magnitude plot (not in log scale) 
[H,f] = freqz(nz,dz,1024*1024, 260e3);
plot(f,abs(H))
grid