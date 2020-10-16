function [max_freq,idx] = maxFreq(signal,Fe,nMax)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
vec_freq = Fe/length(signal) * (0:length(signal)-1);
if nMax == 1
    [~,idx]=max(abs(fft(signal)));
    max_freq = vec_freq(idx);
else
    [~, idx_sorted] = sort(abs(fft(signal)),'descend');
    max_freq = zeros(nMax,1);
    idx = zeros(nMax,1);
    for maxima = 1:nMax
        idx(maxima) = idx_sorted(1+nMax*(maxima-1));
        max_freq(maxima) = vec_freq(idx(maxima));
    end 
end

