A fully functional example of use of AxList API in Axpert is demonstrated here.

1) Create a table and insert sample data from the Sample SQLs.txt file.
2) Create an ADS from the ADS Samples.txt file.
3) Use HTML file Employee Master Sample.html to test the AxList API from Custom HTML page.

3) Calling AxList API from Custom HTML pages:
	a) To call the AxList API from Custom HTML pages, refer AxInterface.js from Axpert JS folder.
	b) Call GetDataFromAxList function from your custom HTML page to get the data from AxList API.
	d) You can modify the filters, sorting, pagination, refreshcache, ADS mode parameters in the GetDataFromAxList function 'props' node and test the API based on your ADS definition.

4) Call the AxList API from postman/mobile app/external apps:
	a) Refer the API JSON.txt file for the sample API request.
	b) You can use postman or any other API testing tool to test the API.
	c) You can also call the API from your mobile app or any other external app.
	d) You can modify the filters, sorting, pagination parameters in the API JSON.txt file and test the API based on your ADS definition.


Sample Javascript method synax:
-------------------------------
/**
 * @description : Call GetDataFromAxList Asynchronously
 * @Example
 GetDataFromAxList({   
    "adsNames": [
            "employee_master_ads"
    ],    
    "refreshCache": true,
    "sqlParams": {
        "userparam_state": "Karnataka"
    },
    "keyField": "username",
    "keyValue": "ALL",
    "props" : {
        "ADS" : true,
        "CachePermissions": true,
        "getallrecordscount": false, //Optional flag to get total record count without pagination. Will be helpful in scenarios where total record count of ADS is needed.        
        "pageno": 1,
        "pagesize": 100, //Pass 0 to fetch all records. Pass pagesize value to fetch records as per pagination.
        "keyfield": "",
        "keyvalue": "",
        "AxClient_dateformat" : "", //Optional flag to pass client date format to convert date fields. Date fields in filters should be in same format as passed in this parameter
        "select_columns" : ["username","sqlsrc"], //optional.add your select cols here
        "aggregations" : {"total_sqlname": "count(*)"}, //optional. add your aggregation columns here with alias as key and aggregation sql as value
        "groupby_columns" : ["username","sqlsrc"], //optional. add your group by cols here 
        "sorting": [
            {
                "fldname": "employee_code",
                "sort_order": "desc"
            }
        ],
        "filters": [
            {
                "fldname": "gender",
                "datatype": "TEXT",
                "value": "Female",
                "condition": "CONTAINS"
            },
            {
                "fldname": "salary",
                "datatype": "NUMERIC",
                "from": "1000",
                "to": "100000000"
            },
            {
                "fldname": "department",
                "datatype": "DROPDOWN",
                "value": [
                   "HR", "Finance", "Sales", "IT"
                ]
            }
        ]
    }
}
, function(data){ successlogics()}, function(data){ errorlogics()})
 */