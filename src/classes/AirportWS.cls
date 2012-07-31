public class AirportWS {

    @future (callout=true)
    public static void setAirportCodeOnJets(Set<ID> theIDs) {
        AirportWS.airportSoap a = new AirportWS.airportSoap();
        List<Jets__c> theJets = [select id, airportLocation__c, airportCode__c from Jets__c where id in :theIDs];
        for (Jets__c j : theJets) {
            String s = a.getAirportInformationByAirportCode(j.AirportCode__c); 
            Dom.Document doc = new Dom.Document();
            doc.load(s);
            Dom.XMLNode root = doc.getRootElement();
            DOM.XMLNode table = root.getChildElement('Table',null);
            DOM.XMLNode AptName = table.getChildElement('CityOrAirportName',null);
            j.AirportLocation__c = AptName.getText();
        }
        update theJets;
    }
    public class airportSoap {
        public String endpoint_x = 'http://www.webservicex.net/airport.asmx';
        public Map<String,String> inputHttpHeaders_x;
        public Map<String,String> outputHttpHeaders_x;
        public String clientCertName_x;
        public String clientCert_x;
        public String clientCertPasswd_x;
        public Integer timeout_x;
        private String[] ns_map_type_info = new String[]{'http://www.webserviceX.NET', 'AirportWS'};
        public String getAirportInformationByAirportCode(String airportCode) {
            AirportWS.getAirportInformationByAirportCode_element request_x = new AirportWS.getAirportInformationByAirportCode_element();
            AirportWS.getAirportInformationByAirportCodeResponse_element response_x;
            request_x.airportCode = airportCode;
            Map<String, AirportWS.getAirportInformationByAirportCodeResponse_element> response_map_x = new Map<String, AirportWS.getAirportInformationByAirportCodeResponse_element>();
            response_map_x.put('response_x', response_x);
            WebServiceCallout.invoke(
              this,
              request_x,
              response_map_x,
              new String[]{endpoint_x,
              'http://www.webserviceX.NET/getAirportInformationByAirportCode',
              'http://www.webserviceX.NET',
              'getAirportInformationByAirportCode',
              'http://www.webserviceX.NET',
              'getAirportInformationByAirportCodeResponse',
              'AirportWS.getAirportInformationByAirportCodeResponse_element'}
            );
            response_x = response_map_x.get('response_x');
            return response_x.getAirportInformationByAirportCodeResult;
        }
    }
    public class getAirportInformationByAirportCodeResponse_element {
        public String getAirportInformationByAirportCodeResult;
        private String[] getAirportInformationByAirportCodeResult_type_info = new String[]{'getAirportInformationByAirportCodeResult','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webserviceX.NET','true','false'};
        private String[] field_order_type_info = new String[]{'getAirportInformationByAirportCodeResult'};
    }
    public class getAirportInformationByAirportCode_element {
        public String airportCode;
        private String[] airportCode_type_info = new String[]{'airportCode','http://www.w3.org/2001/XMLSchema','string','0','1','false'};
        private String[] apex_schema_type_info = new String[]{'http://www.webserviceX.NET','true','false'};
        private String[] field_order_type_info = new String[]{'airportCode'};
    }
}