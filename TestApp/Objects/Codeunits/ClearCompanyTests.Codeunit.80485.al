codeunit 80485 "BACC Clear Company Tests"
{
    // Each test creates its own companies and clears those, never a real company; test isolation removes them again.
    Subtype = Test;
    Permissions =
        tabledata Company = RIMD,
        tabledata "Sales Header" = RIMD,
        tabledata "Sales Line" = RIMD,
        tabledata "Sales Comment Line" = RIMD,
        tabledata "Sales Shipment Header" = RIMD,
        tabledata "Sales Shipment Line" = RIMD,
        tabledata "Sales Invoice Header" = RIMD,
        tabledata "Sales Invoice Line" = RIMD,
        tabledata "Sales Cr.Memo Header" = RIMD,
        tabledata "Sales Cr.Memo Line" = RIMD,
        tabledata "Purchase Header" = RIMD,
        tabledata "Purchase Line" = RIMD,
        tabledata "Purch. Rcpt. Header" = RIMD,
        tabledata "Purch. Rcpt. Line" = RIMD,
        tabledata "Purch. Inv. Header" = RIMD,
        tabledata "Purch. Inv. Line" = RIMD,
        tabledata "Purch. Cr. Memo Hdr." = RIMD,
        tabledata "Purch. Cr. Memo Line" = RIMD,
        tabledata "Production Order" = RIMD,
        tabledata "Prod. Order Line" = RIMD,
        tabledata "Prod. Order Component" = RIMD,
        tabledata "Prod. Order Routing Line" = RIMD,
        tabledata "Prod. Order Capacity Need" = RIMD,
        tabledata "Prod. Order Routing Tool" = RIMD,
        tabledata "Prod. Order Routing Personnel" = RIMD,
        tabledata "Prod. Order Rtng Qlty Meas." = RIMD,
        tabledata "Prod. Order Comment Line" = RIMD,
        tabledata "Prod. Order Rtng Comment Line" = RIMD,
        tabledata "Prod. Order Comp. Cmt Line" = RIMD,
        tabledata "FA Ledger Entry" = RIMD,
        tabledata "Depreciation Book" = RIMD,
        tabledata "FA Depreciation Book" = RIMD,
        tabledata "FA Allocation" = RIMD,
        tabledata "Assembly Header" = RIMD,
        tabledata "Assembly Line" = RIMD,
        tabledata "Assemble-to-Order Link" = RIMD,
        tabledata "Assembly Comment Line" = RIMD,
        tabledata "Posted Assembly Header" = RIMD,
        tabledata "Posted Assembly Line" = RIMD,
        tabledata "Posted Assemble-to-Order Link" = RIMD,
        tabledata "ATO Sales Buffer" = RIMD,
        tabledata "Time Sheet Header" = RIMD,
        tabledata "Time Sheet Line" = RIMD,
        tabledata "Time Sheet Detail" = RIMD,
        tabledata "Time Sheet Comment Line" = RIMD,
        tabledata "Purch. Comment Line" = RIMD,
        tabledata "Comment Line" = RIMD,
        tabledata "Warehouse Comment Line" = RIMD,
        tabledata "Service Comment Line" = RIMD,
        tabledata "Manufacturing Comment Line" = RIMD,
        tabledata "Routing Comment Line" = RIMD,
        tabledata "Production BOM Comment Line" = RIMD,
        tabledata "Service Header" = RIMD,
        tabledata "Service Item Line" = RIMD,
        tabledata "Service Line" = RIMD,
        tabledata "Service Ledger Entry" = RIMD,
        tabledata "Warranty Ledger Entry" = RIMD,
        tabledata "Service Shipment Item Line" = RIMD,
        tabledata "Service Shipment Header" = RIMD,
        tabledata "Service Shipment Line" = RIMD,
        tabledata "Service Invoice Header" = RIMD,
        tabledata "Service Invoice Line" = RIMD,
        tabledata "Service Cr.Memo Header" = RIMD,
        tabledata "Service Cr.Memo Line" = RIMD,
        tabledata "G/L Entry" = RIMD,
        tabledata "Cust. Ledger Entry" = RIMD,
        tabledata "Vendor Ledger Entry" = RIMD,
        tabledata "Item Ledger Entry" = RIMD,
        tabledata "G/L Budget Entry" = RIMD,
        tabledata "Job Ledger Entry" = RIMD,
        tabledata "Reversal Entry" = RIMD,
        tabledata "G/L Entry - VAT Entry Link" = RIMD,
        tabledata "VAT Entry" = RIMD,
        tabledata "Bank Account Ledger Entry" = RIMD,
        tabledata "Check Ledger Entry" = RIMD,
        tabledata "Reservation Entry" = RIMD,
        tabledata "Cost Entry" = RIMD,
        tabledata "Value Entry" = RIMD,
        tabledata "G/L Register" = RIMD,
        tabledata "Fixed Asset" = RIMD,
        tabledata "FA Setup" = RIMD,
        tabledata "FA Posting Type Setup" = RIMD,
        tabledata "FA Journal Setup" = RIMD,
        tabledata "FA Posting Group" = RIMD,
        tabledata "FA Class" = RIMD,
        tabledata "FA Subclass" = RIMD,
        tabledata "FA Location" = RIMD;

    var
        Assert: Codeunit "BACC Assert";
        ConfirmReplies: List of [Boolean];
        ConfirmQuestions: List of [Text];
        Messages: List of [Text];

    [Test]
    [HandlerFunctions('ConfirmHandler,MessageHandler')]
    // Tables the tenant's licence won't let the test write to (e.g. Production Order without Manufacturing) are
    // skipped: no posting can fill them there either.
    procedure EveryListedTableIsCleared()
    var
        TableIds: List of [Integer];
        FilledTableIds: List of [Integer];
        TableId: Integer;
        NotCleared: TextBuilder;
        NotInserted: TextBuilder;
    begin
        Initialize();
        CreateTestCompany(CompanyA());
        ClearCompanyMgt.GetTablesToClear(TableIds);
        foreach TableId in TableIds do
            if TryInsertRecord(TableId, CompanyA()) then
                FilledTableIds.Add(TableId)
            else
                if not GetLastErrorText().Contains('license does not grant') then
                    NotInserted.Append(StrSubstNo(' %1: %2', TableId, GetLastErrorText()));
        Assert.AreEqual('', NotInserted.ToText(), 'Setup: tables the test could not fill.');

        ClearCompanies(CompanyA(), true, true);

        foreach TableId in FilledTableIds do
            if HasRecords(TableId, CompanyA()) then
                NotCleared.Append(StrSubstNo(' %1', TableId));
        Assert.AreEqual('', NotCleared.ToText(), 'Tables still holding rows after clearing.');
    end;

    [Test]
    procedure ClearListHasExpectedTables()
    var
        TableIds: List of [Integer];
        ExpectedTableIds: List of [Integer];
        TableId: Integer;
    begin
        ExpectedTableIds.Add(Database::"Sales Header");
        ExpectedTableIds.Add(Database::"Sales Line");
        ExpectedTableIds.Add(Database::"Sales Comment Line");
        ExpectedTableIds.Add(Database::"Sales Shipment Header");
        ExpectedTableIds.Add(Database::"Sales Shipment Line");
        ExpectedTableIds.Add(Database::"Sales Invoice Header");
        ExpectedTableIds.Add(Database::"Sales Invoice Line");
        ExpectedTableIds.Add(Database::"Sales Cr.Memo Header");
        ExpectedTableIds.Add(Database::"Sales Cr.Memo Line");
        ExpectedTableIds.Add(Database::"Purchase Header");
        ExpectedTableIds.Add(Database::"Purchase Line");
        ExpectedTableIds.Add(Database::"Purch. Rcpt. Header");
        ExpectedTableIds.Add(Database::"Purch. Rcpt. Line");
        ExpectedTableIds.Add(Database::"Purch. Inv. Header");
        ExpectedTableIds.Add(Database::"Purch. Inv. Line");
        ExpectedTableIds.Add(Database::"Purch. Cr. Memo Hdr.");
        ExpectedTableIds.Add(Database::"Purch. Cr. Memo Line");
        ExpectedTableIds.Add(Database::"Production Order");
        ExpectedTableIds.Add(Database::"Prod. Order Line");
        ExpectedTableIds.Add(Database::"Prod. Order Component");
        ExpectedTableIds.Add(Database::"Prod. Order Routing Line");
        ExpectedTableIds.Add(Database::"Prod. Order Capacity Need");
        ExpectedTableIds.Add(Database::"Prod. Order Routing Tool");
        ExpectedTableIds.Add(Database::"Prod. Order Routing Personnel");
        ExpectedTableIds.Add(Database::"Prod. Order Rtng Qlty Meas.");
        ExpectedTableIds.Add(Database::"Prod. Order Comment Line");
        ExpectedTableIds.Add(Database::"Prod. Order Rtng Comment Line");
        ExpectedTableIds.Add(Database::"Prod. Order Comp. Cmt Line");
        ExpectedTableIds.Add(Database::"FA Ledger Entry");
        ExpectedTableIds.Add(Database::"Depreciation Book");
        ExpectedTableIds.Add(Database::"FA Depreciation Book");
        ExpectedTableIds.Add(Database::"FA Allocation");
        ExpectedTableIds.Add(Database::"Assembly Header");
        ExpectedTableIds.Add(Database::"Assembly Line");
        ExpectedTableIds.Add(Database::"Assemble-to-Order Link");
        ExpectedTableIds.Add(Database::"Assembly Comment Line");
        ExpectedTableIds.Add(Database::"Posted Assembly Header");
        ExpectedTableIds.Add(Database::"Posted Assembly Line");
        ExpectedTableIds.Add(Database::"Posted Assemble-to-Order Link");
        ExpectedTableIds.Add(Database::"ATO Sales Buffer");
        ExpectedTableIds.Add(Database::"Time Sheet Header");
        ExpectedTableIds.Add(Database::"Time Sheet Line");
        ExpectedTableIds.Add(Database::"Time Sheet Detail");
        ExpectedTableIds.Add(Database::"Time Sheet Comment Line");
        ExpectedTableIds.Add(Database::"Purch. Comment Line");
        ExpectedTableIds.Add(Database::"Comment Line");
        ExpectedTableIds.Add(Database::"Warehouse Comment Line");
        ExpectedTableIds.Add(Database::"Service Comment Line");
        ExpectedTableIds.Add(Database::"Manufacturing Comment Line");
        ExpectedTableIds.Add(Database::"Routing Comment Line");
        ExpectedTableIds.Add(Database::"Production BOM Comment Line");
        ExpectedTableIds.Add(Database::"Service Header");
        ExpectedTableIds.Add(Database::"Service Item Line");
        ExpectedTableIds.Add(Database::"Service Line");
        ExpectedTableIds.Add(Database::"Service Ledger Entry");
        ExpectedTableIds.Add(Database::"Warranty Ledger Entry");
        ExpectedTableIds.Add(Database::"Service Shipment Item Line");
        ExpectedTableIds.Add(Database::"Service Shipment Header");
        ExpectedTableIds.Add(Database::"Service Shipment Line");
        ExpectedTableIds.Add(Database::"Service Invoice Header");
        ExpectedTableIds.Add(Database::"Service Invoice Line");
        ExpectedTableIds.Add(Database::"Service Cr.Memo Header");
        ExpectedTableIds.Add(Database::"Service Cr.Memo Line");
        ExpectedTableIds.Add(Database::"G/L Entry");
        ExpectedTableIds.Add(Database::"Cust. Ledger Entry");
        ExpectedTableIds.Add(Database::"Vendor Ledger Entry");
        ExpectedTableIds.Add(Database::"Item Ledger Entry");
        ExpectedTableIds.Add(Database::"G/L Budget Entry");
        ExpectedTableIds.Add(Database::"Job Ledger Entry");
        ExpectedTableIds.Add(Database::"Reversal Entry");
        ExpectedTableIds.Add(Database::"G/L Entry - VAT Entry Link");
        ExpectedTableIds.Add(Database::"VAT Entry");
        ExpectedTableIds.Add(Database::"Bank Account Ledger Entry");
        ExpectedTableIds.Add(Database::"Check Ledger Entry");
        ExpectedTableIds.Add(Database::"Reservation Entry");
        ExpectedTableIds.Add(Database::"Cost Entry");
        ExpectedTableIds.Add(Database::"Value Entry");
        ExpectedTableIds.Add(Database::"G/L Register");

        ClearCompanyMgt.GetTablesToClear(TableIds);

        Assert.AreEqual(ExpectedTableIds.Count(), TableIds.Count(), 'Number of tables cleared.');
        foreach TableId in ExpectedTableIds do
            Assert.IsTrue(TableIds.Contains(TableId), StrSubstNo('Table %1 is cleared.', TableId));
    end;

    [Test]
    procedure FixedAssetTablesAreNotInClearList()
    var
        TableIds: List of [Integer];
        KeptTableIds: List of [Integer];
        TableId: Integer;
    begin
        GetKeptTables(KeptTableIds);

        ClearCompanyMgt.GetTablesToClear(TableIds);

        foreach TableId in KeptTableIds do
            Assert.IsFalse(TableIds.Contains(TableId), StrSubstNo('Table %1 is kept.', TableId));
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler,MessageHandler')]
    procedure FixedAssetTablesAreKept()
    var
        KeptTableIds: List of [Integer];
        TableId: Integer;
    begin
        Initialize();
        CreateTestCompany(CompanyA());
        GetKeptTables(KeptTableIds);
        foreach TableId in KeptTableIds do
            InsertRecord(TableId, CompanyA());
        InsertRecord(Database::"G/L Entry", CompanyA());

        ClearCompanies(CompanyA(), true, true);

        foreach TableId in KeptTableIds do
            Assert.IsTrue(HasRecords(TableId, CompanyA()), StrSubstNo('Table %1 keeps its rows.', TableId));
        Assert.IsFalse(HasRecords(Database::"G/L Entry", CompanyA()), 'G/L Entry is cleared in the same run.');
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler,MessageHandler')]
    procedure OnlyFixedAssetCommentLinesAreKept()
    var
        CommentLine: Record "Comment Line";
    begin
        Initialize();
        CreateTestCompany(CompanyA());
        InsertCommentLine(CommentLine."Table Name"::"Fixed Asset", CompanyA());
        InsertCommentLine(CommentLine."Table Name"::Insurance, CompanyA());
        InsertCommentLine(CommentLine."Table Name"::Customer, CompanyA());
        InsertCommentLine(CommentLine."Table Name"::Item, CompanyA());

        ClearCompanies(CompanyA(), true, true);

        Assert.IsTrue(HasCommentLine(CommentLine."Table Name"::"Fixed Asset", CompanyA()), 'Fixed Asset comments are kept.');
        Assert.IsFalse(HasCommentLine(CommentLine."Table Name"::Insurance, CompanyA()), 'Insurance comments are cleared.');
        Assert.IsFalse(HasCommentLine(CommentLine."Table Name"::Customer, CompanyA()), 'Customer comments are cleared.');
        Assert.IsFalse(HasCommentLine(CommentLine."Table Name"::Item, CompanyA()), 'Item comments are cleared.');
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler,MessageHandler')]
    procedure OnlySelectedCompanyIsCleared()
    var
        GLEntry: Record "G/L Entry";
        CurrentCompanyGLEntries: Integer;
    begin
        Initialize();
        CreateTestCompany(CompanyA());
        CreateTestCompany(CompanyB());
        InsertRecord(Database::"G/L Entry", CompanyA());
        InsertRecord(Database::"G/L Entry", CompanyB());
        CurrentCompanyGLEntries := GLEntry.Count();

        ClearCompanies(CompanyA(), true, true);

        Assert.IsFalse(HasRecords(Database::"G/L Entry", CompanyA()), 'The selected company is cleared.');
        Assert.IsTrue(HasRecords(Database::"G/L Entry", CompanyB()), 'A company not selected keeps its rows.');
        Assert.AreEqual(CurrentCompanyGLEntries, GLEntry.Count(), 'The current company keeps its G/L entries.');
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler,MessageHandler')]
    procedure SeveralSelectedCompaniesAreCleared()
    var
        SelectedCompanies: List of [Text[30]];
    begin
        Initialize();
        CreateTestCompany(CompanyA());
        CreateTestCompany(CompanyB());
        InsertRecord(Database::"Sales Header", CompanyA());
        InsertRecord(Database::"Sales Header", CompanyB());
        SelectedCompanies.Add(CompanyA());
        SelectedCompanies.Add(CompanyB());
        ConfirmReplies.Add(true);
        ConfirmReplies.Add(true);

        ClearCompanyMgt.ConfirmAndClearCompanies(SelectedCompanies);

        Assert.IsFalse(HasRecords(Database::"Sales Header", CompanyA()), 'First selected company is cleared.');
        Assert.IsFalse(HasRecords(Database::"Sales Header", CompanyB()), 'Second selected company is cleared.');
        Assert.AreEqual(2, Messages.Count(), 'One completion message per company.');
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler')]
    procedure DecliningFirstConfirmClearsNothing()
    begin
        Initialize();
        CreateTestCompany(CompanyA());
        InsertRecord(Database::"G/L Entry", CompanyA());

        ClearCompanies(CompanyA(), false, true);

        Assert.AreEqual(1, ConfirmQuestions.Count(), 'The second question is not asked.');
        Assert.IsTrue(HasRecords(Database::"G/L Entry", CompanyA()), 'Nothing is cleared.');
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler')]
    procedure DecliningSecondConfirmClearsNothing()
    begin
        Initialize();
        CreateTestCompany(CompanyA());
        InsertRecord(Database::"G/L Entry", CompanyA());

        ClearCompanies(CompanyA(), true, false);

        Assert.AreEqual(2, ConfirmQuestions.Count(), 'Both questions are asked.');
        Assert.AreEqual('Are you REALLY sure?', ConfirmQuestions.Get(2), 'Second question.');
        Assert.IsTrue(HasRecords(Database::"G/L Entry", CompanyA()), 'Nothing is cleared.');
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler')]
    procedure ConfirmListsSelectedCompanies()
    var
        SelectedCompanies: List of [Text[30]];
    begin
        Initialize();
        SelectedCompanies.Add(CompanyA());
        SelectedCompanies.Add(CompanyB());
        ConfirmReplies.Add(false);

        ClearCompanyMgt.ConfirmAndClearCompanies(SelectedCompanies);

        Assert.IsTrue(ConfirmQuestions.Get(1).Contains('The following companies will be cleared:'), 'First question heading.');
        Assert.IsTrue(ConfirmQuestions.Get(1).Contains(CompanyA()), 'First question names the first company.');
        Assert.IsTrue(ConfirmQuestions.Get(1).Contains(CompanyB()), 'First question names the second company.');
        Assert.IsTrue(ConfirmQuestions.Get(1).Contains('This cannot be undone.'), 'First question warns.');
    end;

    [Test]
    procedure NoCompanySelectedAsksNothing()
    var
        SelectedCompanies: List of [Text[30]];
    begin
        Initialize();

        asserterror ClearCompanyMgt.ConfirmAndClearCompanies(SelectedCompanies);

        Assert.ExpectedError('Please select at least one company to continue.');
        Assert.AreEqual(0, ConfirmQuestions.Count(), 'No question is asked.');
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler')]
    procedure UnknownCompanyIsIgnored()
    begin
        Initialize();

        ClearCompanies('BACC No Such Company', true, true);

        Assert.AreEqual(2, ConfirmQuestions.Count(), 'Both questions are asked.');
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler,MessageHandler')]
    procedure CompletionMessageNamesCompany()
    begin
        Initialize();
        CreateTestCompany(CompanyA());

        ClearCompanies(CompanyA(), true, true);

        Assert.AreEqual(1, Messages.Count(), 'One completion message.');
        Assert.IsTrue(Messages.Get(1).StartsWith(StrSubstNo('Deleted all non-setup data in Company %1 in ', CompanyA())), Messages.Get(1));
    end;

    [Test]
    [HandlerFunctions('ConfirmHandler,MessageHandler')]
    procedure MasterDataIsKept()
    begin
        Initialize();
        CreateTestCompany(CompanyA());
        InsertRecord(Database::Customer, CompanyA());
        InsertRecord(Database::Vendor, CompanyA());
        InsertRecord(Database::Item, CompanyA());
        InsertRecord(Database::"G/L Account", CompanyA());

        ClearCompanies(CompanyA(), true, true);

        Assert.IsTrue(HasRecords(Database::Customer, CompanyA()), 'Customers are kept.');
        Assert.IsTrue(HasRecords(Database::Vendor, CompanyA()), 'Vendors are kept.');
        Assert.IsTrue(HasRecords(Database::Item, CompanyA()), 'Items are kept.');
        Assert.IsTrue(HasRecords(Database::"G/L Account", CompanyA()), 'G/L accounts are kept.');
    end;

    local procedure Initialize()
    begin
        Clear(ConfirmReplies);
        Clear(ConfirmQuestions);
        Clear(Messages);
    end;

    local procedure CompanyA(): Text[30]
    begin
        exit('BACC Test Company A');
    end;

    local procedure CompanyB(): Text[30]
    begin
        exit('BACC Test Company B');
    end;

    local procedure ClearCompanies(CompanyToClear: Text[30]; FirstReply: Boolean; SecondReply: Boolean)
    var
        SelectedCompanies: List of [Text[30]];
    begin
        SelectedCompanies.Add(CompanyToClear);
        ConfirmReplies.Add(FirstReply);
        ConfirmReplies.Add(SecondReply);
        ClearCompanyMgt.ConfirmAndClearCompanies(SelectedCompanies);
    end;

    local procedure GetKeptTables(var KeptTableIds: List of [Integer])
    begin
        KeptTableIds.Add(Database::"Fixed Asset");
        KeptTableIds.Add(Database::"FA Setup");
        KeptTableIds.Add(Database::"FA Posting Type Setup");
        KeptTableIds.Add(Database::"FA Journal Setup");
        KeptTableIds.Add(Database::"FA Posting Group");
        KeptTableIds.Add(Database::"FA Class");
        KeptTableIds.Add(Database::"FA Subclass");
        KeptTableIds.Add(Database::"FA Location");
    end;

    local procedure CreateTestCompany(NewCompanyName: Text[30])
    var
        Company: Record Company;
    begin
        if Company.Get(NewCompanyName) then
            Error('Company %1 already exists, so it was not cleaned up by an earlier run. Delete it before testing.', NewCompanyName);
        Company.Init();
        Company.Name := NewCompanyName;
        Company."Display Name" := NewCompanyName;
        Company.Insert();
    end;

    // A row with only its primary key filled is enough: clearing deletes rows without looking at their contents.
    local procedure InsertRecord(TableId: Integer; TargetCompany: Text[30])
    var
        RecRef: RecordRef;
        PrimaryKey: KeyRef;
        FldRef: FieldRef;
        i: Integer;
    begin
        RecRef.Open(TableId, false, TargetCompany);
        RecRef.Init();
        PrimaryKey := RecRef.KeyIndex(1);
        for i := 1 to PrimaryKey.FieldCount() do begin
            FldRef := PrimaryKey.FieldIndex(i);
            case FldRef.Type() of
                FieldType::Code, FieldType::Text:
                    FldRef.Value := CopyStr('BACCTEST', 1, FldRef.Length());
                FieldType::Integer, FieldType::BigInteger, FieldType::Decimal:
                    FldRef.Value := 1;
                FieldType::Date:
                    FldRef.Value := 20260101D;
                FieldType::DateTime:
                    FldRef.Value := CreateDateTime(20260101D, 0T);
                FieldType::Guid:
                    FldRef.Value := CreateGuid();
            end;
        end;
        RecRef.Insert(false);
        RecRef.Close();
    end;

    [TryFunction]
    local procedure TryInsertRecord(TableId: Integer; TargetCompany: Text[30])
    begin
        InsertRecord(TableId, TargetCompany);
    end;

    // Through RecordRef.Open, as the other helpers: the version using a record's ChangeCompany to the company the
    // test had just created hung until the run was cut off (2026-11-13).
    local procedure InsertCommentLine(TableName: Enum "Comment Line Table Name"; TargetCompany: Text[30])
    var
        CommentLine: Record "Comment Line";
        RecRef: RecordRef;
    begin
        RecRef.Open(Database::"Comment Line", false, TargetCompany);
        RecRef.Init();
        RecRef.Field(CommentLine.FieldNo("Table Name")).Value := TableName.AsInteger();
        RecRef.Field(CommentLine.FieldNo("No.")).Value := 'BACCTEST';
        RecRef.Field(CommentLine.FieldNo("Line No.")).Value := 10000;
        RecRef.Insert(false);
        RecRef.Close();
    end;

    local procedure HasCommentLine(TableName: Enum "Comment Line Table Name"; TargetCompany: Text[30]): Boolean
    var
        CommentLine: Record "Comment Line";
        RecRef: RecordRef;
    begin
        RecRef.Open(Database::"Comment Line", false, TargetCompany);
        RecRef.Field(CommentLine.FieldNo("Table Name")).SetRange(TableName.AsInteger());
        exit(not RecRef.IsEmpty());
    end;

    local procedure HasRecords(TableId: Integer; TargetCompany: Text[30]): Boolean
    var
        RecRef: RecordRef;
    begin
        RecRef.Open(TableId, false, TargetCompany);
        exit(not RecRef.IsEmpty());
    end;

    [ConfirmHandler]
    procedure ConfirmHandler(Question: Text[1024]; var Reply: Boolean)
    begin
        ConfirmQuestions.Add(Question);
        Reply := ConfirmReplies.Get(ConfirmQuestions.Count());
    end;

    [MessageHandler]
    procedure MessageHandler(Message: Text[1024])
    begin
        Messages.Add(Message);
    end;

    var
        ClearCompanyMgt: Codeunit "BACC Clear Company Mgt.";
}