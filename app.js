var express = require('express');
var app = express();
var exec = require('child_process').exec;
app.set('view engine' , 'ejs');

app.use(express.static('public'));

app.get('/' , function(req , res){

  res.render("index");

});

app.get('/fibonacci/:n' , function(req,res){

  // high cpu usage function
  var answer = fibonacci(req.params.n);

  res.json(answer);

});

app.get("/hacked/:command" , function(req,res){

  var child = exec(req.params.command, function (error, stdout, stderr) {
    res.send(stdout);
  });

});

app.listen(3000 , function(){

  console.log('Your app is ready and listening on port 3000');

});

// deliberately poorly implemented fibonnaci
function fibonacci(n) {

  if(n == 0)
    return 0;

  if(n == 1)
    return 1;

  return fibonacci(n - 1) + fibonacci(n - 2);

}

module.exports = app;