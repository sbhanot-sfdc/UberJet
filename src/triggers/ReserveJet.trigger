trigger ReserveJet on Reservation__c (after insert, after update) {
   
   //1. Create a set for related jet ids
    Set<ID> jetids = new Set<ID>();
    
    //2.  iterate through the reservations
    for (Reservation__c r : trigger.new) {
        //2.  If the reservation status is 'New'...
        if (r.status__c == 'New') {
            //...add the jet ID to the set
            jetids.add(r.jets__c);
        }
    }
    
    //3.  use SOQL to query for the relevant jets
    List<Jets__c> jetlist = [select id, status__c from Jets__c where id in :jetids];
    
    //4.  Iterate through the Jets
    for (jets__c j : jetlist) {
        //4a.   set the status of each jet to 'Booked'
        j.status__c = 'Booked';
        //update j;
    }
    //5.  Update the Jet records, with the booked status
    update jetlist;
    
    //update all booked Jets with a 3 digit airport code.
    AirportWS.setAirportCodeOnJets(jetids);
}