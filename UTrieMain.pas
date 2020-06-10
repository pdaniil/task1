// ¬ trie-дереве найти и напечатать все слова палиндромы
unit UTrieMain;

interface

uses
  UTrieGUI, UTrieTree, UTrieNode, Windows, Messages, SysUtils, Variants, Classes,
  Graphics, Controls, Forms, Dialogs, ToolWin, ComCtrls, ActnList, ImgList,
  Menus, ExtCtrls, StdCtrls;

type
  TfrmMain = class(TForm)
    MainMenu: TMainMenu;
    dfds1: TMenuItem;
    MnNew: TMenuItem;
    MnOpen: TMenuItem;
    MnSave: TMenuItem;
    MnSaveAs: TMenuItem;
    MnClose: TMenuItem;
    MnExit: TMenuItem;
    Edit1: TMenuItem;
    MnAdd: TMenuItem;
    MnFind: TMenuItem;
    MnDelete: TMenuItem;
    MnClear: TMenuItem;
    Process1: TMenuItem;
    MnTask: TMenuItem;
    ToolBar1: TToolBar;
    pnlMain: TPanel;
    lblMain: TLabel;
    ActList: TActionList;
    ActNew: TAction;
    ActSave: TAction;
    SaveDialog: TSaveDialog;
    OpenDialog: TOpenDialog;
    ActSaveAs: TAction;
    ActClose: TAction;
    ActAdd: TAction;
    ActDelete: TAction;
    ActClear: TAction;
    ActRun: TAction;
    ActOpen: TAction;
    ActFind: TAction;
    ImgList: TImageList;
    btnNew: TToolButton;
    btnOpen: TToolButton;
    sepr3: TToolButton;
    sepr1: TToolButton;
    btnSave: TToolButton;
    sepr4: TToolButton;
    btnAdd: TToolButton;
    sep5: TToolButton;
    btnDelete: TToolButton;
    sepr2: TToolButton;
    btnClear: TToolButton;
    ToolButton1: TToolButton;
    ActGoBack: TAction;
    pnlRes: TPanel;
    lblRes: TLabel;
    ActTask: TAction;
    saveRes: TMenuItem;
    ActSaveRes: TAction;
    ToolButton3: TToolButton;
    btnRun: TToolButton;
    tvResult: TTreeView;
    tv: TTreeView;
    procedure MnExitClick(Sender: TObject);
    procedure ActSaveExecute(Sender: TObject);
    procedure ActSaveAsExecute(Sender: TObject);
    procedure ActNewExecute(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ActCloseExecute(Sender: TObject);
    procedure ActAddExecute(Sender: TObject);
    procedure ActDeleteExecute(Sender: TObject);
    procedure ActClearExecute(Sender: TObject);
    procedure ActOpenExecute(Sender: TObject);
    procedure ActFindExecute(Sender: TObject);
    procedure ActTaskExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
  private
    TrTree: TTrieGUI;

    function CanCloseFile:boolean;
    function InputWord(Acaption: string; var wrd:string):boolean;
  public
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  OpenDialog.InitialDir:= ExtractFilePath(Application.ExeName);
  saveDialog.InitialDir:= openDialog.InitialDir;
  TrTree:= TTrieGUI.Create(tv, tvResult);
end;

function TfrmMain.InputWord(Acaption: string; var wrd:string):boolean;
begin
  result:=false;
  wrd:='';
  Acaption:=Acaption+'Words';
  if InputQuery(Acaption, 'Enter a word', wrd) then
    if TrTree.IsCorrectWord(wrd) then
      result:=true
    else
      Showmessage('InCorrect Word');
end;

function TfrmMain.CanCloseFile: boolean;
var
  ans:word;
begin
  result:=true;
  if (TrTree <> nil) and TrTree.Modified then
    begin
      ans:=MessageDlg('Save changes?', mtConfirmation, [mbYes,mbNo,mbCancel], 0);
      case ans of
        mrYes:
          begin
            actSave.Execute;
            result:=not TrTree.Modified;
          end;
        mrNo:;
        mrCancel: Result:=false;
      end;
    end;
  if Result then
    FreeAndNil(TrTree)
end;

procedure TfrmMain.MnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.ActSaveExecute(Sender: TObject);
begin
  if SaveDialog.FileName <> '' then
    TrTree.SaveToFile(TrTree.FileName)
  else
    actSaveAs.Execute;
end;

procedure TfrmMain.ActSaveAsExecute(Sender: TObject);
begin
  saveDialog.FileName:=TrTree.FileName;
  if saveDialog.Execute then
    TrTree.SaveToFile(saveDialog.FileName);
end;

procedure TfrmMain.ActNewExecute(Sender: TObject);
begin
  if CanCloseFile then
    TrTree:=TTrieGUI.Create(tv, tvResult);
end;

procedure TfrmMain.ActCloseExecute(Sender: TObject);
begin
  CanCloseFile;
end;

procedure TfrmMain.ActAddExecute(Sender: TObject);
var
  wrd:string;
  a: TTreeNode;
begin
  if InputWord('Addition', wrd) then
    if not TrTree.Add(wrd) then
      ShowMessage('That word has already been in the tree.');
end;

procedure TfrmMain.ActDeleteExecute(Sender: TObject);
var
  wrd : string;
begin
  if InputWord('Deletion',wrd) then
    if not TrTree.Delete(wrd) then
      MessageDlg('There is no such word.',mtError,[mbOk],0);
end;

procedure TfrmMain.ActClearExecute(Sender: TObject);
begin
  if MessageDlg('Are you sure you want to clear the tree?',
     mtConfirmation,[mbYes,mbNo], 0) = mrYes
  then
    TrTree.Clear;

end;

procedure TfrmMain.ActOpenExecute(Sender: TObject);
begin
  if openDialog.Execute and CanCloseFile then
    begin
      TrTree:=TTrieGUI.Create(tv, tvResult);
      if not TrTree.LoadFromFile(openDialog.FileName) then
        MessageDlg('Error during file reading.',mtError,[mbOk],0);
    end;
end;

procedure TfrmMain.ActFindExecute(Sender: TObject);
var
  wrd:string;
begin
  if inputWord('Search', wrd) then
    if TrTree.Find(wrd) then
      ShowMessage('The word is in the tree')
    else
      ShowMessage('The word is not in the tree');
end;

procedure TfrmMain.ActTaskExecute(Sender: TObject);
var
  num:integer;
  Str:string;
begin
  TrTree.PrintSomeWords;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose:=CanCloseFile;
end;

end.
