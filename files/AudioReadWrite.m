classdef AudioReadWrite < FileReader
  properties
    audioData
    timeData 
    sampleRate
  end

  properties (Constant)
    types = [".wav", ".mp3"]
  end

  % Properties from FileReader -- Cannot guobj.ntee it's updated
  % properties
  %   dirPath   string
  %   fileName  string
  %   ext       string
  %   fullPath  string
  % end


  methods
    function obj = AudioReadWrite(audioFile)
      % Check if file exists
      obj = obj@FileReader(audioFile);
      
      % Confirm it's an audio file. If any of the extensions obj. correctly matched
      %   the file is a valid audio file
      assert( any(obj.types == obj.ext), "AudioReadWrite:InvalidFileType", "Please pick a valid audio file. The current support is for { %s }, but we got %s.", strjoin(obj.types, ", "), obj.ext);

      % Read file
      [y, Fs] = audioread(obj.fullPath);

      obj.audioData = mean(y, 2);
      obj.sampleRate = Fs;
    end

    function play(obj)
      sound(obj.audioData, obj.sampleRate);
    end

    function setAudioData(obj, data)
      obj.audioData = data;
    end

    function plotPSD(obj)
      WIN_SIZE = 2048;
      assert(max(size(obj.audioData)) > WIN_SIZE);
      [pxx, f] = pwelch(obj.audioData, hamming(WIN_SIZE), [], [], obj.sampleRate); % Visualize the PSD

      % Plot
      figure
      plot(f, 10*log10(pxx))

      title(sprintf('Power Spectrum of %s', obj.fileName), "Interpreter", "none");
      xlabel('Frequency (Hz)')
      ylabel('Power/Frequency (dB/Hz)')
      legend
      grid on
    end

    function plotPSDAgainst(obj, recordTwo, recordTwoName)
      arguments
        obj AudioReadWrite
        recordTwo 
        recordTwoName string = "Another Wave"
      end
      WIN_SIZE = 2048;
      assert(max(size(obj.audioData)) > WIN_SIZE && max(size(recordTwo)) > WIN_SIZE, "Please ensure longer vectors or manually adjust the window size for this plot");
      [pxx, f] = pwelch(obj.audioData, hamming(WIN_SIZE), [], [], obj.sampleRate); % Visualize the PSD
      [pxx2, f2] = pwelch(recordTwo, hamming(WIN_SIZE), [], [], obj.sampleRate); % Visualize the PSD

      % Plot
      figure
      plot(f, 10*log10(pxx), 'b-', 'DisplayName', 'Original')
      hold on
      plot(f2, 10*log10(pxx2), 'r--', 'DisplayName', 'Filtered')
      hold off
      
      title(sprintf('Power Spectrum of %s and %s', obj.fileName, recordTwoName), 'Interpreter','none')
      xlabel('Frequency (Hz)')
      ylabel('Power/Frequency (dB/Hz)')
      legend
      grid on
    end
  end

end
