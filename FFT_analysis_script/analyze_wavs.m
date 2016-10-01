
clear

% This script needs to be run with GNU Octave
% it needs the modules octave-audio and (probably) octave-signal
% Last time it ran with GNU Octave, version 3.8.1

% This script analyzes the volumes of the 1 kHz signal
% of 64 individual .wav files which are located in 
% [current directory]/acquisition/
% and are named 001.wav, 002.wav ... 064.wav
% The attenuation is normalized to the value found for 064.wav.

function o=ampl_at_1000Hz(data)
  sample_length_s = 20;
  center_freq=1001*sample_length_s;
  side_band=3*sample_length_s;
  spec=abs(fft(data));
  o=sum(spec([center_freq-side_band:center_freq+side_band]));
end

x=[1:64];

for i=x
  data=auload(sprintf("./acquisition/%03d.wav",i));
  left=data(:,1);
  right=data(:,2);
  
  signal_ampl(i,1) = ampl_at_1000Hz(left);
  signal_ampl(i,2) = ampl_at_1000Hz(right);
%    printf("setting: %d, amplitude: %3.3f\n",i,signal_ampl(i));
end

signal_attenuation=signal_ampl./signal_ampl(end,:);

figure
plot(x,20*log10(signal_attenuation),"+");
xlabel("combi wiper pos");
ylabel("attenuation [dB]");
title("experiment");


