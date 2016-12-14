<dial>

	
<!--First, write the HTML  -->

	<div class="dial-container">
	</div>
	<div class="logo-container">
		<div class="logo" />
	</div>
	<!-- Then write the JS -->
	<script>
		this.on('update',function(){
			console.log('update!');
		});

		this.on('mount',function(){
			console.log('mount!',this);
			var deg = 0;
			this.buildNotches();
			setInterval(function(){
				deg -= 45 * Math.floor((Math.random() * 3) + 1);
				this.rotate(deg);
			}.bind(this),1000);  
		});

		this.rotate = function(deg) {
			this.root.firstChild.style.transform = 'rotate('+deg+'deg)';
		};
		this.buildNotches = function(){
			for (var i=0;i<360;i+=3){
				var notch = document.createElement('DIV'),
					dot = document.createElement('DIV');

				notch.className = 'perimeter notch';
				dot.className = 'perimeter dot';

				if (i % 45 === 0) { 
					notch.className += ' highlight';
					dot.className += ' highlight';
				}

				notch.style.transform = 'rotate('+i+'deg) translate(12em)';
				dot.style.transform = 'rotate('+i+'deg) translate(11em)';				
				
				this.root.firstChild.appendChild(notch);
				this.root.firstChild.appendChild(dot);
			}
		}
	</script>

	<style>
		dial {
			display: block;
			margin: 200px;
		}
		dial div.dial-container {
			position: relative;
 			width: 24em;
    		height: 24em;
		 	padding: 2.8em;
		 	border-radius: 50%;
		 	margin: 1.75em auto 0;
			transition: all 500ms;
		}

		dial div.dial-container div.perimeter {
			display: block;
			overflow: hidden;
			position: absolute;
			top: 50%; left: 50%;
			background-color: #333;
			transform-origin: left center;
		}
		dial div.dial-container div.perimeter.notch {
			width: 20px;
			height: 2px;
		}
		dial div.dial-container div.perimeter.dot {
			width: 2px;
			height: 2px;
			border-radius: 2px;
		}
		dial div.dial-container div.perimeter.highlight {
			background-color: #FFF;
		}
		dial div.dial-container div.perimeter.notch.highlight {
			width: 25px;
		}
		dial div.logo-container {
		    	position: relative;
			top: -300px;
			width: 24em;
			height: 24em;
		    	padding: 2.8em;
		    	border-radius: 50%;
		    	margin: 1.75em auto 0;	
		}
		dial div.logo-container div.logo {
			margin: 0 auto;
			height: 155px;
			width: 100px;
			background-image: url(/public/img/dancingman.gif);
			background-repeat: no-repeat;
			background-size: 100% auto;
		}
	</style>

</dial>
