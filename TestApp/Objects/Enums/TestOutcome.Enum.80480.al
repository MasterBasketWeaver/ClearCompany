enum 80480 "BACC Test Outcome"
{
    Extensible = false;
    Caption = 'Test Outcome';

    value(0; Success)
    {
        Caption = 'Success';
    }
    value(1; Failure)
    {
        Caption = 'Failure';
    }
    value(2; Skipped)
    {
        Caption = 'Skipped';
    }
}
