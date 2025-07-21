classdef FileReader < handle
  properties
    dirPath   string
    fileName  string
    ext       string
    fullPath  string
  end

  methods
    function obj = FileReader(fPath)
      p = exist(fPath, "file");

      if p ~= 2
        error("Please choose a valid file path and ensure MATLAB has access to it (aka on $PATH, not from root, etc.) Given: %s", fPath);
      end

      % Extract variables now that we know the file exists.
      [dirPath, fileName, ext] = fileparts(fPath);

      % Storing variables
      obj.dirPath = dirPath;
      obj.fileName = fileName;
      obj.ext = ext;
      obj.fullPath = fPath;
    end
  end
end
