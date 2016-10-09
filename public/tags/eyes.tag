<eyes>
	<img>
	<script>
		var angle = 0,
		    img = null,
		    src = [
			'http://www.drthomasphillips.com/wp-content/uploads/2015/05/How-to-maintain-healthy-eyes1.jpg',
			'https://cdn.shopify.com/s/files/1/0873/9514/files/Wmm_303_Green.png?7542990654003841877',
			'http://cdn.playbuzz.com/cdn/9b47b752-dd61-42d8-865c-68344ce03aab/33785fe0-ce5c-44c4-8d97-a86479984e78.jpg',
			'http://i2.cdn.turner.com/cnnnext/dam/assets/150304150953-more-blue-eyes-exlarge-169.jpg',
			'http://www.usefulhomeremedies.com/wp-content/uploads/2014/11/home-remedies-dark-circle.jpg',
			'http://papre.com/wp-content/uploads/1371014826_Tips-to-Keep-Eyes-Healthy.jpg',
			'http://sarahsmakeupmorgue.weebly.com/uploads/6/7/4/0/6740397/560776_orig.jpeg',
			'https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQm2yOb5ojD07FsInR6FRFxde6WfuK1kf4q8BoiYDCxxJMMUMIWcw',
			'http://pictures.directnews.co.uk/liveimages/now+that+scientists+understand+that+the+bacteria+mouths+produce+naturally+can+lead+to+gum+disease+they+have+a+better+idea+of+how+to+combat+this+and+ot_1507_800629803_0_0_7047473_300.jpg',
			'http://pre15.deviantart.net/b02a/th/pre/f/2011/032/c/f/closed_mouth_15927871_by_stockproject1-d38l0yu.jpg'
		    ];

		var move = function() {
			angle += 15 * getInt(-10,10);
			img.style.transform = 'scale('+getInt(0,1)+'.'+getInt(1,9)+') rotateX('+angle+'deg) rotateZ('+angle+'deg) rotateY('+angle+'deg)';
			img.style.top = getInt(1,90)+'%';
			img.style.left = getInt(1,90)+'%';
		};

		var getInt = function(min,max) {
			max = max || 100;
			min = min || 1;

			return Math.floor(Math.random()*(max-min+1)+min);
		};

		this.on('update',function(){
			console.log('update!');
		});

		this.on('mount',function(){
			img = this.root.querySelector('img');
			img.src = src[getInt(0,9)];
			img.style.top = getInt()+'%';
			img.style.left = getInt()+'%';
			var work = setInterval(move,getInt(300,500));
			img.addEventListener('click',function(){
				clearInterval(work);
			});
                });
	</script>
	<style>
		img {
			position: absolute;
			height: 100px;
			transition: all 300ms;
		}
	</style>
</eyes>
