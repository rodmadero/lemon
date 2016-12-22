<carousel>
	<div class="slides-container"></div>
	<div class="overlay"></div>

	<script>
		this.images = [
			'http://31.media.tumblr.com/939ae0a9d6c59bb8305c1e9f5a762156/tumblr_n8fq4mEa6O1rsc32po1_1280.jpg',
			'https://i.ytimg.com/vi/RlNhD0oS5pk/maxresdefault.jpg',
			'https://cbsradionews.files.wordpress.com/2014/12/2233999.jpg?w=1500',
            'http://pre08.deviantart.net/9ec9/th/pre/f/2011/257/0/4/kurt_cobain_playing_the_guitar_by_cobain1337-d49tix0.png'
		];
		this.slides = [];
		
		this.init = function() {

			this.slidesContainer = $(this.root).children('.slides-container');

			for (var i=0;i<this.images.length;i++) {

				var image = new Image();
				image.src = this.images[i];

				var element = document.createElement('DIV');
				element.className = 'slide';
				element.id = 'slide'+i;
				element.style.backgroundImage = 'url('+image.src+')';
				if (i===0) {
					element.className += ' visible';
				}

				this.slides.push({
					element: element,
					src: image.src
				});

				this.slidesContainer.append(element);
			}

			this.root.addEventListener('change-slide',function(e){
				this.slidesContainer.children('.visible').removeClass('visible').css('opacity',0);

                if (e.slide % 1 === 0) {
				    $(this.slides[e.slide].element).addClass('visible').css('opacity',1).css('filter','blur(0)');
                } else {
                    var remainder = e.slide - Math.floor(e.slide),
                        blur = Math.abs(Math.abs(parseInt((remainder*10)) - 5) - 5)*1.7+'px';
                    $(this.slides[Math.ceil(e.slide)].element).addClass('visible').css('opacity',remainder).css('filter','blur('+blur+')');
                    $(this.slides[Math.floor(e.slide)].element).addClass('visible').css('opacity',1).css('filter','blur('+blur+')');
                }
			}.bind(this));

		};

		this.on('mount',this.init.bind(this));
	</script>

	<style>
		carousel div.slides-container {
			position: absolute;
			top: 0;
			left: 0;
			height: 100%;
			width: 100%;
		}
		carousel div.slides-container div.slide {
			position: absolute;
			top: 0;
			left: 0;
			height: 100%;
			width: 100%;
			opacity: 0;
			background-size: 100% 100%;
		}
		carousel div.slides-container div.slide.visible {
			opacity: 1;
		}
		carousel div.overlay {
			height: 100%;
			width: 100%;
			position: absolute;
			top: 0;
			left: 0;
            /* Permalink - use to edit and share this gradient: http://colorzilla.com/gradient-editor/#000000+0,000000+100&0+0,0.9+85 */
            background: -moz-linear-gradient(top, rgba(0,0,0,0.5) 0%, rgba(0,0,0,0.9) 80%,  rgba(0,0,0,1) 100%); /* FF3.6-15 */
            background: -webkit-linear-gradient(top, rgba(0,0,0,0.5) 0%, rgba(0,0,0,0.9) 80%, rgba(0,0,0,1) 100%); /* Chrome10-25,Safari5.1-6 */
            background: linear-gradient(to bottom, rgba(0,0,0,0.5) 0%, rgba(0,0,0,0.9) 80%, rgba(0,0,0,1) 100%); /* W3C, IE10+, FF16+, Chrome26+, Opera12+, Safari7+ */
            filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#00000000', endColorstr='#e6000000',GradientType=0 ); /* IE6-9 */
		}
	</style>
</carousel>
