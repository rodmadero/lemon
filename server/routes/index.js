exports.home = function(req,res){
	var data = {page_scripts:['index.page.js']};
	res.render('pages/index',data);
};
