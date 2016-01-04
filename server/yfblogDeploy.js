var http = require('http');
var querystring = require('querystring');

function processPost(request, response, callback) {
    var queryData = "";
    if(typeof callback !== 'function') return null;

    if(request.method == 'POST') {
        request.on('data', function(data) {
            queryData += data;
            if(queryData.length > 1e6) {
                queryData = "";
                response.writeHead(413, {'Content-Type': 'text/plain'}).end();
                request.connection.destroy();
            }
        });

        request.on('end', function() {
            if(request.headers['content-type'].toLowerCase()==='application/json'){
                try{
                    request.body = JSON.parse(queryData);

                }catch(e){
                    request.body = null;
                }
            }else{
                request.body = querystring.parse(queryData);

            }

            request.route = require('url').parse(request.url, true);
            
            callback();
        });

    } else {
        response.writeHead(405, {'Content-Type': 'text/plain'});
        response.end();
    }
}
http.createServer(function(req, res) {
    if(req.method == 'POST') {

        processPost(req, res, function() {

            if(req.route.path === '/blog'){

                if(req.body){
                    console.log(req.body.repository)
                    console.log(req.body.repository.name);
                    console.log(req.body.repository.owner.name);
                    var username = req.body.repository.owner.name;
                    var repo_name = req.body.repository.name;


                    console.log(username+'/'+repo_name+' git push event'+new Date());
                    var spawn = require('child_process').spawn,
                        deploy = spawn('sh', [ './deploy.sh',username,repo_name]);
                    deploy.stdout.on('data', function (data) {
                        console.log(''+data);
                    });

                    deploy.on('error',function(err){
                        console.log(err);
                    });
                    deploy.on('close', function (code) {
                        console.log('Child process exited with code ' + code);
                    });
                    res.writeHead(200, "OK", {'Content-Type': 'application/json'});
                    res.end(JSON.stringify( {message: 'Github Hook received!'}));

                }else{
                    res.writeHead(413, {'Content-Type': 'text/plain'});
                    res.connection.destroy();
                }

            }else{
                res.writeHead(413, {'Content-Type': 'text/plain'});
                res.connection.destroy();
            }


        });
    } else {
        res.writeHead(200, "OK", {'Content-Type': 'text/plain'});
        res.end("deploy is ok.");
    }

}).listen(8112,function(){
    console.log('listen 8112');
});


