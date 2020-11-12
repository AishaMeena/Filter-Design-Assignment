f_samp = 330e3;

%Band Edge speifications
fs1 = 57.3e3;
fp1 = 63.3e3;
fp2 = 83.3e3;
fs2 = 87.3e3;

Wc1 = fp1*2*pi/f_samp;
Wc2  = fp2*2*pi/f_samp;

%Kaiser paramters
A = -20*log10(0.15);
if(A < 21)
    beta = 0;    % In our case it is zero
elseif(A <51)
    beta = 0.5842*(A-21)^0.4 + 0.07886*(A-21);
else
    beta = 0.1102*(A-8.7);
end

N_min = ceil((A-8) / (2.285*0.024*pi));
N_min = N_min +1;
n=N_min +17;
disp(n);                            % window length

%Ideal bandpass impulse response of length "n"
bp_ideal = ideal_lp(0.5175*pi,n) - ideal_lp(0.3717*pi,n);

%Kaiser Window of length "n" with shape paramter beta calculated above
kaiser_win = (kaiser(n,beta))';
FIR_BandPass = bp_ideal .* kaiser_win;
fvtool(FIR_BandPass);         %frequency response
disp(FIR_BandPass);

%magnitude response
[H,f] = freqz(FIR_BandPass,1,2048, f_samp);
plot(f,abs(H))
grid

% To obtain impulse sequence, uncomment to obtain the plot
%i=-33.5:1:33.5;
%stem(i,FIR_BandPass,'filled')