This html sample helps us to execute a script attached to a tstruct or iview from a custom page.

 Description : Execute script Asynchronously
 * Parameter 1 -> script (string datatype): Script name - your scriptname. 
 * Parameter 2 -> type (string datatype): Structure type - form/report
 * Parameter 3 -> name (string datatype): Structure name - transid/iview name
 * Parameter 4 -> recordid (string datatype): Recordid in case of tstruct based script. Default should be "0"
 * Parameter 5 -> apiParams (object datatype) = key value pairs of API params to be passed from client side. Value should have data type mentioned delimited by a ~. 
	Eg: var apiParams = { "param1" : "value1~c", "param2" : "value2_d" };
 * Parameter 6 -> Success callback function (function type)
 * Parameter 7 -> Error callback function (function type)

Example:
AxCallScriptAPIAsync("sendtask", "report", "taskslst", "0", { "param1" : "value1~c", "param2" : "value2_d" }, function(data){ successlogics()}, function(data){ errorlogics()});

Please refer the HTML for a working sample for the script:
 
firesql({A},{UPDATE tdepd1 SET field1=:field1 WHERE field2=:field2})
