codeunit 80490 "BACC Clear Company Mgt."
{
    Permissions =
        tabledata "Sales Header" = RD,
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
        SelectCompany: Page "BACC Select Company";
        SelectedCompanies: List of [Text[30]];
    begin
        SelectCompany.LookupMode(true);
        SelectCompany.Editable(true);
        if SelectCompany.RunModal() <> Action::LookupOK then
            exit;

        SelectCompany.GetSelectedCompanies(SelectedCompanies);
        ConfirmAndClearCompanies(SelectedCompanies);
    end;

    internal procedure ConfirmAndClearCompanies(SelectedCompanies: List of [Text[30]])
    var
        Company: Record Company;
        DisplayText: TextBuilder;
        s: Text;
    begin
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

    // Fixed Asset, FA Setup, FA Posting Type Setup, FA Journal Setup, FA Posting Group, FA Class, FA Subclass and
    // FA Location are left out on purpose: clearing keeps them.
    internal procedure GetTablesToClear(var TableIds: List of [Integer])
    begin
        TableIds.Add(Database::"Sales Header");
        TableIds.Add(Database::"Sales Line");
        TableIds.Add(Database::"Sales Comment Line");
        TableIds.Add(Database::"Sales Shipment Header");
        TableIds.Add(Database::"Sales Shipment Line");
        TableIds.Add(Database::"Sales Invoice Header");
        TableIds.Add(Database::"Sales Invoice Line");
        TableIds.Add(Database::"Sales Cr.Memo Header");
        TableIds.Add(Database::"Sales Cr.Memo Line");
        TableIds.Add(Database::"Purchase Header");
        TableIds.Add(Database::"Purchase Line");
        TableIds.Add(Database::"Purch. Rcpt. Header");
        TableIds.Add(Database::"Purch. Rcpt. Line");
        TableIds.Add(Database::"Purch. Inv. Header");
        TableIds.Add(Database::"Purch. Inv. Line");
        TableIds.Add(Database::"Purch. Cr. Memo Hdr.");
        TableIds.Add(Database::"Purch. Cr. Memo Line");
        TableIds.Add(Database::"Production Order");
        TableIds.Add(Database::"Prod. Order Line");
        TableIds.Add(Database::"Prod. Order Component");
        TableIds.Add(Database::"Prod. Order Routing Line");
        TableIds.Add(Database::"Prod. Order Capacity Need");
        TableIds.Add(Database::"Prod. Order Routing Tool");
        TableIds.Add(Database::"Prod. Order Routing Personnel");
        TableIds.Add(Database::"Prod. Order Rtng Qlty Meas.");
        TableIds.Add(Database::"Prod. Order Comment Line");
        TableIds.Add(Database::"Prod. Order Rtng Comment Line");
        TableIds.Add(Database::"Prod. Order Comp. Cmt Line");
        TableIds.Add(Database::"FA Ledger Entry");
        TableIds.Add(Database::"Depreciation Book");
        TableIds.Add(Database::"FA Depreciation Book");
        TableIds.Add(Database::"FA Allocation");
        TableIds.Add(Database::"Assembly Header");
        TableIds.Add(Database::"Assembly Line");
        TableIds.Add(Database::"Assemble-to-Order Link");
        TableIds.Add(Database::"Assembly Comment Line");
        TableIds.Add(Database::"Posted Assembly Header");
        TableIds.Add(Database::"Posted Assembly Line");
        TableIds.Add(Database::"Posted Assemble-to-Order Link");
        TableIds.Add(Database::"ATO Sales Buffer");
        TableIds.Add(Database::"Time Sheet Header");
        TableIds.Add(Database::"Time Sheet Line");
        TableIds.Add(Database::"Time Sheet Detail");
        TableIds.Add(Database::"Time Sheet Comment Line");
        TableIds.Add(Database::"Purch. Comment Line");
        TableIds.Add(Database::"Comment Line");
        TableIds.Add(Database::"Warehouse Comment Line");
        TableIds.Add(Database::"Service Comment Line");
        TableIds.Add(Database::"Manufacturing Comment Line");
        TableIds.Add(Database::"Routing Comment Line");
        TableIds.Add(Database::"Production BOM Comment Line");
        TableIds.Add(Database::"Service Header");
        TableIds.Add(Database::"Service Item Line");
        TableIds.Add(Database::"Service Line");
        TableIds.Add(Database::"Service Ledger Entry");
        TableIds.Add(Database::"Warranty Ledger Entry");
        TableIds.Add(Database::"Service Shipment Item Line");
        TableIds.Add(Database::"Service Shipment Header");
        TableIds.Add(Database::"Service Shipment Line");
        TableIds.Add(Database::"Service Invoice Header");
        TableIds.Add(Database::"Service Invoice Line");
        TableIds.Add(Database::"Service Cr.Memo Header");
        TableIds.Add(Database::"Service Cr.Memo Line");
        TableIds.Add(Database::"G/L Entry");
        TableIds.Add(Database::"Cust. Ledger Entry");
        TableIds.Add(Database::"Vendor Ledger Entry");
        TableIds.Add(Database::"Item Ledger Entry");
        TableIds.Add(Database::"G/L Budget Entry");
        TableIds.Add(Database::"Job Ledger Entry");
        TableIds.Add(Database::"Reversal Entry");
        TableIds.Add(Database::"G/L Entry - VAT Entry Link");
        TableIds.Add(Database::"VAT Entry");
        TableIds.Add(Database::"Bank Account Ledger Entry");
        TableIds.Add(Database::"Check Ledger Entry");
        TableIds.Add(Database::"Reservation Entry");
        TableIds.Add(Database::"Cost Entry");
        TableIds.Add(Database::"Value Entry");
        TableIds.Add(Database::"G/L Register");
    end;

    local procedure ClearCompany(CompanyToDelete: Text[30])
    var
        RecRef: RecordRef;
        Window: Dialog;
        TableIds: List of [Integer];
        TableId: Integer;
        TableCount: Integer;
        i: Integer;
        StartDateTime: DateTime;
    begin
        // No progress window where there is no client to show it, e.g. a job queue or API session.
        if GuiAllowed() then begin
            Window.Open('Deleting records...\Company: #1##\#2##');
            Window.Update(1, CompanyToDelete);
        end;

        StartDateTime := CurrentDateTime();
        GetTablesToClear(TableIds);
        foreach TableId in TableIds do
            if HasRecordsToClear(TableId, CompanyToDelete) then
                TableCount += 1;

        foreach TableId in TableIds do
            if HasRecordsToClear(TableId, CompanyToDelete) then begin
                i += 1;
                OpenInTargetCompany(TableId, CompanyToDelete, RecRef);
                if GuiAllowed() then
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

        if GuiAllowed() then
            Window.Close();
        Message('Deleted all non-setup data in Company %1 in %2.', CompanyToDelete, CurrentDateTime() - StartDateTime);
    end;

    local procedure HasRecordsToClear(TableId: Integer; CompanyToDelete: Text[30]): Boolean
    var
        RecRef: RecordRef;
    begin
        OpenInTargetCompany(TableId, CompanyToDelete, RecRef);
        exit(not RecRef.IsEmpty());
    end;

    local procedure OpenInTargetCompany(TableId: Integer; CompanyToDelete: Text[30]; var RecRef: RecordRef)
    var
        CommentLine: Record "Comment Line";
    begin
        RecRef.Open(TableId, false, CompanyToDelete);
        if TableId <> Database::"Comment Line" then
            exit;
        // Fixed assets are kept, so their comments are too.
        CommentLine.SetFilter("Table Name", '<>%1', CommentLine."Table Name"::"Fixed Asset");
        RecRef.SetView(CommentLine.GetView(false));
    end;
}