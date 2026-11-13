codeunit 80484 "BACC Select Company Tests"
{
    // Tests run through the API cannot open pages, so these call the procedures behind the Select Company page's
    // Selected column and the check that raised "Please select at least one company to continue.".
    Subtype = Test;

    var
        Assert: Codeunit "BACC Assert";

    [Test]
    procedure TickedCompanyIsSelected()
    var
        SelectCompany: Page "BACC Select Company";
        SelectedCompanies: List of [Text[30]];
    begin
        SelectCompany.SetCompanySelected('Test Company A', true);

        SelectCompany.GetTickedCompanies(SelectedCompanies);
        Assert.AreEqual(1, SelectedCompanies.Count(), 'Number of ticked companies.');
        Assert.IsTrue(SelectedCompanies.Contains('Test Company A'), 'The ticked company is selected.');
    end;

    [Test]
    procedure TickedCompanyPassesSelectionCheck()
    var
        SelectCompany: Page "BACC Select Company";
        ClearCompanyMgt: Codeunit "BACC Clear Company Mgt.";
        SelectedCompanies: List of [Text[30]];
    begin
        SelectCompany.SetCompanySelected('Test Company A', true);
        SelectCompany.GetTickedCompanies(SelectedCompanies);

        ClearCompanyMgt.CheckAnyCompanySelected(SelectedCompanies);
    end;

    [Test]
    procedure NoCompanySelectedIsRefused()
    var
        ClearCompanyMgt: Codeunit "BACC Clear Company Mgt.";
        SelectedCompanies: List of [Text[30]];
    begin
        asserterror ClearCompanyMgt.CheckAnyCompanySelected(SelectedCompanies);
        Assert.ExpectedError('Please select at least one company to continue.');
    end;

    [Test]
    procedure UntickedCompanyIsNotSelected()
    var
        SelectCompany: Page "BACC Select Company";
        SelectedCompanies: List of [Text[30]];
    begin
        SelectCompany.SetCompanySelected('Test Company A', true);
        SelectCompany.SetCompanySelected('Test Company A', false);

        SelectCompany.GetTickedCompanies(SelectedCompanies);
        Assert.AreEqual(0, SelectedCompanies.Count(), 'Number of ticked companies.');
    end;

    [Test]
    procedure OnlyTickedCompaniesAreSelected()
    var
        SelectCompany: Page "BACC Select Company";
        SelectedCompanies: List of [Text[30]];
    begin
        SelectCompany.SetCompanySelected('Test Company A', true);
        SelectCompany.SetCompanySelected('Test Company B', true);
        SelectCompany.SetCompanySelected('Test Company C', true);
        SelectCompany.SetCompanySelected('Test Company B', false);

        SelectCompany.GetTickedCompanies(SelectedCompanies);
        Assert.AreEqual(2, SelectedCompanies.Count(), 'Number of ticked companies.');
        Assert.IsTrue(SelectedCompanies.Contains('Test Company A'), 'Test Company A stays selected.');
        Assert.IsFalse(SelectedCompanies.Contains('Test Company B'), 'Test Company B was unticked.');
        Assert.IsTrue(SelectedCompanies.Contains('Test Company C'), 'Test Company C stays selected.');
    end;

    // The tick each row shows comes from IsCompanySelected, not from whichever row was current.
    [Test]
    procedure EachRowShowsItsOwnTick()
    var
        SelectCompany: Page "BACC Select Company";
    begin
        SelectCompany.SetCompanySelected('Test Company A', true);

        Assert.IsTrue(SelectCompany.IsCompanySelected('Test Company A'), 'Test Company A shows ticked.');
        Assert.IsFalse(SelectCompany.IsCompanySelected('Test Company B'), 'Test Company B shows unticked.');
    end;
}
