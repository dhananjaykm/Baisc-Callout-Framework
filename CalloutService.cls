public class CalloutService {
    private String configName;
    private HttpRequest request;

    //Custom metadata fields
    private String endpoint;
    private String method;
    private String requestBody;
    private String headers;
    private String urlParameters;

   

    public CalloutService(String configName) {
        this.configName = configName;
    }

    public void makeCallout() {
        // Query the custom metadata records based on the configName
        Callout_Configuration__mdt config = [SELECT Endpoint__c, Method__c, RequestBody__c, Headers__c, URLParameters__c
                                             FROM Callout_Configuration__mdt
                                             WHERE DeveloperName = :configName
                                             LIMIT 1];

        setEndpoint(config.Endpoint__c);
        setMethod(config.Method__c);
        setRequestBody(config.RequestBody__c);
        setHeaders(config.Headers__c);
        setURLParameters(config.URLParameters__c);
        
        request = createRequest(config);
    }

    // Method to create an HttpRequest
    private HttpRequest createRequest() {
        request = new HttpRequest();
        request.setEndpoint(endpoint);
        request.setMethod(method);
        request.setRequestBody(requestBody);
        //url parameters 

        if (config.Method__c == 'POST' || config.Method__c == 'PUT') {
            request.setHeader('Content-Type', 'application/json');
            request.setBody(config.RequestBody__c);
        }

        return request;
    }

    // Getter and setter methods for custom metadata fields
    public String getEndpoint() {
        return endpoint;
    }

    public void setEndpoint(String endpoint) {
        this.endpoint = endpoint;
    }

    public String getMethod() {
        return method;
    }

    public void setMethod(String method) {
        this.method = method;
    }

    public String getRequestBody() {
        return requestBody;
    }

    public void setRequestBody(String requestBody) {
        this.requestBody = requestBody;
    }

    public String getHeaders() {
        return headers;
    }

    public String getURLParameters() {
        return urlParameters;
    }
    /*
    public void setHeaders(String headers) {
        this.headers = headers;
    }
    public void setURLParameters(String urlParameters) {
        this.urlParameters = urlParameters;
    }
    */

    

    // Method to set headers
    private void setHeaders(String headersJson) {
        if (!String.isBlank(headersJson)) {
            Map<String, Object> headersMap = (Map<String, Object>) JSON.deserializeUntyped(headersJson);

            for (String key : headersMap.keySet()) {
                request.setHeader(key, String.valueOf(headersMap.get(key)));
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
        request = createRequest();
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
    public HTTPResponse sendRequest() {
        request = createRequest();
        
        Http http = new Http();
        return http.send(request);

    }
}
