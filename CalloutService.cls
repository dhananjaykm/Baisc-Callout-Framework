public class CalloutFramework {
    private String configName;
    private HttpRequest request;

    public CalloutFramework(String configName) {
        this.configName = configName;
    }

    public String makeCallout() {
        // Query the custom metadata records based on the configName
        Callout_Configuration__mdt config = [SELECT Endpoint__c, Method__c, RequestBody__c, Headers__c, URLParameters__c
                                             FROM Callout_Configuration__mdt
                                             WHERE DeveloperName = :configName
                                             LIMIT 1];

        request = createRequest(config);
        setHeaders(config.Headers__c);
        setURLParameters(config.URLParameters__c);

        return sendRequest();
    }

    // Method to create an HttpRequest
    private HttpRequest createRequest(Callout_Configuration__mdt config) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(config.Endpoint__c);
        req.setMethod(config.Method__c);

        if (config.Method__c == 'POST' || config.Method__c == 'PUT') {
            req.setHeader('Content-Type', 'application/json');
            req.setBody(config.RequestBody__c);
        }

        return req;
    }

    // Method to set headers
    private void setHeaders(String headersJson) {
        if (!String.isBlank(headersJson)) {
            Map<String, String> headers = (Map<String, String>) JSON.deserializeUntyped(headersJson);
            for (String key : headers.keySet()) {
                request.setHeader(key, headers.get(key));
            }
        }
    }

    // Method to set URL parameters
    private void setURLParameters(String urlParametersJson) {
        if (!String.isBlank(urlParametersJson)) {
            Map<String, String> urlParameters = (Map<String, String>) JSON.deserializeUntyped(urlParametersJson);
            String queryString = '';
            for (String key : urlParameters.keySet()) {
                queryString += key + '=' + EncodingUtil.urlEncode(urlParameters.get(key), 'UTF-8') + '&';
            }

            if (!String.isBlank(queryString)) {
                // Remove the trailing '&'
                queryString = queryString.substring(0, queryString.length() - 1);
                request.setEndpoint(request.getEndpoint() + '?' + queryString);
            }
        }
    }

    // Method to send an HttpRequest and return the response
    public String sendRequest() {
        Http http = new Http();
        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200) {
            return response.getBody();
        } else {
            return 'Error: ' + response.getStatusCode() + ' - ' + response.getStatus();
        }
    }

    // Method to append URL parameters
    public void appendURLParameters(Map<String, String> params) {
        String queryString = '';
        for (String key : params.keySet()) {
            queryString += key + '=' + EncodingUtil.urlEncode(params.get(key), 'UTF-8') + '&';
        }

        if (!String.isBlank(queryString)) {
            // Remove the trailing '&'
            queryString = queryString.substring(0, queryString.length() - 1);
            request.setEndpoint(request.getEndpoint() + '?' + queryString);
        }
    }

    // Method to add header parameters
    public void addHeaderParameters(Map<String, String> headers) {
        for (String key : headers.keySet()) {
            request.setHeader(key, headers.get(key));
        }
    }
}
