program TestUtils;

uses
  Utils, SysUtils;

procedure PrintResult(passed: boolean; testName: string);
begin
  if passed then
    writeln(testName, ': Passed')
  else
    writeln(testName, ': Failed');
end;

procedure TestGenerateRandomRange;
var
  arr: array[0..19] of integer;
  i: integer;
  passed: boolean;
begin
  GenerateRandomNumbers(arr, 5, 10, 20);
  passed := true;
  for i := 0 to 19 do
    if (arr[i] < 5) or (arr[i] > 10) then
      passed := false;
  PrintResult(passed, 'TestGenerateRandomRange');
end;

procedure TestGenerateRandomCountLimit;
var
  arr: array[0..4] of integer;
  i: integer;
  passed: boolean;
begin
  GenerateRandomNumbers(arr, 0, 10, 10);
  passed := true;
  for i := 0 to 4 do
    if (arr[i] < 0) or (arr[i] > 10) then
      passed := false;
  PrintResult(passed, 'TestGenerateRandomCountLimit');
end;

procedure TestGenerateRandomAllElementsAssigned;
var
  arr: array[0..4] of integer;
  i: integer;
  passed: boolean;
begin
  arr[0] := -1; arr[1] := -1; arr[2] := -1; arr[3] := -1; arr[4] := -1;
  GenerateRandomNumbers(arr, 0, 100, 5);
  passed := true;
  for i := 0 to 4 do
    if arr[i] < 0 then
      passed := false;
  PrintResult(passed, 'TestGenerateRandomAllElementsAssigned');
end;

procedure TestSortArrayOrder;
var
  arr: array[0..4] of integer;
  i: integer;
  passed: boolean;
begin
  arr[0] := 5; arr[1] := 2; arr[2] := 4; arr[3] := 1; arr[4] := 3;
  SortArray(arr);
  passed := true;
  for i := 0 to 4 do
    if arr[i] <> i + 1 then
      passed := false;
  PrintResult(passed, 'TestSortArrayOrder');
end;

procedure TestSortArrayAlreadySorted;
var
  arr: array[0..4] of integer;
  i: integer;
  passed: boolean;
begin
  arr[0] := 1; arr[1] := 2; arr[2] := 3; arr[3] := 4; arr[4] := 5;
  SortArray(arr);
  passed := true;
  for i := 0 to 4 do
    if arr[i] <> i + 1 then
      passed := false;
  PrintResult(passed, 'TestSortArrayAlreadySorted');
end;

begin
  TestGenerateRandomRange;
  TestGenerateRandomCountLimit;
  TestGenerateRandomAllElementsAssigned;
  TestSortArrayOrder;
  TestSortArrayAlreadySorted;
end.
