% Tests for TextReader class
% Clear the screen before this (not the variables)
clc

% Setting up paths to make sure the test file can manually access everything
addpath("./files")
addpath("./testing/")
addpath(".")

%% Test 1 - Input Text file and check if it is a csv
fr = TextReader("testing/filereadertest.txt");
assert(fr.is_csv() == 0, "TextReader has failed check to see if we're using a csv or not")
disp("Test 1: Load text file and check to make sure it's not a CSV -- Passed!")

%% Test 2 - Read CSV Table and confirm if values are values
fr = TextReader("testing/filereadertest.csv");
assert(fr.is_csv() == 1, "TextReader can't tell when we've inputted a CSV file");
disp("Test 2: Load a CSV file and check to make sure it's noted as CSV -- Passed!")

assert(fr.dirPath == "testing", "TextReader doesn't intuitively separate the directory to the file name, etc.")

[data, col_names] = fr.export_csv_as_mat();

assert(all(col_names == ["x", "y", "z", "t"]), "TextReader doesn't read the titles of CSV columns correctly")
disp("Test 3: Load a CSV and make sure the row names are properly loaded in")

assert(all(data(:, 4) == [883; 884; 885]), "TextReader could not extract the CSV properly (testing on the last column)")
disp("Test 4: TextReader could load in the CSV properly (checked last column only because integers)")

% End of tests!
disp(" ")
disp("==============================")
disp("All tests successfully passed!")
disp("==============================")