/*
 * Created by Prab Poreddy on 4/11/2018.
 */
public class olg_BulkLoanEditor {

	public String loanInput {get;set;} // for user input
	public static List<selectableLoan> validLoans {get;set;} // to be used to display valid loans for editing
	private static List<selectableLoan> invalidLoans {get;set;}
	private static String invalidLoansList {get;set;}
	private static List<selectableLoan> selectedLoans = new List<selectableLoan>();
	public static Integer numOfInvalidLoans {get;set;}
	public static Olg_Loan__c editLoan {get;set;}

	// Constructor to be used for any specfic initializations
	public olg_BulkLoanEditor(){

	}

	//      Method to be invoked by a button to grab input string from screen
	public PageReference showLoanInfo(){
		loanInput = this.loanInput;
		showLoanInfo(loanInput);
		return null;
	}

	private static ApexPages.Message addApexMsg(String msg, ApexPages.Severity sev){
		ApexPages.Message message = new ApexPages.Message(sev, msg);
		return message;
	}

	public static String showLoanInfo(String loanInput){
		validLoans      = new List<selectableLoan>();
		invalidLoans    = new List<selectableLoan>();
		if(loanInput == null || loanInput == ''){
			System.debug('Please enter comma-separated list of loans');
			addApexMsg('Please enter comma-separated list of loans',ApexPages.Severity.ERROR);
//			ApexPages.Message  Msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please enter comma-separated list of loans to view details.');
//			ApexPages.addMessage(Msg);
		}
		else {
			loanInput = loanInput.replaceAll('\\s+', ''); // removes spaces in input string
 			System.debug('the loan list provided is: '+ loanInput);
//			checkLoans(loanInput);
//			for (Integer i=0; i<loanInput.split(',').size();i++){
//				checkLoans(loanInput.split(',').get(i));
//			}
//			System.debug('There are '+ invalidLoans.size()+' invalid loans and '+validLoans.size()+'  valid loans in the input string.');
		}

		numOfInvalidLoans = invalidLoans.size();
		if(numOfInvalidLoans >0){
			System.debug('number of invalid loans: '+ numOfInvalidLoans);
			invalidLoansList = '';
			for (Integer i=0; i<numOfInvalidLoans; i++){
				invalidLoansList = invalidLoansList + invalidLoans[i].loan.Name +', ';
			}
//			ApexPages.Message Msg = new ApexPages.Message(ApexPages.Severity.ERROR,'There ' + (invalidLoans.size()==1?'is ':'are ') +  invalidLoans.size()+' invalid '+ (invalidLoans.size()==1?'loan ':'loans') + ' in the list you entered: '+ invalidLoansList);
//			ApexPages.addMessage(Msg);
		}

		return null;
	}


	// Let this be the method that creates validLoans and invalidLoans lists of selectableLoan object type

	private static void checkLoans(String loanNum){
		List<Olg_Loan__c> tmpLoans        = new List<Olg_Loan__c>(); // this can be declared as single loan object but we are using list instead for defensive coding
		Olg_Loan__c tmpLoan             = new Olg_Loan__c(); // this is to use when SOQL returns no result.
		selectableLoan invalidLoan = new selectableLoan();
		selectableLoan validLoan = new selectableLoan();
		editLoan = new Olg_Loan__c();


		try{
			tmpLoans = [SELECT Name, Status__c, OwnerId from olg_Loan__c where Name in(:loanNum)];
			System.debug('tmpLoans is: '+ tmpLoans);
			if (!tmpLoans.isEmpty()) {
				for (Integer i = 0; i < tmpLoans.size(); i++) {
					validLoan.loan = tmpLoans.get(i);
					validLoans.add(validLoan);
					System.debug('validLoans list size is ' + validLoans.size() + ' with addition of' + tmpLoans.get(i));
				}
			}
			else {
				System.debug('This loan is not in the system and there is no exception generated in try statement when checking for loan number: ' +
						loanNum);
				tmpLoan.Name = loanNum;
				invalidLoan.loan = tmpLoan;
				invalidLoans.add(invalidLoan);
				System.debug('invalidLoans list size is ' + invalidLoans.size() + ' with addition of' + loanNum);
			}
		}
		catch(System.Exception e){
			System.debug('This loan is not in the system: '+ loanNum+ ' and the exception encountered while validating the loan is: '+ e);
			invalidLoan.loan.Name = loanNum;
			invalidLoans.add(invalidLoan);
			System.debug('invalidLoans list size is '+ invalidLoans.size()+ ' with addition of' + loanNum);
		}
	}

	// The selectableLoan object must be defined to take loan object as input and add select variable as boolean false.
	// The select boolean can be used to display as a checkbox on screen

	public class selectableLoan{
		public Olg_Loan__c loan {get;set;}
		public Boolean selected {get;set;}

		//      constructor
		public void selectableLoan(Olg_Loan__c loan){
			loan = loan;
			selected = false;
		}

	}

	//If there are invalid loans, display these items to user and do not allow edits on existing loans
	//If there are no invalid loans, display valid loan list with checkboxes and other input fields that must be used to update existing loans
//	public PageReference editLoans() {
//		List<Olg_Loan__c> editLoans = new List<olg_Loan__c>();
//		showSelectedLoans();
//		if (invalidLoans.size() > 0 || selectedLoans.size() == 0) {
//			ApexPages.Message  Msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select loans to edit.');
//			ApexPages.addMessage(Msg);
//		}
//		else{
//			if(this.editLoan.OwnerId == null && this.editLoan.Status__c == null){
//				ApexPages.Message   Msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please specify the values to edit on the selected loans.');
//				ApexPages.addMessage(Msg);
//			}
//			else{
//				System.debug('SelectedLoans are: '+ selectedLoans);
//				for (Integer i = 0; i < selectedLoans.size(); i++){
//					if(this.editLoan.OwnerId != null) {
//						selectedLoans[i].loan.OwnerId = this.editLoan.OwnerId;
//					}
//					if(this.editLoan.Status__c != null) {
//						selectedLoans[i].loan.Status__c = this.editLoan.Status__c;
//					}
//					editLoans.add(selectedLoans[i].loan);
//				}
//				System.debug('editLoans just before the upsert is: '+ editLoans);
//				upsert editLoans;
//				ApexPages.Message Msg = new ApexPages.Message(ApexPages.Severity.CONFIRM, selectedLoans.size() +' loans have been updated.');
//				ApexPages.addMessage(Msg);
//
//			}
//		}
//		return null;
//	}

	private void showSelectedLoans(){

		for (Integer i=0; i<validLoans.size();i++){
			System.debug(validLoans.get(i).loan.Name + ' has it selected attribute as:'+ validLoans.get(i).selected );
			if(validLoans.get(i).selected == true){
				selectedLoans.add(validLoans.get(i));
			}//end of selected if loop

		}

	}

	public PageReference selectAll() {
		for (Integer i = 0; i < validLoans.size(); i++) {
			validLoans[i].selected = true;
		}
		return null;
	}

	public PageReference unselectAll(){
		for (Integer i=0; i<validLoans.size(); i++){
			validLoans[i].selected = false;
		}
		return null;
	}

}//end of class