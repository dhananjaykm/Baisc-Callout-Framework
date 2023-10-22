# Basic-Callout-Framework

### Add "HeaderParameters__c" and "URLParameters__c" fields with the relevant JSON or key-value pairs in config metadata record. For example:

```
'HeaderParameters__c': {"Authorization": "Bearer Token", "Custom-Header": "Value"}

'URLParameters__c': {"param1": "value1", "param2": "value2"}
```


### Instantiate the CalloutFramework with a configuration name
```
CalloutService oCalloutService = new CalloutService('Example_Config');

// Add header parameters
Map<String, String> headers = new Map<String, String>{
    'Authorization' => 'Bearer YourToken',
    'Custom-Header' => 'HeaderValue'
};
oCalloutService.addHeaderParameters(headers);

// Append URL parameters
Map<String, String> urlParams = new Map<String, String>{
    'param1' => 'value1',
    'param2' => 'value2'
};
oCalloutService.appendURLParameters(urlParams);

// Make the callout
String response = oCalloutService.makeCallout();

// Process the response as needed
System.debug('Response: ' + response);
```
