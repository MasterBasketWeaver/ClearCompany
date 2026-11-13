codeunit 80483 "BACC Assert"
{
    // Stands in for Microsoft's "Library Assert", which is not installed in this environment. Method names and
    // argument order match it, so the tests read the same either way.

    procedure AreEqual(Expected: Variant; Actual: Variant; Message: Text)
    begin
        if Format(Expected, 0, 9) <> Format(Actual, 0, 9) then
            Error(AreEqualErr, Format(Expected, 0, 9), Format(Actual, 0, 9), Message);
    end;

    procedure AreNotEqual(Expected: Variant; Actual: Variant; Message: Text)
    begin
        if Format(Expected, 0, 9) = Format(Actual, 0, 9) then
            Error(AreNotEqualErr, Format(Expected, 0, 9), Message);
    end;

    procedure IsTrue(Condition: Boolean; Message: Text)
    begin
        if not Condition then
            Error(IsTrueErr, Message);
    end;

    procedure IsFalse(Condition: Boolean; Message: Text)
    begin
        if Condition then
            Error(IsFalseErr, Message);
    end;

    procedure RecordCount(RecordVariant: Variant; ExpectedCount: Integer)
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(RecordVariant);
        if RecRef.Count() <> ExpectedCount then
            Error(RecordCountErr, RecRef.Caption(), ExpectedCount, RecRef.Count(), RecRef.GetFilters());
    end;

    // The expected text only has to appear in the error that was caught, as in the library.
    procedure ExpectedError(Expected: Text)
    var
        ActualError: Text;
    begin
        ActualError := GetLastErrorText();
        if ActualError = '' then
            Error(NoErrorErr, Expected);
        if StrPos(ActualError, Expected) = 0 then
            Error(ExpectedErrorErr, Expected, ActualError);
    end;

    // Ends the test as Skipped rather than failed, e.g. when the environment lacks setup the test cannot create.
    procedure Skip(Reason: Text)
    begin
        Error(SkipPrefixTok + Reason);
    end;

    procedure IsSkip(ErrorText: Text): Boolean
    begin
        exit(ErrorText.StartsWith(SkipPrefixTok));
    end;

    procedure SkipReason(ErrorText: Text): Text
    begin
        exit(CopyStr(ErrorText, StrLen(SkipPrefixTok) + 1));
    end;

    var
        AreEqualErr: Label 'Expected %1 but got %2. %3', Comment = '%1 = expected value, %2 = actual value, %3 = message';
        AreNotEqualErr: Label 'Expected a value other than %1. %2', Comment = '%1 = value, %2 = message';
        IsTrueErr: Label 'Expected true. %1', Comment = '%1 = message';
        IsFalseErr: Label 'Expected false. %1', Comment = '%1 = message';
        RecordCountErr: Label 'Expected %2 %1 records but found %3. Filters: %4', Comment = '%1 = table, %2 = expected, %3 = actual, %4 = filters';
        NoErrorErr: Label 'Expected the error ''%1'' but no error was raised.', Comment = '%1 = expected error';
        ExpectedErrorErr: Label 'Expected an error containing ''%1'' but got ''%2''.', Comment = '%1 = expected error, %2 = actual error';
        SkipPrefixTok: Label 'BACC-SKIP: ', Locked = true;
}
