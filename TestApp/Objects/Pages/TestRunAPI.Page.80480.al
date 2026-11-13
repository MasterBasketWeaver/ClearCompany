page 80480 "BACC Test Run API"
{
    //   POST .../api/bryanaBC/clearCompanyTest/v1.0/companies({companyId})/testRuns({id})/Microsoft.NAV.run
    //   POST .../testRuns({id})/Microsoft.NAV.runMethods  body {"methodFilter": "MethodA|MethodB"}
    // Synchronous: the call returns once every test has finished. Per-method detail is on testResults.

    PageType = API;
    APIPublisher = 'bryanaBC';
    APIGroup = 'clearCompanyTest';
    APIVersion = 'v1.0';
    EntityName = 'testRun';
    EntitySetName = 'testRuns';
    SourceTable = "BACC Test Run";
    ODataKeyFields = SystemId;
    Caption = 'Test Run';
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
                field(startedAt; Rec."Started At") { }
                field(finishedAt; Rec."Finished At") { }
                field(duration; Rec.Duration) { }
                field(testsRun; Rec."Tests Run") { }
                field(successful; Rec.Successful) { }
                field(failed; Rec.Failed) { }
                field(skipped; Rec.Skipped) { }
                field(methodFilter; Rec."Method Filter") { }
            }
        }
    }

    [ServiceEnabled]
    procedure run(var ActionContext: WebServiceActionContext)
    begin
        RunAndRespond(ActionContext, '');
    end;

    [ServiceEnabled]
    procedure runMethods(var ActionContext: WebServiceActionContext; methodFilter: Text)
    begin
        RunAndRespond(ActionContext, methodFilter);
    end;

    local procedure RunAndRespond(var ActionContext: WebServiceActionContext; MethodFilter: Text)
    var
        TestRunMgt: Codeunit "BACC Test Run Mgt.";
    begin
        TestRunMgt.RunSuite(MethodFilter);
        Rec.GetSingleton();

        ActionContext.SetObjectType(ObjectType::Page);
        ActionContext.SetObjectId(Page::"BACC Test Run API");
        ActionContext.AddEntityKey(Rec.FieldNo(SystemId), Rec.SystemId);
        ActionContext.SetResultCode(WebServiceActionResultCode::Updated);
    end;

    trigger OnOpenPage()
    begin
        // So the entity set is never empty for a caller looking up the key before posting the action.
        Rec.GetSingleton();
    end;
}
