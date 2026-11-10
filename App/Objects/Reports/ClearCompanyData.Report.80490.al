report 80490 "BACC Clear Company Data"
{
    ProcessingOnly = true;
    UseRequestPage = false;
    UsageCategory = Tasks;
    ApplicationArea = all;
    Caption = 'Clear Company Non-Setup Data';

    trigger OnPreReport()
    var
        ClearCompanyMgt: Codeunit "BACC Clear Company Mgt.";
    begin
        ClearCompanyMgt.SelectCompaniesToClear();
    end;
}