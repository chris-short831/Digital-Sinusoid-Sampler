
function [s_times,s_val, analog_freq,DFT_val] = sample_funk(N,Ts,f0,time_domain_plot,freq_domain_plot,sound)
%This function accepts inputs to sample and plot a sinusoid according to the user's specifications.
%N = number of samples
%Ts = sampling rate
%f0 = fundamental frequency of sinusoid
%time_domain_plot is a boolean variable. Any value here will create a plot.
%freq_domain_plot is a boolean variable. Any value here will create a plot.
%sound is a boolean variable. Any value here will play the sound of the sampled sinusoid .

%Handle missing parameters
if nargin == 6
    time_domain_plot = true; 
    freq_domain_plot = true;
    sound = true;
end 

if nargin == 5
    time_domain_plot = true; 
    freq_domain_plot = true;
    sound = false;
end

if nargin == 4
    time_domain_plot = true;
    freq_domain_plot = false;
    sound = false;
end

if nargin == 3
    time_domain_plot = false;
    freq_domain_plot = false;
    sound = false;
end

if nargin <3
    disp('Not enough input arguments');
    return
end

%create time vector and sample sin wave
Fs = 1/Ts;
t = 0:Ts:N*Ts;
y = 2*sin(2*pi*f0.*t);

%Obtain specified number of samples
s_times_idx = round(linspace(1,length(y),N));
s_val = y(s_times_idx);
t1 = t(s_times_idx);
s_times = t1;
%compute FT of sampled sine
DFT_val = fft(s_val);
%plot sin if time_domain_plot == true
if time_domain_plot == true
figure;
stem(t1,s_val);
grid on;
title('Sampled 2 V Sinusoid');
xlabel('Time (s)');
ylabel('Amplitude (V)');
end


%obtain analog frequencies and FT
t2 = 0:Ts:N*Ts; %time is extended to create sound of waveform 
%and create effective frequency plot 
y1 = 2*sin(2*pi*f0.*t2);
DFT = fft(y1);
f_axis = (0:length(DFT)-1).*Fs./length(DFT);
analog_freq_idx = round(linspace(1,length(f_axis),N));
analog_freq = f_axis(analog_freq_idx);
mag_y1_idx = round(linspace(1,length(DFT),N));
mag_y1 = DFT(mag_y1_idx); 

%plot One Sided and Two SidedFrequency Spectrum if Freq_plot = true
if freq_domain_plot == true
figure;
subplot(2,1,1)
plot(analog_freq,abs(mag_y1));
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('One Sided Spectrum of Sinisoid of f0 with N Samples')
grid on;

% Shift the frequency axis so the center+1 value is 0 
fshift_axis = analog_freq - analog_freq(floor(N/2)+1); 
% Plot the shifted spectrum 
subplot(2,1,2);
plot(fshift_axis, fftshift(abs(mag_y1))); 
grid on;
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Two Sided Spectrum of Sinisoid of f0 with N Samples')
end

%create sound of waveform
if sound == true 
soundsc(y1,Fs);

end
end