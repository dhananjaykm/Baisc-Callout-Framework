# Basic-Callout-Framework

### Add "HeaderParameters__c" and "URLParameters__c" fields** with the relevant JSON or key-value pairs in config metadata record. For example:

**HeaderParameters__c**: {"Authorization": "Bearer Token", "Custom-Header": "Value"}
**URLParameters__c**: {"param1": "value1", "param2": "value2"}


### Instantiate the CalloutFramework with a configuration name**
`CalloutFramework callout = new CalloutFramework('Example_Config');

// Add header parameters
Map<String, String> headers = new Map<String, String>{
    'Authorization' => 'Bearer YourToken',
    'Custom-Header' => 'HeaderValue'
};
callout.addHeaderParameters(headers);

// Append URL parameters
Map<String, String> urlParams = new Map<String, String>{
    'param1' => 'value1',
    'param2' => 'value2'
};
callout.appendURLParameters(urlParams);

// Make the callout
String response = callout.makeCallout();

// Process the response as needed
System.debug('Response: ' + response);
`
