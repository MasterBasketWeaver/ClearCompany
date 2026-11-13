codeunit 80480 "BACC Test Runner"
{
    // Implementing OnAfterTestRun also suppresses the platform's own results message, so the caller can report the run.

    Subtype = TestRunner;
    TestIsolation = Function;

    trigger OnRun()
    var
        CodeunitMetadata: Record "CodeUnit Metadata";
        ModuleInfo: ModuleInfo;
    begin
        // Every Subtype = Test codeunit in this app runs, so a new one cannot be left out of the suite.
        NavApp.GetCurrentModuleInfo(ModuleInfo);
        CodeunitMetadata.SetRange("App ID", ModuleInfo.Id);
        CodeunitMetadata.SetRange(SubType, CodeunitMetadata.SubType::Test);
        if CodeunitMetadata.FindSet() then
            repeat
                Codeunit.Run(CodeunitMetadata.ID);
            until CodeunitMetadata.Next() = 0;
    end;

    trigger OnBeforeTestRun(CodeunitId: Integer; CodeunitName: Text; FunctionName: Text; Permissions: TestPermissions): Boolean
    begin
        // A deselected method is neither executed nor logged. The blank name is the codeunit-level call and must never be skipped.
        if (FunctionName <> '') and not TestRunContext.IsSelected(FunctionName) then
            exit(false);
        StartTime := CurrentDateTime();
        exit(true);
    end;

    trigger OnAfterTestRun(CodeunitId: Integer; CodeunitName: Text; FunctionName: Text; Permissions: TestPermissions; Success: Boolean)
    var
        TestResult: Record "BACC Test Result";
        Assert: Codeunit "BACC Assert";
        FinishTime: DateTime;
        ErrorText: Text;
    begin
        // The codeunit-level call also reports failure when one of its methods failed; only log it when no method
        // was logged, i.e. the codeunit's OnRun failed before any method ran.
        if FunctionName = '' then begin
            TestResult.SetRange("Codeunit ID", CodeunitId);
            if Success or not TestResult.IsEmpty() then
                exit;
        end;

        FinishTime := CurrentDateTime();
        TestResult.Init();
        TestResult."Codeunit ID" := CodeunitId;
        TestResult."Codeunit Name" := CopyStr(CodeunitName, 1, MaxStrLen(TestResult."Codeunit Name"));
        if FunctionName = '' then
            TestResult."Method Name" := 'OnRun'
        else
            TestResult."Method Name" := CopyStr(FunctionName, 1, MaxStrLen(TestResult."Method Name"));
        TestResult."Start Time" := StartTime;
        TestResult."Finish Time" := FinishTime;
        TestResult.Duration := FinishTime - StartTime;
        if Success then
            TestResult.Outcome := TestResult.Outcome::Success
        else begin
            ErrorText := GetLastErrorText();
            if Assert.IsSkip(ErrorText) then begin
                TestResult.Outcome := TestResult.Outcome::Skipped;
                TestResult."Error Message" := CopyStr(Assert.SkipReason(ErrorText), 1, MaxStrLen(TestResult."Error Message"));
            end else begin
                TestResult.Outcome := TestResult.Outcome::Failure;
                TestResult."Error Message" := CopyStr(ErrorText, 1, MaxStrLen(TestResult."Error Message"));
                TestResult."Error Call Stack" := CopyStr(GetLastErrorCallStack(), 1, MaxStrLen(TestResult."Error Call Stack"));
            end;
        end;
        TestResult.Insert(true);
    end;

    var
        TestRunContext: Codeunit "BACC Test Run Context";
        StartTime: DateTime;
}
