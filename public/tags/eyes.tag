<eyes>

	
<!--First, write the HTML  -->

	<img>


	<!-- Then write the JS -->
	<script>
		var angle = 0,
		    img = null,
		    src = [
			'http://www.drthomasphillips.com/wp-content/uploads/2015/05/How-to-maintain-healthy-eyes1.jpg',
			'https://cdn.shopify.com/s/files/1/0873/9514/files/Wmm_303_Green.png?7542990654003841877',
			'http://i2.cdn.turner.com/cnnnext/dam/assets/150304150953-more-blue-eyes-exlarge-169.jpg',
			'http://www.usefulhomeremedies.com/wp-content/uploads/2014/11/home-remedies-dark-circle.jpg',
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
			img.src = src[getInt(0,3)];
			img.style.top = getInt()+'%';
			img.style.left = getInt()+'%';
			var work = setInterval(move,getInt(300,500));
			img.addEventListener('click',function(){
				clearInterval(work);
			});
                });
	</script>

	<!-- Finally, PUT THE CSS HERE -->

	<style>
		img {
			position: absolute;
			height: 100px;
			transition: all 300ms;
		}
	</style>

</eyes>
