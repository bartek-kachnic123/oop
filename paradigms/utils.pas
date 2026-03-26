unit Utils;

interface

procedure GenerateRandomNumbers(var arr: array of integer; minVal, maxVal, count: integer);
procedure SortArray(var arr: array of integer);

implementation

procedure GenerateRandomNumbers(var arr: array of integer; minVal, maxVal, count: integer);
var
  i, n: integer;
begin
  Randomize;
  if count > Length(arr) then
    n := Length(arr)
  else
    n := count;

  for i := 0 to n - 1 do
    arr[i] := random(maxVal - minVal + 1) + minVal;
end;

procedure SortArray(var arr: array of integer);
var
  i, j, temp: integer;
begin
  for i := 0 to Length(arr) - 2 do
    for j := 0 to Length(arr) - i - 2 do
      if arr[j] > arr[j + 1] then
      begin
        temp := arr[j];
        arr[j] := arr[j + 1];
        arr[j + 1] := temp;
      end;
end;

end.
