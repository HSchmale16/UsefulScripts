#!/usr/bin/env node

var child_process = require('child_process');
var spawn = child_process.spawn;
var exec = child_process.exec;
var rl = require('readline');

var revlist = spawn('git', ['rev-list', 'HEAD']);
var revreader = rl.createInterface(revlist.stdout, revlist.stdin);

var childrenProcess = 0;
var data = {};

function createCommitBlob(date, value){
    return {date: date, value: parseInt(value)};
}

revreader.on('line', function (commitid) {
    var lingcmd = "git linguist stats --commit=" + commitid;
    exec(lingcmd, function (err, lingOut) {
        var datecmd = "git show -s --format=%at " + commitid;
        exec(datecmd, function(err, date){
            var json = JSON.parse(lingOut);
            for(k in json){
                if(data[k] === undefined){
                    data[k] = [];
                }
                data[k].push(createCommitBlob(date, json[k]))
            }
            childrenProcess--;
        });
        childrenProcess++;
        childrenProcess--;
    });
    childrenProcess++
});

function generateGraph(){
    console.log(JSON.stringify(data));
}

function waitForChildProcessesToDie(){
    if(childrenProcess != 0){
        setTimeout(waitForChildProcessesToDie, 1000);
    }else{
        generateGraph();
    }
}

revreader.on('close', waitForChildProcessesToDie);