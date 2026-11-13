page 80481 "BACC Test Result API"
{
    //   GET .../api/bryanaBC/clearCompanyTest/v1.0/companies({companyId})/testResults?$filter=outcome eq 'Failure'

    PageType = API;
    APIPublisher = 'bryanaBC';
    APIGroup = 'clearCompanyTest';
    APIVersion = 'v1.0';
    EntityName = 'testResult';
    EntitySetName = 'testResults';
    SourceTable = "BACC Test Result";
    ODataKeyFields = SystemId;
    Caption = 'Test Result';
    DelayedInsert = true;
    Editable = false;
    InsertAllowed = false;
    DeleteAllowed = false;
    ModifyAllowed = false;
    Extensible = false;

    layout
    {
        area(Content)
        {
            repeater(Group)
            {
                field(id; Rec.SystemId) { }
                field(entryNo; Rec."Entry No.") { }
                field(codeunitId; Rec."Codeunit ID") { }
                field(codeunitName; Rec."Codeunit Name") { }
                field(methodName; Rec."Method Name") { }
                field(outcome; Rec.Outcome) { }
                field(duration; Rec.Duration) { }
                field(errorMessage; Rec."Error Message") { }
                field(errorCallStack; Rec."Error Call Stack") { }
                field(startedAt; Rec."Start Time") { }
                field(finishedAt; Rec."Finish Time") { }
            }
        }
    }
}
