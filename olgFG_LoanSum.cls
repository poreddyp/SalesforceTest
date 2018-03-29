/***********************************************
Change Log:

2015/04/07 - AF - created.
***********************************************/
//Test comment
public with sharing class olgFG_LoanSum {

    public static void gen (olg_Loan__c l) {
        
        if (l.lien_type__c == null) {
            l.Loan_Summary_auto__c = 'Lien Type is missing. Reviewer must enter Lien Type to enable automatic Loan Summary.';
        }
        else {
            
            // IO term
            string IOterm = 'XXXXXX';
            
            if (l.IO_Term__c == '5') {IOterm = 'five (5)';}
            else if (l.IO_Term__c == '10') {IOterm = 'ten (10)';}
            
            
            // Amortization Type
            string amorType = 'XXXXXX';
            
            if (l.Amortization_Type__c == 'Fixed') {
                amorType = 'fixed rate terms and no Interest Only provisions';
            }
            else if (l.Amortization_Type__c == 'ARM') {
                amorType = 'adjustable rate terms and no Interest Only provisions';
            }
            else if (l.Amortization_Type__c == 'Fixed IO') {
                if (l.IO_Term__c != null) {
                    amorType = 'fixed rate terms and with Interest-Only provisions for the first ' + IOterm + ' years';}
                else {
                    amorType = 'fixed rate terms and with Interest-Only provisions';
                }
            }
            else if (l.Amortization_Type__c == 'ARM IO') {
                if (l.IO_Term__c != null) {
                    amorType = 'adjustable rate terms and with Interest-Only provisions for the first ' + IOterm + ' years';}
                else {
                    amorType = 'adjustable rate terms and with Interest-Only provisions';
                }
            }
            else if (l.Amortization_Type__c == 'Neg ARM') {
                amorType = 'negatively amortizing payment terms';
            }
             
                
            // Occupancy Type
            string iaOccupancy;  // occupancy with Indefinite Article
            
            if (l.Occupancy_Type_Tape__c == null) {
                iaOccupancy = 'XXXXXX';
            }
            else if (l.Occupancy_Type_Tape__c == '2nd Home') {
                iaOccupancy = 'a ' + l.Occupancy_Type_Tape__c;
            }
            else {
                iaOccupancy = 'an ' + l.Occupancy_Type_Tape__c;
            }
            
            
            // Property Type
            string iaPropType;  // Property type with Indefinite Article
            
            if (l.Property_Type_Tape__c == null) {
                iaPropType = 'XXXXXX';
            }
            else if (l.Property_Type_Tape__c.startswith('Attached')) {
                iaPropType = 'an ' + l.Property_Type_Tape__c;
            }
            else {
                iaPropType = 'a ' + l.Property_Type_Tape__c;
            }
            
            string PropType;  // property type w/o artical
            
            if (l.Property_Type_Tape__c == null) {PropType = 'XXXXXX';}
            else if (l.Property_Type_Tape__c == 'Attached SF') {PropType ='Attached Single Family';}
            else if (l.Property_Type_Tape__c == 'Detached SF PUD') {PropType ='Detached Single Family PUD';}
            else { PropType = l.Property_Type_Tape__c; }
            
            
            
            // Doc Type
            string DocType;
            
            if (l.Documentation_Type_Tape__c==null) {DocType = 'XXXXXX';}
            else if (l.Documentation_Type_Tape__c == 'SISA (Stated/Stated)') {DocType = 'Stated Income/Stated Assets';}
            else {DocType = l.Documentation_Type_Tape__c;}
            
            
            // Loan Purpose
            string Purpose;
            
            if (l.Loan_Purpose_Tape__c == null) {Purpose = 'XXXXXX';}
            else if (l.Loan_Purpose_Tape__c == 'Rate & Term') { Purpose = 'Rate & Term Refinance'; }
            else { Purpose = l.Loan_Purpose_Tape__c; }
                
                
            // CLTV
            string cltvClause;
            
            if (l.dealname__c == 'SAS 2005-1') {
                cltvClause = l.CLTV_Tape__c==null?'':('a Combined Loan-to-Value (CLTV) of ' + l.CLTV_Tape__c.format() + '%, ');
            }
            else {
                cltvClause = 'a Combined Loan-to-Value (CLTV) of ' + (l.CLTV_Tape__c==null?'XXXXXX':l.CLTV_Tape__c.format()) + '%, ';
            }
            
                            
            
            // loan Summary text    
            if (l.lien_type__c == '1st') {
                    
                // 1st lien only
                if (l.X2nd_Lien_Amount__c == null || l.X2nd_Lien_Amount__c == 0) {
                    
                    l.loan_summary_auto__c = 'The subject loan closed on ' + (l.Note_Date__c==null?'XXXXXX':l.Note_Date__c.format()) + ' in the amount of $' + (l.Original_Balance__c==null?'XXXXXX':l.Original_Balance__c.format()) + ' with ' + amorType 
                                             + '.  The loan proceeds were used towards the ' + Purpose + ' of ' + iaOccupancy + ', ' + PropType 
                                             + ' property located in ' + (l.property_city__c==null?'XXXXXX':l.property_city__c) + ', ' + (l.property_state__c==null?'XXXXXX':l.property_state__c) 
                                             + '.  The file contained a loan transmittal and/or approval which confirmed the loan was approved under the Seller\'s "' + DocType 
                                             + '" documentation program with a Loan-to-Value (LTV) and Combined Loan-to-Value (CLTV) of ' + (l.LTV_Tape__c==null?'XXXXXX':l.LTV_Tape__c.format()) + 
                                             + '% and ' + (l.FICO_Tape__c==null?'no credit score for the primary foreign national borrower.': 'a qualifying credit score of ' +l.FICO_Tape__c.format() +' for the primary borrower.') + ' The Debt-to-Income (DTI) ratio ' 
                                             +  ((l.DTI_Tape__c==null || l.DTI_Tape__c==0)?
                                                ((l.LENDER_APPROVAL_DTI__C==null || l.LENDER_APPROVAL_DTI__C==0)? 
                        						'was not calculated because of the documentation program.':
                                                'was calculated by the Seller at ' + l.LENDER_APPROVAL_DTI__C.format() + '%.'):
                    							'was calculated by the Seller at ' + l.DTI_Tape__c.format() + '%.');
                    System.debug(l.loan_summary_auto__c );
                 
                }
                // concurrent 2nd lien
                else {
                    l.loan_summary_auto__c = 'The subject 1st lien in the amount of $' + (l.Original_Balance__c==null?'XXXXXX':l.Original_Balance__c.format()) + ' closed concurrently on ' + (l.Note_Date__c==null?'XXXXXX':l.Note_Date__c.format()) +' with a 2nd lien in the amount of $'
                                             + (l.X2nd_Lien_Amount__c).format() + '.  The subject loan note reflected ' + amorType +   
                                             + '.  The loan proceeds were used towards the ' + Purpose + ' of ' + iaOccupancy + ', ' + PropType  
                                             + ' property located in ' + (l.property_city__c==null?'XXXXXX':l.property_city__c) + ', ' + (l.property_state__c==null?'XXXXXX':l.property_state__c) + '.  The file contained a loan transmittal and/or approval which confirmed the loan was approved under the Seller\'s "'
                                             + DocType + '" documentation program with a Loan-to-Value (LTV) of ' + (l.LTV_Tape__c==null?'XXXXXX':l.LTV_Tape__c.format()) + '%, '
                                             + cltvClause + (l.FICO_Tape__c==null?' and no credit score for the primary foreign national borrower.':' and a qualifying credit score of '+ l.FICO_Tape__c.format() + ' for the primary borrower.') +' The Debt-to-Income (DTI) ratio ' 
                                             +  ((l.DTI_Tape__c==null || l.DTI_Tape__c==0)?
                                                ((l.LENDER_APPROVAL_DTI__C==null || l.LENDER_APPROVAL_DTI__C==0)? 
                        						'was not calculated because of the documentation program.':
                                                'was calculated by the Seller at ' + l.LENDER_APPROVAL_DTI__C.format() + '%.'):
                    							'was calculated by the Seller at ' + l.DTI_Tape__c.format() + '%.');
                    System.debug(l.loan_summary_auto__c );
                
                }
                
            }
            else if (l.lien_type__c == '2nd') {
                // DTI sentence
                string DtiSentence;
                if (l.Documentation_Type_Tape__c == 'No Doc' || l.Documentation_Type_Tape__c == 'No Ratio') {
                    DtiSentence = '';
                }
                else {
                    //DtiSentence = 'a Debt-to-Income (DTI) ratio of ' + l.DTI_Tape__c.format() + '%, ';
					DtiSentence =   ((l.DTI_Tape__c==null || l.DTI_Tape__c==0)?
                                    ((l.LENDER_APPROVAL_DTI__C==null || l.LENDER_APPROVAL_DTI__C==0)? 
                        			'':
                                    'was calculated by the Seller at ' + l.LENDER_APPROVAL_DTI__C.format() + '%.'):
                    				'was calculated by the Seller at ' + l.DTI_Tape__c.format() + '%.');  
                }
                
                // concurrent
                if (l.X2nd_lien_note_found_in_the_file__c == null || l.X2nd_lien_note_found_in_the_file__c.tolowercase() == 'n/a') {
                    
                    l.loan_summary_auto__c = 'The subject 2nd lien in the amount of $' + (l.Original_Balance__c==null?'XXXXXX':l.Original_Balance__c.format()) + ' closed concurrently on ' + (l.Note_Date__c==null?'XXXXXX':l.Note_Date__c.format()) +' with a 1st lien in the amount of $'
                                             + (l.X1st_Lien_Amount__c==null?'XXXXXX':(l.X1st_Lien_Amount__c).format()) + '.  The loan proceeds were used towards the ' + Purpose + ' of ' + iaOccupancy + ', ' + PropType  
                                             + ' property located in ' + (l.property_city__c==null?'XXXXXX':l.property_city__c) + ', ' + (l.property_state__c==null?'XXXXXX':l.property_state__c) + '.  The file contained a loan transmittal and/or approval which confirmed the loan was approved under the Seller\'s "'
                                             + DocType + '" documentation program with a Loan-to-Value (LTV) of ' + (l.LTV_Tape__c==null?'XXXXXX':l.LTV_Tape__c.format()) + '%, '
                                             + cltvClause + DtiSentence + (l.FICO_Tape__c==null?' and no credit score for the primary foreign national borrower.':' and a qualifying credit score of '+ l.FICO_Tape__c.format() + ' for the primary borrower.');
                    System.debug(l.loan_summary_auto__c );
                
                }
                // not concurrent
                else {
                    
                    l.loan_summary_auto__c = 'The subject 2nd lien in the amount of $' + (l.Original_Balance__c==null?'XXXXXX':l.Original_Balance__c.format()) + ' closed on ' + (l.Note_Date__c==null?'XXXXXX':l.Note_Date__c.format()) +' with a non-concurrent 1st lien in the amount of $'
                                             + (l.X1st_Lien_Amount__c==null?'XXXXXX':(l.X1st_Lien_Amount__c).format()) + '.  The loan proceeds were used towards the ' + Purpose + ' of ' + iaOccupancy + ', ' + PropType  
                                             + ' property located in ' + (l.property_city__c==null?'XXXXXX':l.property_city__c) + ', ' + (l.property_state__c==null?'XXXXXX':l.property_state__c) + '.  The file contained a loan transmittal and/or approval which confirmed the loan was approved under the Seller\'s "'
                                             + DocType + '" documentation program with a Loan-to-Value (LTV) of ' + (l.LTV_Tape__c==null?'XXXXXX':l.LTV_Tape__c.format()) + '%, '
                                             + cltvClause + DtiSentence + (l.FICO_Tape__c==null?' and no credit score for the primary foreign national borrower.':' and a qualifying credit score of '+ l.FICO_Tape__c.format() + ' for the primary borrower.');    
                
                }
             System.debug(l.loan_summary_auto__c );
            }
            else {
                l.loan_summary_auto__c = null;
                System.debug(l.loan_summary_auto__c );
            }
            
            
        }    
            
    }
}