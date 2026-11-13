permissionset 80480 "BACC Tests"
{
    Caption = 'Clear Company Tests';
    Assignable = true;
    Permissions = tabledata "BACC Test Result" = RIMD,
        tabledata "BACC Test Run" = RIMD,
        table "BACC Test Result" = X,
        table "BACC Test Run" = X,
        page "BACC Test Run API" = X,
        page "BACC Test Result API" = X,
        page "BACC Test Maintenance API" = X,
        table "BACC Test Maintenance" = X,
        codeunit "BACC Test Runner" = X,
        codeunit "BACC Test Run Context" = X,
        codeunit "BACC Test Run Mgt." = X,
        codeunit "BACC Assert" = X,
        codeunit "BACC Select Company Tests" = X,
        codeunit "BACC Clear Company Tests" = X;
}
