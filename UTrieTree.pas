unit UTrieTree;

interface

uses
  UTrieNode, SysUtils, Classes, Contnrs, ComCtrls, Dialogs;

type
  TTrieTree = class
  private
    FRoot: TNode;
  protected
    function AddHelp(wrd: string): boolean;
    procedure ClearHelp;
    function DeleteHelp(wrd: string): boolean;
  public
    constructor Create;
    destructor Destroy; override;

    function IsEmpty: boolean;
    procedure Clear;virtual;
    function Add(const wrd: string): boolean; virtual;
    function Find(const wrd: string): boolean;
    function Delete(wrd: string): boolean;   virtual;
    procedure PrintAll(items:TTreeNodes);
    procedure SaveToFile(FileName: string);
    function LoadFromFile(FileName: string): boolean;

    function IsCorrectWord(wrd: string): boolean;

    procedure PrintSomeWords(Tree:TTreeNodes); virtual;

  end;

implementation

constructor TTrieTree.Create;
begin
  FRoot:= nil;
end;

destructor TTrieTree.Destroy;
begin
  Clear;
  inherited;
end;

function TTrieTree.IsEmpty: boolean;
begin
  result:= FRoot = nil;
end;

procedure TTrieTree.ClearHelp;
begin
  if FRoot <> nil then
    FRoot.Destroy;
  FRoot:= nil;
end;

procedure TTrieTree.Clear;
begin
  ClearHelp;
end;

function TTrieTree.AddHelp(wrd: string): boolean;
begin
  if FRoot = nil then
    FRoot:= TNode.Create;
  Result:= FRoot.AddWord(wrd, 1);
  if not Result and FRoot.isEmpty then
    FreeAndNil(FRoot);
end;

function TTrieTree.Add(const wrd: string): boolean;
begin
  Result:= AddHelp(wrd);
end;

function TTrieTree.Find(const wrd: string): boolean;
var
  t: TNode;
  i, len: integer;
begin
  Result:= true;
  t:= FRoot;
  i:=1;
  len:= length(wrd);
  while (i<=len) and Result and (t <> nil) do
  if not FRoot.IsCorrectChar(wrd[i]) then
    Result:= false
  else
    begin
      t:= t.Next[wrd[i]];
      i:= i+1;
    end;
  Result:= Result and (t <> nil) and t.Point;
end;

function TTrieTree.DeleteHelp(wrd: string): boolean;
begin
  Result:= (FRoot <> nil) and FRoot.DelWord(wrd, 1);
  if Result and Froot.IsEmpty then
    FreeAndNil(FRoot)
end;

function TTrieTree.Delete(wrd: string): boolean;
begin
  Result:= DeleteHelp(wrd);
end;

procedure TTrieTree.PrintAll(items:TTreeNodes);
begin
  items.clear;
  if FRoot <> nil then
    FRoot.PrintAll('', items);
end;

procedure TTrieTree.SaveToFile(FileName: string);
var
  SL:TStrings;
begin
  SL:= TStringList.Create;
  if FRoot <> nil then
    FRoot.PrintAllString('', SL);
  SL.SaveToFile(FileName);
  SL.Destroy;
end;

function NextWord(str : string; var i : integer) : string;
var
  len : integer;
begin
  len:=length(str);
  while (i <= len)and(str[i] = ' ') do
    inc(i);
  Result:='';
  while (i <= len)and(str[i] <> ' ') do
    begin
      Result:=Result+str[i];
      inc(i);
    end
end;

function TTrieTree.LoadFromFile(FileName:string):boolean;
var
  f : TextFile;
  i,len : integer;
  str : string;
  wrd : string;
begin
  ClearHelp;
  Result:=true;
  assignfile(f,FileName);
  reset(f);
  while not eof(f) and Result do
    begin
      readln(f, str);
      str:=Trim(str);
      i:=1;
      Result:=true;
      len:=length(str);
      while (i<=len) {and Result} do
        begin
          wrd:=NextWord(str, i);
          Result:= IsCorrectWord(wrd) and addHelp(wrd);
        end;
    end;
  CloseFile(f);
end;

function TTrieTree.IsCorrectWord(wrd: string): boolean;
var
  i, len : integer;
begin
  i:=1;
  len:=Length(wrd);
  Result:=len<>0;
  while (i<=len) and Result do
    begin
      Result:= FRoot.IsCorrectChar(wrd[i]);
      inc(i);
    end;
end;

procedure TTrieTree.PrintSomeWords;
var
  Str:string;
begin
  tree.Clear;
  Str:='';
  if FRoot <> nil then
    FRoot.PrintSomeWords(Str, tree);
end;

end.
