table 80481 "BACC Test Run"
{
    Caption = 'Test Run';
    DataClassification = SystemMetadata;

    // Singleton with the summary of the most recent run; it gives the API an entity to bind the run actions to.

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Editable = false;
        }
        field(2; "Started At"; DateTime)
        {
            Editable = false;
        }
        field(3; "Finished At"; DateTime)
        {
            Editable = false;
        }
        field(4; Duration; Duration)
        {
            Editable = false;
        }
        field(5; "Tests Run"; Integer)
        {
            Editable = false;
        }
        field(6; Successful; Integer)
        {
            Editable = false;
        }
        field(7; Failed; Integer)
        {
            Editable = false;
        }
        field(8; Skipped; Integer)
        {
            Editable = false;
        }
        field(9; "Method Filter"; Text[2048])
        {
            Editable = false;
        }
    }

    keys
    {
        key(PK; "Primary Key")
        {
            Clustered = true;
        }
    }

    procedure GetSingleton()
    begin
        if Rec.Get('') then
            exit;

        Rec.Init();
        Rec.Insert();
    end;
}
