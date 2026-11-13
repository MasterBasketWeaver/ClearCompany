codeunit 80482 "BACC Test Run Mgt."
{
    procedure RunSuite(MethodFilter: Text)
    var
        TestResult: Record "BACC Test Result";
        TestRun: Record "BACC Test Run";
        TestRunContext: Codeunit "BACC Test Run Context";
        StartedAt: DateTime;
    begin
        TestResult.DeleteAll();
        TestRun.GetSingleton();
        StartedAt := CurrentDateTime();
        // Recorded before the run so a caller polling the API can tell a run has started and is not finished yet.
        TestRun."Started At" := StartedAt;
        TestRun."Finished At" := 0DT;
        TestRun."Method Filter" := CopyStr(MethodFilter, 1, MaxStrLen(TestRun."Method Filter"));
        TestRun.Modify();
        // A test runner cannot start inside an open write transaction.
        Commit();

        TestRunContext.SetMethodFilter(MethodFilter);
        Codeunit.Run(Codeunit::"BACC Test Runner");
        TestRunContext.SetMethodFilter('');

        TestRun.Get('');
        TestRun."Finished At" := CurrentDateTime();
        TestRun.Duration := TestRun."Finished At" - StartedAt;
        TestRun.Successful := TestResult.CountByOutcome(TestResult.Outcome::Success);
        TestRun.Failed := TestResult.CountByOutcome(TestResult.Outcome::Failure);
        TestRun.Skipped := TestResult.CountByOutcome(TestResult.Outcome::Skipped);
        TestRun."Tests Run" := TestRun.Successful + TestRun.Failed;
        TestRun.Modify();
    end;
}
