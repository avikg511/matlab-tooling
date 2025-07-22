% Tests for AudioReadWrite class
% Clear the screen before this (not the variables)
clc; clear all

% Setting up paths to make sure the test file can manually access everything
addpath("./files")
addpath("./testing/")
addpath(".")

%% Test 1 - Make sure we can tell we haven't put in an audio file
% Test with the csv test data
try
    ar = AudioReadWrite("./testing/filereadertest.csv");
catch ME
    if strcmp(ME.identifier, "AudioReadWrite:InvalidFileType")
        disp("Test 1: Passed! Caught improper input file type (CSV is not an Audio File in this library)")
    else 
        disp("Test " + ME.identifier)
    end
end

%% Test 2 - Make sure we read in the audio file and can play the audio
ar = AudioReadWrite("./testing/audio_file.mp3");
ar.play()
disp("Test 2: Did you hear the audio? If so, test passed!")
pause(2)

%% Test 3 - Make sure we can e.g. filter the audio, and play it again
old_max = max(ar.audioData);
lpFilt = designfilt('lowpassiir', ...
    'PassbandFrequency', 300, ...
    'StopbandFrequency', 350, ...
    'PassbandRipple', 0.1, ...
    'StopbandAttenuation', 100, ...
    'SampleRate', ar.sampleRate);

newData = filter(lpFilt, ar.audioData);
ar.setAudioData(normalize(newData) * old_max);
ar.play()

[pxx, f] = pwelch(ar.audioData, hamming(2048), [], [], ar.sampleRate); % Visualize the PSD
[pxx2, f2] = pwelch(newData, hamming(2048), [], [], ar.sampleRate); % Visualize the PSD

% % Plot
% figure
% plot(f, 10*log10(pxx), 'b-', 'DisplayName', 'Original')
% hold on
% plot(f2, 10*log10(pxx2), 'r--', 'DisplayName', 'Filtered')
% hold off
% 
% title('Power Spectrum Before and After Filtering')
% xlabel('Frequency (Hz)')
% ylabel('Power/Frequency (dB/Hz)')
% legend
% grid on

% Play the audio
disp("Test 3: Does the audio feel low pass filtered? Higher frequencies should be attenuated. Tests modifying the vector")

%% Test 4: Plot Power Spectral Density (PSD) of the Audio file
ar = AudioReadWrite("./testing/audio_file.mp3");
ar.plotPSD();
disp("Test 4: Confirm that the PSD looks about right")

%% Test 5: Plot the Power spectral density of the saved wave and another one
ar.plotPSDAgainst(newData);     % Low pass filtered data from Test 3
disp("Test 5: Confirm that the PSDs look about right with respect to each other. This should be the same look as the one in Test 3")


