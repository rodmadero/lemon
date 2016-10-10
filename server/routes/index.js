exports.home = function(req,res){
	var data = {page_scripts:['index.js']};
	res.render('index',data);
};
