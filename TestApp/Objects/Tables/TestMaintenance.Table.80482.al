table 80482 "BACC Test Maintenance"
{
    Caption = 'Test Maintenance';
    DataClassification = SystemMetadata;
    TableType = Temporary;

    fields
    {
        field(1; Command; Text[100])
        {
        }
        field(2; Result; Text[2048])
        {
        }
    }

    keys
    {
        key(PK; Command)
        {
            Clustered = true;
        }
    }
}
