table 80480 "BACC Test Result"
{
    Caption = 'Test Result';
    DataClassification = SystemMetadata;

    // Written from the test runner's OnAfterTestRun, outside the test's own transaction, so these rows
    // survive the rollback that test isolation performs on the test data.

    fields
    {
        field(1; "Entry No."; Integer)
        {
            AutoIncrement = true;
            Editable = false;
        }
        field(2; "Codeunit ID"; Integer)
        {
            Editable = false;
        }
        field(3; "Codeunit Name"; Text[100])
        {
            Editable = false;
        }
        field(4; "Method Name"; Text[128])
        {
            Editable = false;
        }
        field(5; Outcome; Enum "BACC Test Outcome")
        {
            Editable = false;
        }
        field(6; "Start Time"; DateTime)
        {
            Editable = false;
        }
        field(7; "Finish Time"; DateTime)
        {
            Editable = false;
        }
        field(8; Duration; Duration)
        {
            Editable = false;
        }
        field(9; "Error Message"; Text[2048])
        {
            Editable = false;
        }
        field(10; "Error Call Stack"; Text[2048])
        {
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Entry No.")
        {
            Clustered = true;
        }
        key(Outcome; Outcome) { }
    }

    procedure CountByOutcome(TestOutcome: Enum "BACC Test Outcome"): Integer
    var
        TestResult: Record "BACC Test Result";
    begin
        TestResult.SetRange(Outcome, TestOutcome);
        exit(TestResult.Count());
    end;
}
