classdef TextReader < FileReader
  properties
    data_tbl
    data_mat
    col_names
  end

  % Variables from FileReader -- Cannot guarantee it's updated properly
  % properties
  %   dirPath   string
  %   fileName  string
  %   ext       string
  %   fullPath  string
  % end

  methods
    function obj = TextReader(input_path)        
      obj@FileReader(input_path);
      p = exist(input_path, "file");

      if p ~= 2
        error("Please choose a valid file path and ensure MATLAB has access to it (aka on $PATH, not from root, etc.) Given: %s", input_path);
      end

      % Extract variables now that we know the file exists.
      [dirPath, fileName, ext] = fileparts(input_path);

      % Storing variables
      obj.dirPath = dirPath;
      obj.fileName = fileName;
      obj.ext = ext;
      obj.fullPath = input_path;

      % Fill in values from ctor
      if (obj.is_csv() == 1)
        obj.data_tbl                       = obj.export_csv_as_table();
        [obj.data_mat, obj.col_names]      = obj.export_csv_as_mat();
      end
    end

    function file_is_csv = is_csv(obj)
      % Checks to make sure we're working with a csv. If true, move forward
      file_is_csv = (obj.ext == ".csv");
    end

    function tbl = export_csv_as_table(obj)
      % Built in check to make sure we're working with a CSV
      assert(obj.is_csv() == 1, "Please only call this method for valid CSV files")

      % Actual processing
      tbl = readtable(obj.fullPath);
    end

    function [data, col_names] = export_csv_as_mat(obj)
      tbl = obj.export_csv_as_table();
      data = table2array(tbl);
      col_names = string(tbl.Properties.VariableNames);
    end

  end
end
