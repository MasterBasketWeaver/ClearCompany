codeunit 80490 "BACC Clear Company Mgt."
{
    Permissions = tabledata "Sales Header" = RD,
        tabledata "Sales Line" = RD,
        tabledata "Sales Comment Line" = RD,
        tabledata "Sales Shipment Header" = RD,
        tabledata "Sales Shipment Line" = RD,
        tabledata "Sales Invoice Header" = RD,
        tabledata "Sales Invoice Line" = RD,
        tabledata "Sales Cr.Memo Header" = RD,
        tabledata "Sales Cr.Memo Line" = RD,
        tabledata "Purchase Header" = RD,
        tabledata "Purchase Line" = RD,
        tabledata "Purch. Rcpt. Header" = RD,
        tabledata "Purch. Rcpt. Line" = RD,
        tabledata "Purch. Inv. Header" = RD,
        tabledata "Purch. Inv. Line" = RD,
        tabledata "Purch. Cr. Memo Hdr." = RD,
        tabledata "Purch. Cr. Memo Line" = RD,
        tabledata "Production Order" = RD,
        tabledata "Prod. Order Line" = RD,
        tabledata "Prod. Order Component" = RD,
        tabledata "Prod. Order Routing Line" = RD,
        tabledata "Prod. Order Capacity Need" = RD,
        tabledata "Prod. Order Routing Tool" = RD,
        tabledata "Prod. Order Routing Personnel" = RD,
        tabledata "Prod. Order Rtng Qlty Meas." = RD,
        tabledata "Prod. Order Comment Line" = RD,
        tabledata "Prod. Order Rtng Comment Line" = RD,
        tabledata "Prod. Order Comp. Cmt Line" = RD,
        tabledata "FA Ledger Entry" = RD,
        tabledata "Depreciation Book" = RD,
        tabledata "FA Depreciation Book" = RD,
        tabledata "FA Allocation" = RD,
        tabledata "Assembly Header" = RD,
        tabledata "Assembly Line" = RD,
        tabledata "Assemble-to-Order Link" = RD,
        tabledata "Assembly Comment Line" = RD,
        tabledata "Posted Assembly Header" = RD,
        tabledata "Posted Assembly Line" = RD,
        tabledata "Posted Assemble-to-Order Link" = RD,
        tabledata "ATO Sales Buffer" = RD,
        tabledata "Time Sheet Header" = RD,
        tabledata "Time Sheet Line" = RD,
        tabledata "Time Sheet Detail" = RD,
        tabledata "Time Sheet Comment Line" = RD,
        tabledata "Purch. Comment Line" = RD,
        tabledata "Comment Line" = RD,
        tabledata "Warehouse Comment Line" = RD,
        tabledata "Service Comment Line" = RD,
        tabledata "Manufacturing Comment Line" = RD,
        tabledata "Routing Comment Line" = RD,
        tabledata "Production BOM Comment Line" = RD,
        tabledata "Service Header" = RD,
        tabledata "Service Item Line" = RD,
        tabledata "Service Line" = RD,
        tabledata "Service Ledger Entry" = RD,
        tabledata "Warranty Ledger Entry" = RD,
        tabledata "Service Shipment Item Line" = RD,
        tabledata "Service Shipment Header" = RD,
        tabledata "Service Shipment Line" = RD,
        tabledata "Service Invoice Header" = RD,
        tabledata "Service Invoice Line" = RD,
        tabledata "Service Cr.Memo Header" = RD,
        tabledata "Service Cr.Memo Line" = RD,
        tabledata "G/L Entry" = RD,
        tabledata "Cust. Ledger Entry" = RD,
        tabledata "Vendor Ledger Entry" = RD,
        tabledata "Item Ledger Entry" = RD,
        tabledata "G/L Budget Entry" = RD,
        tabledata "Job Ledger Entry" = RD,
        tabledata "Reversal Entry" = RD,
        tabledata "G/L Entry - VAT Entry Link" = RD,
        tabledata "VAT Entry" = RD,
        tabledata "Bank Account Ledger Entry" = RD,
        tabledata "Check Ledger Entry" = RD,
        tabledata "Reservation Entry" = RD,
        tabledata "Cost Entry" = RD,
        tabledata "Value Entry" = RD,
        tabledata "G/L Register" = RD;


    procedure SelectCompaniesToClear()
    var
        Company: Record Company;
        SelectCompany: Page "BACC Select Company";
        SelectedCompanies: List of [Text[30]];
        DisplayText: TextBuilder;
        s: Text;
    begin
        SelectCompany.LookupMode(true);
        SelectCompany.Editable(true);
        if SelectCompany.RunModal() <> Action::LookupOK then
            exit;

        SelectCompany.GetSelectedCompanies(SelectedCompanies);
        CheckAnyCompanySelected(SelectedCompanies);

        DisplayText.AppendLine('The following companies will be cleared:');
        foreach s in SelectedCompanies do
            DisplayText.AppendLine(s);
        DisplayText.AppendLine('');
        DisplayText.AppendLine('Do you want to continue?');
        DisplayText.AppendLine('This cannot be undone.');
        if not Confirm(DisplayText.ToText()) then
            exit;
        if not Confirm('Are you REALLY sure?') then
            exit;

        if Company.FindSet() then
            repeat
                if SelectedCompanies.Contains(Company.Name) then
                    ClearCompany(Company.Name);
            until Company.Next() = 0;
    end;

    internal procedure CheckAnyCompanySelected(SelectedCompanies: List of [Text[30]])
    begin
        if SelectedCompanies.Count() = 0 then
            Error('Please select at least one company to continue.');
    end;

    local procedure ClearCompany(CompanyToDelete: Text[30])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesCommentLine: Record "Sales Comment Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCreditMemoHeader: Record "Sales Cr.Memo Header";
        SalesCreditMemoLine: Record "Sales Cr.Memo Line";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchaseReceiptHeader: Record "Purch. Rcpt. Header";
        PurchaseReceiptLine: Record "Purch. Rcpt. Line";
        PurchaseInvoiceHeader: Record "Purch. Inv. Header";
        PurchaseInvoiceLine: Record "Purch. Inv. Line";
        PurchaseCreditMemoHeader: Record "Purch. Cr. Memo Hdr.";
        PurchaseCreditMemoLine: Record "Purch. Cr. Memo Line";
        ProductionOrder: Record "Production Order";
        ProductionOrderLine: Record "Prod. Order Line";
        ProdOrderComponent: Record "Prod. Order Component";
        ProdOrderRoutingLine: Record "Prod. Order Routing Line";
        ProdOrderCapacityNeed: Record "Prod. Order Capacity Need";
        ProdOrderRoutingTool: Record "Prod. Order Routing Tool";
        ProdOrderRoutingPersonnel: Record "Prod. Order Routing Personnel";
        ProdOrderRtngQltyMeas: Record "Prod. Order Rtng Qlty Meas.";
        ProdOrderCommentLine: Record "Prod. Order Comment Line";
        ProdOrderRtngCommentLine: Record "Prod. Order Rtng Comment Line";
        ProdOrderCompCmtLine: Record "Prod. Order Comp. Cmt Line";
        FALedgerEntry: Record "FA Ledger Entry";
        DepreciationBook: Record "Depreciation Book";
        FADepreciationBook: Record "FA Depreciation Book";
        FAAllocation: Record "FA Allocation";
        AssemblyHeader: Record "Assembly Header";
        AssemblyLine: Record "Assembly Line";
        AssembleToOrderLink: Record "Assemble-to-Order Link";
        AssemblyCommentLine: Record "Assembly Comment Line";
        PostedAssemblyHeader: Record "Posted Assembly Header";
        PostedAssemblyLine: Record "Posted Assembly Line";
        PostedAssembleToOrderLink: Record "Posted Assemble-to-Order Link";
        ATOSalesBuffer: Record "ATO Sales Buffer";
        TimeSheetHeader: Record "Time Sheet Header";
        TimeSheetLine: Record "Time Sheet Line";
        TimeSheetDetail: Record "Time Sheet Detail";
        TimeSheetCommentLine: Record "Time Sheet Comment Line";
        PurchCommentLine: Record "Purch. Comment Line";
        CommentLine: Record "Comment Line";
        WarehouseCommentLine: Record "Warehouse Comment Line";
        ServiceCommentLine: Record "Service Comment Line";
        ManufacturingCommentLine: Record "Manufacturing Comment Line";
        RoutingCommentLine: Record "Routing Comment Line";
        ProductionBOMCommentLine: Record "Production BOM Comment Line";
        ServiceHeader: Record "Service Header";
        ServiceItemLine: Record "Service Item Line";
        ServiceLine: Record "Service Line";
        ServiceLedgerEntry: Record "Service Ledger Entry";
        WarrantyLedgerEntry: Record "Warranty Ledger Entry";
        ServiceShipmentItemLine: Record "Service Shipment Item Line";
        ServiceShipmentHeader: Record "Service Shipment Header";
        ServiceShipmentLine: Record "Service Shipment Line";
        ServiceInvoiceHeader: Record "Service Invoice Header";
        ServiceInvoiceLine: Record "Service Invoice Line";
        ServiceCrMemoHeader: Record "Service Cr.Memo Header";
        ServiceCrMemoLine: Record "Service Cr.Memo Line";
        GLEntry: Record "G/L Entry";
        CustLedgerEntry: Record "Cust. Ledger Entry";
        VendorLedgerEntry: Record "Vendor Ledger Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        GLBudgetEntry: Record "G/L Budget Entry";
        JobLedgerEntry: Record "Job Ledger Entry";
        ReversalEntry: Record "Reversal Entry";
        GLEntryVATEntryLink: Record "G/L Entry - VAT Entry Link";
        VATEntry: Record "VAT Entry";
        BankAccountLedgerEntry: Record "Bank Account Ledger Entry";
        CheckLedgerEntry: Record "Check Ledger Entry";
        ReservationEntry: Record "Reservation Entry";
        CostEntry: Record "Cost Entry";
        ValueEntry: Record "Value Entry";
        GLRegister: Record "G/L Register";

        StartDateTime: DateTime;
        i: Integer;
    begin
        Window.Open('Deleting records...\Comapny: #1##\#2##');
        Window.Update(1, CompanyToDelete);

        TableCount := 0;
        TargetCompany := CompanyToDelete;

        // Fixed assets are kept, so their comments are too.
        CommentLine.SetFilter("Table Name", '<>%1', CommentLine."Table Name"::"Fixed Asset");

        StartDateTime := CurrentDateTime();
        IncrementTableCount(SalesHeader);
        IncrementTableCount(SalesLine);
        IncrementTableCount(SalesCommentLine);
        IncrementTableCount(SalesShipmentHeader);
        IncrementTableCount(SalesShipmentLine);
        IncrementTableCount(SalesInvoiceHeader);
        IncrementTableCount(SalesInvoiceLine);
        IncrementTableCount(SalesCreditMemoHeader);
        IncrementTableCount(SalesCreditMemoLine);
        IncrementTableCount(PurchaseHeader);
        IncrementTableCount(PurchaseLine);
        IncrementTableCount(PurchaseReceiptHeader);
        IncrementTableCount(PurchaseReceiptLine);
        IncrementTableCount(PurchaseInvoiceHeader);
        IncrementTableCount(PurchaseInvoiceLine);
        IncrementTableCount(PurchaseCreditMemoHeader);
        IncrementTableCount(PurchaseCreditMemoLine);
        IncrementTableCount(ProductionOrder);
        IncrementTableCount(ProductionOrderLine);
        IncrementTableCount(ProdOrderComponent);
        IncrementTableCount(ProdOrderRoutingLine);
        IncrementTableCount(ProdOrderCapacityNeed);
        IncrementTableCount(ProdOrderRoutingTool);
        IncrementTableCount(ProdOrderRoutingPersonnel);
        IncrementTableCount(ProdOrderRtngQltyMeas);
        IncrementTableCount(ProdOrderCommentLine);
        IncrementTableCount(ProdOrderRtngCommentLine);
        IncrementTableCount(ProdOrderCompCmtLine);
        IncrementTableCount(FALedgerEntry);
        IncrementTableCount(DepreciationBook);
        IncrementTableCount(FADepreciationBook);
        IncrementTableCount(FAAllocation);
        IncrementTableCount(AssemblyHeader);
        IncrementTableCount(AssemblyLine);
        IncrementTableCount(AssembleToOrderLink);
        IncrementTableCount(AssemblyCommentLine);
        IncrementTableCount(PostedAssemblyHeader);
        IncrementTableCount(PostedAssemblyLine);
        IncrementTableCount(PostedAssembleToOrderLink);
        IncrementTableCount(ATOSalesBuffer);
        IncrementTableCount(TimeSheetHeader);
        IncrementTableCount(TimeSheetLine);
        IncrementTableCount(TimeSheetDetail);
        IncrementTableCount(TimeSheetCommentLine);
        IncrementTableCount(PurchCommentLine);
        IncrementTableCount(CommentLine);
        IncrementTableCount(WarehouseCommentLine);
        IncrementTableCount(ServiceCommentLine);
        IncrementTableCount(ManufacturingCommentLine);
        IncrementTableCount(RoutingCommentLine);
        IncrementTableCount(ProductionBOMCommentLine);
        IncrementTableCount(ServiceHeader);
        IncrementTableCount(ServiceItemLine);
        IncrementTableCount(ServiceLine);
        IncrementTableCount(ServiceLedgerEntry);
        IncrementTableCount(WarrantyLedgerEntry);
        IncrementTableCount(ServiceShipmentItemLine);
        IncrementTableCount(ServiceShipmentHeader);
        IncrementTableCount(ServiceShipmentLine);
        IncrementTableCount(ServiceInvoiceHeader);
        IncrementTableCount(ServiceInvoiceLine);
        IncrementTableCount(ServiceCrMemoHeader);
        IncrementTableCount(ServiceCrMemoLine);
        IncrementTableCount(GLEntry);
        IncrementTableCount(CustLedgerEntry);
        IncrementTableCount(VendorLedgerEntry);
        IncrementTableCount(ItemLedgerEntry);
        IncrementTableCount(GLBudgetEntry);
        IncrementTableCount(JobLedgerEntry);
        IncrementTableCount(ReversalEntry);
        IncrementTableCount(GLEntryVATEntryLink);
        IncrementTableCount(VATEntry);
        IncrementTableCount(BankAccountLedgerEntry);
        IncrementTableCount(CheckLedgerEntry);
        IncrementTableCount(ReservationEntry);
        IncrementTableCount(CostEntry);
        IncrementTableCount(ValueEntry);
        IncrementTableCount(GLRegister);

        DeleteRecordsFromTable(SalesHeader, i);
        DeleteRecordsFromTable(SalesLine, i);
        DeleteRecordsFromTable(SalesCommentLine, i);
        DeleteRecordsFromTable(SalesShipmentHeader, i);
        DeleteRecordsFromTable(SalesShipmentLine, i);
        DeleteRecordsFromTable(SalesInvoiceHeader, i);
        DeleteRecordsFromTable(SalesInvoiceLine, i);
        DeleteRecordsFromTable(SalesCreditMemoHeader, i);
        DeleteRecordsFromTable(SalesCreditMemoLine, i);
        DeleteRecordsFromTable(PurchaseHeader, i);
        DeleteRecordsFromTable(PurchaseLine, i);
        DeleteRecordsFromTable(PurchaseReceiptHeader, i);
        DeleteRecordsFromTable(PurchaseReceiptLine, i);
        DeleteRecordsFromTable(PurchaseInvoiceHeader, i);
        DeleteRecordsFromTable(PurchaseInvoiceLine, i);
        DeleteRecordsFromTable(PurchaseCreditMemoHeader, i);
        DeleteRecordsFromTable(PurchaseCreditMemoLine, i);
        DeleteRecordsFromTable(ProductionOrder, i);
        DeleteRecordsFromTable(ProductionOrderLine, i);
        DeleteRecordsFromTable(ProdOrderComponent, i);
        DeleteRecordsFromTable(ProdOrderRoutingLine, i);
        DeleteRecordsFromTable(ProdOrderCapacityNeed, i);
        DeleteRecordsFromTable(ProdOrderRoutingTool, i);
        DeleteRecordsFromTable(ProdOrderRoutingPersonnel, i);
        DeleteRecordsFromTable(ProdOrderRtngQltyMeas, i);
        DeleteRecordsFromTable(ProdOrderCommentLine, i);
        DeleteRecordsFromTable(ProdOrderRtngCommentLine, i);
        DeleteRecordsFromTable(ProdOrderCompCmtLine, i);
        DeleteRecordsFromTable(FALedgerEntry, i);
        DeleteRecordsFromTable(DepreciationBook, i);
        DeleteRecordsFromTable(FADepreciationBook, i);
        DeleteRecordsFromTable(FAAllocation, i);
        DeleteRecordsFromTable(AssemblyHeader, i);
        DeleteRecordsFromTable(AssemblyLine, i);
        DeleteRecordsFromTable(AssembleToOrderLink, i);
        DeleteRecordsFromTable(AssemblyCommentLine, i);
        DeleteRecordsFromTable(PostedAssemblyHeader, i);
        DeleteRecordsFromTable(PostedAssemblyLine, i);
        DeleteRecordsFromTable(PostedAssembleToOrderLink, i);
        DeleteRecordsFromTable(ATOSalesBuffer, i);
        DeleteRecordsFromTable(TimeSheetHeader, i);
        DeleteRecordsFromTable(TimeSheetLine, i);
        DeleteRecordsFromTable(TimeSheetDetail, i);
        DeleteRecordsFromTable(TimeSheetCommentLine, i);
        DeleteRecordsFromTable(PurchCommentLine, i);
        DeleteRecordsFromTable(CommentLine, i);
        DeleteRecordsFromTable(WarehouseCommentLine, i);
        DeleteRecordsFromTable(ServiceCommentLine, i);
        DeleteRecordsFromTable(ManufacturingCommentLine, i);
        DeleteRecordsFromTable(RoutingCommentLine, i);
        DeleteRecordsFromTable(ProductionBOMCommentLine, i);
        DeleteRecordsFromTable(ServiceHeader, i);
        DeleteRecordsFromTable(ServiceItemLine, i);
        DeleteRecordsFromTable(ServiceLine, i);
        DeleteRecordsFromTable(ServiceLedgerEntry, i);
        DeleteRecordsFromTable(WarrantyLedgerEntry, i);
        DeleteRecordsFromTable(ServiceShipmentItemLine, i);
        DeleteRecordsFromTable(ServiceShipmentHeader, i);
        DeleteRecordsFromTable(ServiceShipmentLine, i);
        DeleteRecordsFromTable(ServiceInvoiceHeader, i);
        DeleteRecordsFromTable(ServiceInvoiceLine, i);
        DeleteRecordsFromTable(ServiceCrMemoHeader, i);
        DeleteRecordsFromTable(ServiceCrMemoLine, i);
        DeleteRecordsFromTable(GLEntry, i);
        DeleteRecordsFromTable(CustLedgerEntry, i);
        DeleteRecordsFromTable(VendorLedgerEntry, i);
        DeleteRecordsFromTable(ItemLedgerEntry, i);
        DeleteRecordsFromTable(GLBudgetEntry, i);
        DeleteRecordsFromTable(JobLedgerEntry, i);
        DeleteRecordsFromTable(ReversalEntry, i);
        DeleteRecordsFromTable(GLEntryVATEntryLink, i);
        DeleteRecordsFromTable(VATEntry, i);
        DeleteRecordsFromTable(BankAccountLedgerEntry, i);
        DeleteRecordsFromTable(CheckLedgerEntry, i);
        DeleteRecordsFromTable(ReservationEntry, i);
        DeleteRecordsFromTable(CostEntry, i);
        DeleteRecordsFromTable(ValueEntry, i);
        DeleteRecordsFromTable(GLRegister, i);

        Window.Close();
        Message('Deleted all non-setup data in Company %1 in %2.', CompanyToDelete, CurrentDateTime() - StartDateTime);
    end;

    local procedure IncrementTableCount(Table: Variant)
    var
        RecRef: RecordRef;
    begin
        OpenInTargetCompany(Table, RecRef);
        if RecRef.IsEmpty() then
            exit;
        TableCount += 1;
    end;

    local procedure DeleteRecordsFromTable(Table: Variant; var i: Integer)
    var
        RecRef: RecordRef;
    begin
        OpenInTargetCompany(Table, RecRef);
        if RecRef.IsEmpty() then
            exit;
        i += 1;
        Window.Update(2, StrSubstNo('%1 of %2: %3', i, TableCount, RecRef.Caption()));
        // Truncate is for emptying a whole table; a filtered one keeps the rows outside its filter.
        if RecRef.GetFilters() <> '' then
            RecRef.DeleteAll(false)
        else
            if not RecRef.Truncate(true) then
                RecRef.DeleteAll(false);
        RecRef.Close();
        Commit();
    end;

    // The view is set again after ChangeCompany so a table's filters (Comment Line's) hold in the target company.
    local procedure OpenInTargetCompany(Table: Variant; var RecRef: RecordRef)
    var
        TableView: Text;
    begin
        RecRef.GetTable(Table);
        TableView := RecRef.GetView(false);
        RecRef.ChangeCompany(TargetCompany);
        RecRef.SetView(TableView);
    end;

    var
        Window: Dialog;
        TargetCompany: Text;
        TableCount: Integer;
}