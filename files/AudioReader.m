classdef AudioReader < FileReader
  properties
    audioData
    timeData 
  end

  properties (Constant)
    types = [".wav", ".mp3"]
  end

  % Properties from FileReader -- Cannot guarantee it's updated
  % properties
  %   dirPath   string
  %   fileName  string
  %   ext       string
  %   fullPath  string
  % end


  methods
    function obj = AudioReader(audioFile)
      % Check if file exists
      obj = obj@FileReader(audioFile);
      
      % Confirm it's an audio file. If any of the extensions are correctly matched
      %   the file is a valid audio file
      assert( any(obj.types == obj.ext), "Please pick a valid audio file. The current support is for { %s }, but we got %s.", strjoin(obj.types, ", "), obj.ext);
    end
  end

end
