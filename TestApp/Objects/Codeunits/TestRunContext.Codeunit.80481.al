codeunit 80481 "BACC Test Run Context"
{
    // Carries the method filter from the run request into the test runner's triggers.
    SingleInstance = true;

    procedure SetMethodFilter(NewMethodFilter: Text)
    begin
        MethodFilter := NewMethodFilter;
    end;

    // The filter is a |-separated list of method names; blank selects every method.
    procedure IsSelected(FunctionName: Text): Boolean
    var
        MethodName: Text;
    begin
        if MethodFilter = '' then
            exit(true);
        foreach MethodName in MethodFilter.Split('|') do
            if MethodName.Trim().ToLower() = FunctionName.ToLower() then
                exit(true);
        exit(false);
    end;

    var
        MethodFilter: Text;
}
