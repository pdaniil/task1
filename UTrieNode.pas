unit UTrieNode;

interface

uses
  Classes, SysUtils, Windows, Messages, Variants, Graphics, Controls,
  Forms, ComCtrls,  StdCtrls, Menus, Dialogs, StrUtils;

const
  LowCh = 'a';
  HighCh = 'z';

type
  TIndex = LowCh..HighCh;

  TNode = class
  private
    FPoint: boolean;
    FNext: array[TIndex] of TNode;
  protected
    function GetNext(ch: TIndex): TNode;
    procedure SetNext(ch: TIndex; value: TNode);
  public
    constructor Create;
    destructor Destroy; override;

    function isEmpty:boolean;
    function IsCorrectChar(ch: char): boolean;
    function AddWord(var wrd: string; i: integer): boolean;
    function FindWord(var wrd: string; i: integer): boolean;
    function DelWord(var wrd: string; i: integer): boolean;
    procedure PrintAll(wrd:string; items:TTreeNodes);

    procedure PrintSomeWords(wrd:string; items:TTreeNodes);

    procedure PrintAllString(wrd:string; strings:TStrings);

    property Point: boolean read FPoint write FPoint;
    property Next[index: TIndex]: TNode read GetNext write SetNext;
  end;

implementation

function TNode.GetNext(ch: TIndex): TNode;
begin
  result:= FNext[ch];
end;

procedure TNode.SetNext(ch: TIndex; value: TNode);
begin
  if FNext[ch] <> value then
    begin
      FreeAndNil(FNext[ch]);
      FNext[ch]:= value;
    end;
end;

function TNode.isEmpty:boolean;
var
  ch: TIndex;
begin
  ch:= LowCh;
  Result:= not FPoint and (FNext[ch] = nil);
  if Result then
    repeat
      inc(ch);
      Result:= FNext[ch] = nil;
    until (ch = HighCh) or not Result;
end;

constructor TNode.Create;
var
  ch: TIndex;
begin
  Point:= false;
  for ch:= LowCh to HighCh do
    FNext[ch]:= nil;
end;

destructor TNode.Destroy;
var
  ch: TIndex;
begin
  for ch:= LowCh to HighCh do
    if FNext[ch] <> nil then
      FNext[ch].Destroy;
    inherited;
end;

function TNode.IsCorrectChar(ch: char): boolean;
begin
  result:= (ch >= LowCh) and (ch <= HighCh);
end;

function TNode.AddWord(var wrd: string; i: integer): boolean;
begin
  if i > length(wrd) then
    begin
      result:= not FPoint;
      FPoint:= true;
    end
  else
    if not IsCorrectChar(wrd[i]) then
      result:= false
    else
      begin
        if FNext[wrd[i]] = nil then
          FNext[wrd[i]]:=TNode.Create;
        result:= FNext[wrd[i]].AddWord(wrd, i+1);

        if not result and FNext[wrd[i]].isEmpty then
          FreeAndNil(FNext[wrd[i]]);
      end;
end;

function TNode.FindWord(var wrd: string; i: integer): boolean;
begin
  if i > length(wrd) then
    result:= FPoint
  else
    result:= IsCorrectChar(wrd[i]) and (FNext[wrd[i]] <> nil) and FNext[wrd[i]].FindWord(wrd, i+1);
end;

function TNode.DelWord(var wrd: string; i: integer): boolean;
begin
  if i > length(wrd) then
    begin
      result:= FPoint;
      FPoint:= false;
    end
  else
    if not IsCorrectChar(wrd[i]) or (FNext[wrd[i]] = nil) then
      result:= false
    else
      begin
        result:= FNext[wrd[i]].DelWord(wrd, i+1);
        if result and FNext[wrd[i]].IsEmpty then
          FreeAndNil(FNext[wrd[i]]);
      end;
end;

procedure AddNode(wrd: string; nodes:TTreeNodes);
var
  i, j: integer;
  OK: boolean;
  node: TTreeNode;
begin
  node:= nil;
  for i:=1 to Length(wrd) do
    begin
      j:=0;
      OK:= false;
      if node = nil then
        while (j <= nodes.Count - 1) and (node = nil) do
          begin
            if (wrd[i] = nodes[j].text[1]) and (nodes[j].Level = 0) then
              begin
                node:= nodes[j];
                OK:= true;
              end
            else
              inc(j);
          end
      else
        while (j <= node.Count - 1) and not OK do
          begin
            if (node.Item[j].text[1] = wrd[i]) then
              begin
                OK:= true;
                node:= node.Item[j];
              end
            else
              inc(j);
          end;
      if (node = nil) or not OK then
        node:= nodes.AddChild(node, wrd[i]);
      if i = Length(wrd) then
        node.Text:= wrd[i] + '.';
    end;
end;

procedure TNode.PrintAll(wrd:string; items:TTreeNodes);
var
  ch:Tindex;
begin
  if Fpoint then
    AddNode(wrd, items);
  for ch:= lowCh to HighCh do
    if FNext[ch] <> nil then
      begin
        wrd:=wrd+ch;
        FNext[ch].PrintAll(wrd, items);
        SetLength(wrd,length(wrd)-1);
      end;
end;

procedure TNode.PrintAllString(wrd:string; strings:TStrings);
var
  ch:Tindex;
begin
  if Fpoint then
    strings.add(wrd);
  for ch:= lowCh to HighCh do
    if FNext[ch] <> nil then
      begin
        wrd:=wrd+ch;
        FNext[ch].PrintAllString(wrd, strings);
        SetLength(wrd,length(wrd)-1);
      end;
end;

function IsPalyndrome(wrd: string):boolean;
var
  i: integer;
  OK: boolean;
begin
  i:= 1;
  OK:= true;
  while (i <= length(wrd) div 2) and OK do
    begin
      OK:= wrd[i] = wrd[length(wrd) - i + 1];
      inc(i);
    end;
  Result:= OK;
end;

procedure TNode.PrintSomeWords(wrd:string; items:TTreeNodes);
var
  ch:TIndex;
begin
  if FPoint and IsPalyndrome(wrd) then
    AddNode(wrd, items);
  for ch:= lowCh to HighCh do
    if FNext[ch] <> nil then
      begin
        wrd:=wrd+ch;
        FNext[ch].PrintSomeWords(wrd, items);
        SetLength(wrd,length(wrd)-1);
      end;
end;


end.

