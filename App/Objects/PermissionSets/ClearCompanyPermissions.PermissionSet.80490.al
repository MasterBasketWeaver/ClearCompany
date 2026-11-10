permissionset 80490 "BACC Permissions"
{
    Caption = 'Clear Company Permissions';

    Assignable = true;
    Permissions = report "BACC Clear Company Data" = X,
        codeunit "BACC Clear Company Mgt." = X,
        page "BACC Select Company" = X;
}