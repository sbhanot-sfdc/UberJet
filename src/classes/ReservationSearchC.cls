public class ReservationSearchC {
    
    public String reservationNum {get;set;}                                     
    public String celebrityName {get;set;}
    public String destination {get;set;}
    public String city {get;set;}
    public List<Reservation__c> searchResults {get;set;}
    private boolean firstFilterApplied = false;
    
    public ReservationSearchC(){
        searchResults = new List<Reservation__c>();
    }

    public PageReference search(){
        searchResults.clear();
        firstFilterApplied = false;
        try{
            //Create the dynamic SOQL query
            String queryString = 'SELECT name, celebrity__c, celebrity__r.name, destination__c, city__c, status__c '+
                                 'FROM Reservation__c ';
            
            if (reservationNum != null && reservationNum != ''){
                reservationNum = String.escapeSingleQuotes(reservationNum); //To avoid SOQL injection
                reservationNum = reservationNum.startsWith('%') ? reservationNum : '%' + reservationNum;
                reservationNum = reservationNum.endsWith('%') ? reservationNum : reservationNum + '%';
                queryString += whereOrAndClause() + ' name like \''+reservationNum+'\'';
            }
            
            if (celebrityName != null && celebrityName != ''){
                celebrityName = String.escapeSingleQuotes(celebrityName); //To avoid SOQL injection
                celebrityName = celebrityName.startsWith('%') ? celebrityName : '%' + celebrityName;
                celebrityName = celebrityName.endsWith('%') ? celebrityName : celebrityName + '%';
                queryString += whereOrAndClause() + ' celebrity__r.name like \''+celebrityName+'\'';
            }
            
            if (destination != null && destination != ''){
                destination = String.escapeSingleQuotes(destination); //To avoid SOQL injection
                queryString += whereOrAndClause() +' destination__c = \''+destination+'\'';
            }
            
            if (city != null && city != ''){
                city = String.escapeSingleQuotes(city); //To avoid SOQL injection
                queryString += whereOrAndClause() + ' city__c = \''+city+'\'';
            }
            
            searchResults = Database.query(queryString);
        }
        catch(QueryException e){
            //If the query returns more than 1000 records, display an error to the user
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Too many Reservation records found that match the specified search criteria. Please refine your search criteria and try again'));
            return null;
        }
        catch(Exception e1){
             ApexPages.addMessages(e1);
             return null;
        }        

        if (searchResults.size() == 0){
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'The specified search criteria did not match any existing Reservation records. Please try again'));
        }
                
        return null;

    }
    
    private String whereOrAndClause(){
        String queryClause;
        if (firstFilterApplied){
            queryClause = ' AND ';
        }
        else{
            queryClause = ' WHERE ';
        }
        firstFilterApplied = true;
        return queryClause;
    }
}