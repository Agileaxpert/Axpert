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