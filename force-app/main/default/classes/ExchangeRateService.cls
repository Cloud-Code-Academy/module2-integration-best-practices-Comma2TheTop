/**
 * @description Service class that handles API callouts to the Exchange Rate API
 * Students will implement the methods to make callouts and process responses
 */
public class ExchangeRateService {
    
    // The named credential to use for the callout
    private static final String NAMED_CREDENTIAL = 'ExchangeRate_API';
    
    // The base currency to use for exchange rates
    private static final String BASE_CURRENCY = 'USD';

    //private static String apiKey = 'ffea76502ad59ed89b4187e7';
    //API_Key__mdt exchangeRateAPIKey = [SELECT Key_Value__c FROM API_Key__mdt WHERE DeveloperName = 'ExchangeRate'];
    //String apiKey = exchangeRateAPIKey.API_Key__c;
    //String endpoint = 'callout:'+ NAMED_CREDENTIAL + apiKey + '/latest/' + BASE_CURRENCY;
    //System.debug('Endpoint: ' + endpoint);
    
    /**
     * @description Makes a callout to the Exchange Rate API to get the latest exchange rates
     * @return ExchangeRateWrapper containing the response data
     */
    public static ExchangeRateWrapper getLatestRates() {
        // TODO: Implement the method to make a callout to the Exchange Rate API
        try{
        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:'+ NAMED_CREDENTIAL+'/'+ BASE_CURRENCY);
        //req.setEndpoint('https://v6.exchangerate-api.com/v6/ffea76502ad59ed89b4187e7/latest/USD');
        req.setMethod('GET');
        req.setTimeout(120000);

        Http http = new Http();
        HttpResponse res = http.send(req);

        if (res.getStatusCode() >= 200 && res.getStatusCode() <300) {
            if(String.isNotBlank(res.getBody())){
            ExchangeRateWrapper responseForWrapper = ExchangeRateWrapper.parse(res.getBody());
            System.debug('Deserialized Response: ' + responseForWrapper);
            return responseForWrapper;
            } else {
                throw new CalloutException('Error: Empty Body');
            }
        } else {
        throw new CalloutException('Error '+ res.getStatusCode());
    }
} catch (Exception e){
        System.debug('Exception occurred: ' + e.getMessage());
        throw new CalloutException('Exception ' + e.getMessage());
    }
}
    /**
     * @description Processes the exchange rate data and creates or updates records
     * @param rateData The wrapper containing exchange rate data
     * @return List<Exchange_Rate__c> The list of records created or updated
     */
    public static List<Exchange_Rate__c> processRates(ExchangeRateWrapper rateData) {
        // TODO: Implement the method to process rates and create/update records
        List<Exchange_Rate__c> processRatesList = rateData.toExchangeRates();
        upsert processRatesList External_Id__c;
        
        return processRatesList; // Replace with actual implementation
    }
    
    /**
     * @description Combines getting and processing rates into a single operation
     * @return List<Exchange_Rate__c> The list of records created or updated
     */
    public static List<Exchange_Rate__c> updateExchangeRates() {
        // TODO: Implement the method to get and process rates
        // 1. Call getLatestRates to retrieve the data
        // 2. Call processRates to create/update records
        // 3. Return the processed records
        ExchangeRateWrapper wrapperData = getLatestRates();
        
        return processRates(wrapperData); // Replace with actual implementation
    }
}