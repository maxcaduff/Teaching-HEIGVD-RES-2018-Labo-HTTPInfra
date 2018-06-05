var Chance = require('chance');
var chance = new Chance();

var express = require('express');
var app = express();
var ip;

app.get('/hire', function(req,res) {
	ip = req.connection.localAddress;
	res.send(generateEmployees());
});

app.listen(3000, function() {
	console.log("Hi, up on port 3000.");
});

function generateEmployees(){

	var numberOfEmployees = chance.integer({
		min : 5,
		max : 10
	});
	console.log(numberOfEmployees);
	var employees = [];
	for(var i = 0; i < numberOfEmployees; i++){
		var employee = chance.animal() + ", " + chance.profession()
			+ " from " + chance.country({ full: true }) + " srv: " + ip
		employees.push(employee);
		};
	
	console.log(employees);
	return employees;
}
