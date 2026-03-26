program Main;

uses
  Utils;

const
  COUNT = 50;
  MIN_VALUE = 0;
  MAX_VALUE = 100;

var
  arr: array of integer;
  i: integer;

begin
  SetLength(arr, COUNT);

  GenerateRandomNumbers(arr, MIN_VALUE, MAX_VALUE, COUNT);

  for i := 0 to Length(arr) - 1 do
    write(arr[i], ' ');
  writeln;

  writeln('sorted:');

  SortArray(arr);

  for i := 0 to Length(arr) - 1 do
    write(arr[i], ' ');
  writeln;
end.
