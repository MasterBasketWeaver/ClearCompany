page 80490 "BACC Select Company"
{
    Caption = 'Select Company';
    ApplicationArea = all;
    UsageCategory = None;
    SourceTable = Company;
    InsertAllowed = false;
    DeleteAllowed = false;
    PageType = List;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Name; Rec.Name)
                {
                    Editable = false;
                }
                field("Display Name"; Rec."Display Name")
                {
                    Editable = false;
                }
                field(Selected; SelectedLine)
                {
                    trigger OnValidate()
                    begin
                        if Selected.ContainsKey(Rec.Name) then
                            Selected.Set(Rec.Name, SelectedLine)
                        else
                            Selected.Add(Rec.Name, SelectedLine);
                    end;
                }
            }
        }
    }

    var
        Selected: Dictionary of [Text[30], Boolean];
        SelectedLine: Boolean;

    trigger OnOpenPage()
    begin
        if Rec.FindSet() then
            repeat
                Selected.Add(Rec.Name, false);
            until Rec.Next() = 0;
    end;

    trigger OnAfterGetCurrRecord()
    begin
        if Selected.ContainsKey(Rec.Name) then
            SelectedLine := Selected.Get(Rec.Name)
        else
            SelectedLine := false;
    end;

    procedure GetSelectedCompanies(var SelectedCompanies: List of [Text[30]])
    var
        CompanyToDelete: Text[30];
    begin
        foreach CompanyToDelete in Selected.Keys() do
            if Selected.Get(CompanyToDelete) then
                SelectedCompanies.Add(CompanyToDelete);
    end;
}