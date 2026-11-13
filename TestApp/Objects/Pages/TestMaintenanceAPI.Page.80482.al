page 80482 "BACC Test Maintenance API"
{
    // Housekeeping for test runs that were cut off, when no web client is available:
    //   POST .../api/bryanaBC/clearCompanyTest/v1.0/companies({companyId})/testMaintenance  body {"command": "..."}
    //   sessions | stop:<session id> | companies | deleteTestCompanies

    PageType = API;
    APIPublisher = 'bryanaBC';
    APIGroup = 'clearCompanyTest';
    APIVersion = 'v1.0';
    EntityName = 'testMaintenance';
    EntitySetName = 'testMaintenance';
    SourceTable = "BACC Test Maintenance";
    SourceTableTemporary = true;
    ODataKeyFields = Command;
    Caption = 'Test Maintenance';
    DelayedInsert = true;
    ModifyAllowed = false;
    DeleteAllowed = false;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(command; Rec.Command) { }
                field(result; Rec.Result) { }
            }
        }
    }

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        Rec.Result := CopyStr(RunCommand(Rec.Command), 1, MaxStrLen(Rec.Result));
        Rec.Insert();
        exit(false);
    end;

    local procedure RunCommand(Command: Text): Text
    begin
        case true of
            Command = 'sessions':
                exit(ListSessions());
            Command.StartsWith('stop:'):
                exit(StopTestSession(Command.Substring(6)));
            Command = 'companies':
                exit(ListTestCompanies());
            Command = 'deleteTestCompanies':
                exit(DeleteTestCompanies());
        end;
        Error('Unknown command %1.', Command);
    end;

    local procedure ListSessions(): Text
    var
        ActiveSession: Record "Active Session";
        Lines: TextBuilder;
    begin
        if ActiveSession.FindSet() then
            repeat
                Lines.Append(StrSubstNo('%1|%2|%3|%4;', ActiveSession."Session ID", ActiveSession."Client Type",
                    Format(ActiveSession."Login Datetime", 0, 9), ActiveSession."User ID"));
            until ActiveSession.Next() = 0;
        exit(StrSubstNo('this session %1; %2', SessionId(), Lines.ToText()));
    end;

    local procedure StopTestSession(SessionText: Text): Text
    var
        SessionToStop: Integer;
    begin
        Evaluate(SessionToStop, SessionText);
        if SessionToStop = SessionId() then
            Error('Session %1 is this session.', SessionToStop);
        exit(Format(StopSession(SessionToStop)));
    end;

    local procedure ListTestCompanies(): Text
    var
        Company: Record Company;
        Lines: TextBuilder;
    begin
        Company.SetFilter(Name, TestCompanyFilter());
        if Company.FindSet() then
            repeat
                Lines.Append(Company.Name + ';');
            until Company.Next() = 0;
        exit(Lines.ToText());
    end;

    local procedure DeleteTestCompanies(): Text
    var
        Company: Record Company;
        Deleted: Integer;
    begin
        Company.SetFilter(Name, TestCompanyFilter());
        if Company.FindSet() then
            repeat
                Company.Delete(true);
                Deleted += 1;
            until Company.Next() = 0;
        exit(StrSubstNo('%1 deleted', Deleted));
    end;

    // Only companies the tests create, never a real one.
    local procedure TestCompanyFilter(): Text
    begin
        exit('BACC Test Company*');
    end;
}
