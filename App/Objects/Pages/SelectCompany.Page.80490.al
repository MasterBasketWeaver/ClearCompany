page 80490 "BACC Select Company"
{
    Caption = 'Select Company';
    ApplicationArea = all;
    UsageCategory = None;
    SourceTable = Company;
    // A copy of the companies, so ticking Selected never needs permission to modify the Company table.
    SourceTableTemporary = true;
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
                    Caption = 'Selected';

                    trigger OnValidate()
                    begin
                        SetCompanySelected(Rec.Name, SelectedLine);
                    end;
                }
            }
        }
    }

    var
        Selected: Dictionary of [Text[30], Boolean];
        SelectedLine: Boolean;

    trigger OnOpenPage()
    var
        Company: Record Company;
    begin
        if Company.FindSet() then
            repeat
                Rec := Company;
                Rec.Insert();
            until Company.Next() = 0;
        if Rec.FindFirst() then;
    end;

    // Per row rather than per current record, so every row shows its own tick.
    trigger OnAfterGetRecord()
    begin
        SelectedLine := IsCompanySelected(Rec.Name);
    end;

    procedure SetCompanySelected(CompanyToSelect: Text[30]; NewSelected: Boolean)
    begin
        if Selected.ContainsKey(CompanyToSelect) then
            Selected.Set(CompanyToSelect, NewSelected)
        else
            Selected.Add(CompanyToSelect, NewSelected);
    end;

    procedure IsCompanySelected(CompanyToCheck: Text[30]): Boolean
    begin
        if Selected.ContainsKey(CompanyToCheck) then
            exit(Selected.Get(CompanyToCheck));
        exit(false);
    end;

    // Ticked companies; when none is ticked, the rows highlighted when OK was pressed, as in any lookup.
    procedure GetSelectedCompanies(var SelectedCompanies: List of [Text[30]])
    begin
        GetTickedCompanies(SelectedCompanies);
        if SelectedCompanies.Count() = 0 then
            GetHighlightedCompanies(SelectedCompanies);
    end;

    procedure GetTickedCompanies(var SelectedCompanies: List of [Text[30]])
    var
        CompanyToDelete: Text[30];
    begin
        foreach CompanyToDelete in Selected.Keys() do
            if Selected.Get(CompanyToDelete) then
                SelectedCompanies.Add(CompanyToDelete);
    end;

    local procedure GetHighlightedCompanies(var SelectedCompanies: List of [Text[30]])
    var
        TempCompany: Record Company temporary;
    begin
        TempCompany.Copy(Rec, true);
        CurrPage.SetSelectionFilter(TempCompany);
        if TempCompany.FindSet() then
            repeat
                SelectedCompanies.Add(TempCompany.Name);
            until TempCompany.Next() = 0;
    end;
}
