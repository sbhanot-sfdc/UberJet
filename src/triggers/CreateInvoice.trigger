trigger CreateInvoice on Reservation__c (after insert) {
    
    //1.  Set the value of the upcharge
    Double upcharge = 1.2;
    
    //2.  Create a collection for saving new invoices
    List<Invoice__c> newInvoices = new List<Invoice__c>();
    
    //3.  Iterate through the new reservations
    for (Reservation__c rez : trigger.new) {

        //3a.  For each reservation, create a new invoice
        Invoice__c freshInvoice = new Invoice__c();
        freshInvoice.reservation__c = rez.id;
        freshInvoice.celebrity__c = rez.celebrity__c;

        //3b.  Upcharge that celebrity
        freshInvoice.cost__c = rez.cost__c * upcharge;

        //NO NO!
        //insert freshInvoice;
        
        //3c.  Add the new invoice to the collection
        newInvoices.add(freshInvoice);
    }

    //4.  Save the new invoices
    insert newInvoices;
}