@isTest
public class Test_ReserveJet {
    static List<Celebrity__c> celebs;
    static List<Jets__c> jets;
    
    public static testmethod void RegularTests() {
        createSimpleTestData();
        
        Test.startTest();
        
        runTestOne();          //test 1 - create a reservation
        runTestTwo();          //test 2 - create a reservation not in New Status
        runTestThree();        //test 3 - create a reservation for an already booked jet
        runTestFour();         //test 4 - create a reservation for an out of service jet
        runTestFive();         //test 5 - update a reservation to "new" status
        
        Test.stopTest();
    }
    

    public static testmethod void BulkTests() {
        createBulkTestData();
        
        Test.startTest();
        
        runBulkTest();

        Test.stopTest();
    }
    
    //data setup functions    
    private static Jets__c createJet(String jName, String aptCode, String status) {
        return new Jets__c(name=jName, AirportCode__c = aptCode, Status__c = status);
    }
    
    private static Celebrity__c createCelebrity(String cName, id handlerID) {
        return new Celebrity__c(name=cName, handler__c = handlerID);
    }
    
    private static Contact createContact(String fName, String lName, String emailAddy) {
        return new Contact(firstName = fName, lastName = lName, email=emailAddy);
    }
    
    private static Reservation__c addFields(Reservation__c rez, id celebID, id jetID) {
        rez.street__c = '1 Main Street';
        rez.city__c = 'Springfield';
        rez.state__c = 'IL';
        rez.country__c = 'USA';
        
        rez.destination__c = 'The Moon';
        
        rez.number_of_celebrities__c = 2;
        rez.num_of_miles__c = 30000;
        rez.cost__c = 4000;
        rez.celebrity__c = celebID;
        rez.jets__c = jetID;

        return rez;
    }
    
    private static void createSimpleTestData() {
        //create contacts for handlers
        List<Contact> handlers = new List<Contact>();
        for (Integer i=0; i<5; i++) {
            handlers.add(createContact('Jimbob'+i, 'Russell'+i, 'jrussell'+i+'@myworld.org'));
        }
        insert handlers;
        
        //create celebs
        celebs = new List<Celebrity__c>();
        for (Integer i=0; i<5; i++) {
            celebs.add(createCelebrity('Big Star '+i,handlers.get(i).id));
        }
        insert celebs;
        
        //create jets
        jets = new List<Jets__c>();
        jets.add(createJet('Wings','SFO','Available'));
        jets.add(createJet('Zoom','JFK','Available'));
        jets.add(createJet('Sonic','LHR','Booked'));
        jets.add(createJet('Lazy','HKG','Out of Service'));
        jets.add(createJet('Cloud','SIN','Available'));

        insert jets;        
    }

    private static void createBulkTestData() {
        //create contacts for handlers
        List<Contact> handlers = new List<Contact>();
        for (Integer i=0; i<10; i++) {
            handlers.add(createContact('Randy'+i, 'Riggins'+i, 'rriggins'+i+'@myworld.org'));
        }
        insert handlers;
        
        //create celebs
        celebs = new List<Celebrity__c>();
        for (Integer i=0; i<200; i++) {
            celebs.add(createCelebrity('Super Star '+i,handlers.get(math.mod(i,10)).id));
        }
        insert celebs;
        
        //create jets
        jets = new List<Jets__c>();
        for (Integer i=0; i<200; i++) {
            jets.add(createJet('Wings '+i,'SFO','Available'));
        }
        insert jets;        
    }
    
    public static void runTestOne() {
        //test 1 - create a reservation
        Jets__c j1 = jets[0];
        Reservation__c r1 = new Reservation__c();        
        r1 = addFields(r1, celebs[0].id, j1.id);
        r1.status__c = 'New';

        system.debug('Test 1: jet ' +j1.Name+ ' status before insert:  '+j1.status__c);
        insert r1;

        Jets__c j1_Updated = [select id, Name, Status__c from Jets__c where id = :j1.id];
        system.debug('Test 1: jet ' +j1_updated.Name+ ' status after insert:   '+j1_updated.status__c);
        system.assertEquals('Booked',j1_updated.status__c);
    }    

    public static void runTestTwo() {
        //test 2 - create a reservation not in New Status
        Jets__c j2 = jets[1];
        Reservation__c r2 = new Reservation__c();        
        r2 = addFields(r2, celebs[1].id, j2.id);
        r2.status__c = 'Postponed';

        system.debug('Test 2: jet ' +j2.Name+ ' status before insert:  '+j2.status__c);
        insert r2;

        Jets__c j2_Updated = [select id, Name, Status__c from Jets__c where id = :j2.id];
        system.debug('Test 2: jet ' +j2_updated.Name+ ' status after insert:   '+j2_updated.status__c);
        system.assertEquals(j2.status__c,j2_updated.status__c);
    }    

    public static void runTestThree() {
        //test 3 - create a reservation for an already booked jet
        Jets__c j3 = jets[2];
        Reservation__c r3 = new Reservation__c();        
        r3 = addFields(r3, celebs[2].id, j3.id);
        r3.status__c = 'New';

        system.debug('Test 3: jet ' +j3.Name+ ' status before insert:  '+j3.status__c);
        try {
            insert r3;
        } catch (DMLException d) {
            system.debug('rez for jet 3 failed:  ' + d);
        }
        
        Jets__c j3_Updated = [select id, Name, Status__c from Jets__c where id = :j3.id];
        system.debug('Test 3: jet ' +j3_updated.Name+ ' status after insert:   '+j3_updated.status__c);
        system.assertEquals(j3.status__c,j3_updated.status__c);
    }    
    
    public static void runTestFour() {
        //test 4 - create a reservation for an out of service jet
        Jets__c j4 = jets[3];
        Reservation__c r4 = new Reservation__c();        
        r4 = addFields(r4, celebs[3].id, j4.id);
        r4.status__c = 'New';

        system.debug('Test 4: jet ' +j4.Name+ ' status before insert:  '+j4.status__c);
        try {
            insert r4;
        } catch (DMLException d) {
            system.debug('rez for jet 4 failed:  ' + d);
        }
        
        Jets__c j4_Updated = [select id, Name, Status__c from Jets__c where id = :j4.id];
        system.debug('Test 4: jet ' +j4_updated.Name+ ' status after insert:   '+j4_updated.status__c);
        system.assertEquals(j4.status__c,j4_updated.status__c);
    }  

    public static void runTestFive() {
        //test 5 - update a reservation to "new" status
        Jets__c j5 = jets[4];
        Reservation__c r5 = new Reservation__c();        
        r5 = addFields(r5, celebs[4].id, j5.id);
        r5.status__c = 'In Progress';

        system.debug('Test 5: jet ' +j5.Name+ ' status before insert:  '+j5.status__c);
        insert r5;
        Jets__c j5_NotUpdated = [select id, Name, Status__c from Jets__c where id = :j5.id];
        system.debug('Test 5: jet ' +j5_notupdated.Name+ ' status after insert:   '+j5_notupdated.status__c);
        system.assertEquals(j5.status__c,j5_notupdated.status__c);
        
        r5.status__c = 'New';
        
        update r5;

        Jets__c j5_Updated = [select id, Name, Status__c from Jets__c where id = :j5.id];
        system.debug('Test 5: jet ' +j5_updated.Name+ ' status after insert:   '+j5_updated.status__c);
        system.assertEquals('Booked',j5_updated.status__c);
        
    }  
    
    public static void runBulkTest() {
        List<Reservation__c> bulkRez = new List<Reservation__c>();
        
        for (Integer i = 0; i < 200; i++) {
            Reservation__c rx = new Reservation__c();
            rx = addFields(rx, celebs[i].id, jets[i].id);
            rx.status__c = 'New';
            
            bulkRez.add(rx);
        }

        Jets__c jx = jets.get(27);
        system.debug('Bulk Test: jet ' +jx.Name+ ' status before insert:  '+jx.status__c);
        insert bulkRez;

        Jets__c jx_Updated = [select id, Name, Status__c from Jets__c where id = :jx.id];
        system.debug('Bulk Test: jet ' +jx_updated.Name+ ' status after insert:   '+jx_updated.status__c);
        system.assertEquals('Booked',jx_updated.status__c);
    }    
    
}