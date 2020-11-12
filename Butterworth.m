%Butterworth Analog LPF parameters
Wc = 1.084;              %cut-off frequency
N = 8;                  %order 
f_samp = 330e3;

%poles 
p1 = - (1.06317 + 0.211478i);                   
p2 = - (1.06317 - 0.211478i);
p3 = - (0.901313 + 0.602238i);
p4 = - (0.901313 - 0.602238i);
p5 = - (0.602238 + 0.901313i);
p6 = - (0.602238 - 0.901313i);
p7 = - (0.211478 + 1.06317i);
p8 = - (0.211478 - 1.06317i);

%speifications
fp1 = 63.3e03;
fs1 = 59.3e03;
fs2 = 87.3e03;
fp2 = 83.3e3;

%Bilinear Transformation         
wp1 = tan(fp1/f_samp*pi);
ws1 = tan(fs1/f_samp*pi); 
ws2 = tan(fs2/f_samp*pi);
wp2 = tan(fp2/f_samp*pi);
disp(ws2);


%Parameters for Bandstop Transformation
W0 = sqrt(wp1*wp2);
B = wp2-wp1;
disp(B);

[num,den] = zp2tf([],[p1 p2 p3 p4 p5 p6 p7 p8],Wc^N);  
                                                       
%Evaluating Frequency Response of Final Filter
syms s z;
analog_lpf(s) = poly2sym(num,s)/poly2sym(den,s);    %analog lpf transfer function
analog_bpf(s) = analog_lpf((s*s +W0*W0)/(B*s));     %bandpass transformation
discrete_bpf(z) = analog_bpf((z-1)/(z+1));          %bilinear transformation

%coeffs of analog BPF
[ns, ds] = numden(analog_bpf(s));                   %numerical simplification
ns = sym2poly(expand(ns));                          
ds = sym2poly(expand(ds));                          %collect coeffs into matrix form
k = ds(1);    
ds = ds/k;                                          % k= coefficient of z^{0}
ns = ns/k;
disp(ns);
disp(ds);

%coeffs of discrete BPF
[nz, dz] = numden(discrete_bpf(z));                 %numerical simplification
nz = sym2poly(expand(nz));                          
dz = sym2poly(expand(dz));                          %collect coeffs into matrix form
k = dz(1);                                          %normalisation factor
dz = dz/k;
nz = nz/k;
disp(nz);
disp(dz);
fvtool(nz,dz)                                       %frequency response in dB

%magnitude plot (not in log scale) 
[H,f] = freqz(nz,dz,2048*2048, 330e3);
plot(f,abs(H))
grid                                                        
                                                        
