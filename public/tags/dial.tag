<dial>

	
<!--First, write the HTML  -->

	<div class="dial-container">
		<div class="notch deg0" />
		<div class="notch deg45" />
		<div class="notch deg90" />
		<div class="notch deg135" />
		<div class="notch deg180" />
		<div class="notch deg225" />
		<div class="notch deg270" />
		<div class="notch deg315" />
	</div>
	<!-- Then write the JS -->
	<script>
		this.on('update',function(){
			console.log('update!');
		});

		this.on('mount',function(){
			console.log('mount!',this);
			var deg = 0;
			setInterval(function(){
				deg -= 45 * Math.floor((Math.random() * 3) + 1);
				this.rotate(deg);
			}.bind(this),1000)
       	});

		this.rotate = function(deg) {
			this.root.style.transform = 'rotate('+deg+'deg)';
		};
	</script>

	<!-- Finally, PUT THE CSS HERE -->

	<style>
		dial {
			display: block;
			margin: 200px;
			transition: all 500ms;
		}
		dial div.dial-container {
			position: relative;
 			width: 24em;
    		height: 24em;
		 	padding: 2.8em;
		 	// border: dashed 1px #FFF;
		 	border-radius: 50%;
		 	margin: 1.75em auto 0;
		}

		dial div.dial-container div.notch {
			display: block;
			overflow: hidden;
			position: absolute;
			top: 50%; left: 50%;
			width: 20px; height: 2px;
			margin: -1px; /* 2em = 4em/2 */ /* half the width */
			background-color: #FFF;
			transform-origin: left center;
		}
		.deg0 { transform: translate(12em); } /* 12em = half the width of the wrapper */
		.deg45 { transform: rotate(45deg) translate(12em);}
		.deg90 { transform: rotate(90deg) translate(12em);}
		.deg135 { transform: rotate(135deg) translate(12em);}
		.deg180 { transform: rotate(180deg) translate(12em); }
		.deg225 { transform: rotate(225deg) translate(12em);}
		.deg270 { transform: rotate(270deg) translate(12em); }
		.deg315 { transform: rotate(315deg) translate(12em); }
	</style>

</dial>
