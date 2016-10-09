exports.home = function(req,res){
    var data = {test: 'test', page_script:'test.js'};
    res.render('index',data);
};
