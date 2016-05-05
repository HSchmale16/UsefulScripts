#!/usr/bin/node

var fs = require('fs');
var jsonString = fs.readFileSync('json', 'utf8');
var json = JSON.parse(jsonString);

var keys = Object.getOwnPropertyNames(json);

var data = {};

// create the inital data population
for(k in json){
    json[k].forEach(function(val){
        var ts = parseInt(val.date);
        if(data[ts] === undefined){
            data[ts] = {};
        }
        data[ts][k] = val.value;
    });
}

// create empty keys where needed
for(k in data){
    keys.forEach(function(lang){
        if(data[k][lang] === undefined){
            data[k][lang] = 0;
        }
    });
}

var dateList = Object.getOwnPropertyNames(data);
dateList.sort();
for(i = 0; i < dateList; i++){
    console.log(data[dateList[i]]);
}
