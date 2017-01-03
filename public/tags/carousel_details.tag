<carousel-details>
    <div class="details-container">
        <img src="/img/ico-psvr.svg" class="details-icon">
        <p class="details-text">360 VR Concert:<br> The Beatles</p>
        <button class="btn details-btn" type="button">VIEW DETAIL</button>
    </div>

	<script>

		this.on('mount',function(){
			this.title = $(this.root).find('.details-text');
			this.mixin('event-bus');
			this.events.carousel.on('change-title',function(title){
				this.title.fadeOut(500);
				setInterval(function(){
					this.title.html(title).fadeIn(500);
				}.bind(this),500);
			}.bind(this));
		});

	</script>

    <style>
        carousel-details div.details-container {
            position: absolute;
            bottom: 0px;
            left: 100px;
            height: 262px;
            width: 400px;
            padding-left: 50px;
            border-left: 3px solid #9c27b0;
        }
		@media(max-width: 1100px) {
			carousel-details div.details-container {
				left: 0;
			}
		}
		@media(max-width: 700px) {
			carousel-details div.details-container {
				padding-left: 10px;
			}
		}
        carousel-details div.details-container img.details-icon{
            height: 48px;
            margin-bottom: 25px;
        }
        carousel-details div.details-container p.details-text {
            font-size: 28px;
            color: #cacaca;
            line-height: 32px;
            margin-bottom: 25px;
        }
		@media (max-width: 900px) {
			carousel-details div.details-container p.details-text{
				font-size: 15px;
				line-height: 25px;
			}
		}
        carousel-details div.details-container button.details-btn {
            background-color: #ff9800;
            height: 50px;
            width: 170px;
            color: #FFF;
        }
    </style>

</carousel-details>
