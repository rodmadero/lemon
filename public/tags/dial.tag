<dial>

    <div class="logo-container">
        <div class="logo" />
    </div>
    <div class="dial-container" />

    <script>
        this.on('mount',function(){
            this.dialContainer = $(this.root).children('.dial-container');
            this.perimeter = [];
            this.dragging = false;
            this.currentPosition = 0;
			this.autoRotating = false;

            this.buildPerimeter();
            this.initListeners();

        });

        this.initListeners = function(){
            var h_x,h_y,
                o_x,o_y,
                s_x,s_y,s_rad,
                last_angle;
            this.dialContainer.on('mousedown touchstart',function(e){
                h_x = e.pageX || e.originalEvent.touches[0].pageX;
                h_y = e.pageY || e.originalEvent.touches[0].pageY;
                e.preventDefault();
                e.stopPropagation();
                this.dragging = true;

                if (!this.rotationOrigin) this.setOrigin();

                clearInterval(this.interval);

                o_x = this.rotationOrigin.left;
                o_y = this.rotationOrigin.top; // origin point
                
                last_angle = this.dialContainer.data("last_angle") || 0;
                $(document.body).on('mousemove touchmove',function(e){
                   if(this.dragging){
                        s_x = e.pageX || e.originalEvent.touches[0].pageX;
                        s_y = e.pageY || e.originalEvent.touches[0].pageY; // start rotate point
                        if(s_x !== o_x && s_y !== o_y){ // start rotate
                            s_rad = Math.atan2(s_y - o_y, s_x - o_x); // current to origin
                            s_rad -= Math.atan2(h_y - o_y, h_x - o_x); // handle to origin
                            var degree = this.tameDegree(this.getDegree(s_rad) + last_angle);
                            this.rotate(degree);
                        }
                    } 
                }.bind(this));
            }.bind(this));
            $(document.body).on('mouseup touchend',function(e){
                if ( this.dragging ) {
                    this.dragging = false;
                    this.toNearestNotch(this.currentPosition,90);
                }
                $(document.body).off('mousemove touchmove');
            }.bind(this));
        }

        this.setOrigin = function() {
            this.rotationOrigin = {
                left: this.dialContainer.offset().left + this.dialContainer.outerWidth()/2, 
                top: this.dialContainer.offset().top + this.dialContainer.outerHeight()/2
            };
        };

        this.rotate = function(degree) {

            if (degree < -270) {
                if (this.autoRotating) {
					this.autoRotate.stop();
				}
				if (this.currentPosition < -135) { 
					degree = -270;
				} else {
					degree = 0;
				}
            }

			if (Math.abs(degree - this.currentPosition) > 90) return;

            this.dialContainer.css('transform','rotate('+degree+'deg)')
                .css('transform-origin','rotate('+degree+'deg)')
                .css('-moz-transform', 'rotate(' + degree + 'deg)')
                .css('-moz-transform-origin', '50% 50%')
                .css('-webkit-transform', 'rotate(' + degree + 'deg)')
                .css('-webkit-transform-origin', '50% 50%')
                .css('-o-transform', 'rotate(' + degree + 'deg)')
                .css('-o-transform-origin', '50% 50%')
                .css('-ms-transform', 'rotate(' + degree + 'deg)')
                .css('-ms-transform-origin', '50% 50%');

            for (var i=0;i<this.perimeter.length;i++) {
                if (Math.abs(Math.round(degree) + Math.round(this.perimeter[i].deg)) < 2) {
                    $(this.perimeter[i].notch).addClass('highlight');
                    $(this.perimeter[i].dot).addClass('highlight');
                } else {
                    $(this.perimeter[i].notch).removeClass('highlight');
                    $(this.perimeter[i].dot).removeClass('highlight');
                }
            }

            this.currentPosition = degree;

            this.signalSlideChange((degree/90)*-1);
        };

        this.setTransition = function(transition) {
            this.dialContainer.css('transition',transition);
        };

        this.toNearestNotch = function(degree,factor) {
            var nearest = Math.round(degree / factor) * factor;
            this.dialContainer.data('last_angle',nearest);
            this.autoRotate.start(nearest);
        };

        this.autoRotate = {
				start: function(deg){

					var direction = (deg > this.currentPosition) ? 1 : -1;
					this.autoRotating = true;

					this.interval = setInterval(function(){
						if (this.currentPosition !== deg) {
							this.rotate(Math.floor(this.currentPosition+direction));
						} else {
							this.autoRotate.stop();
						}
					}.bind(this),15);

				}.bind(this),
				stop: function() {
					this.autoRotating = false;
					clearInterval(this.interval);
				}
		};

        this.signalSlideChange = function(slide) {
            var event = new Event('change-slide');
			event.slide = slide;
			$(this.root).parent().children('carousel')[0].dispatchEvent(event);
        };

        this.getDegree = function(rad) {
            var degree = Math.round((rad * (360 / (2 * Math.PI))));
            return degree;
        };

        this.tameDegree = function (deg) {
            while (deg > 0) deg -= 360;
            while (deg <= -360) deg += 360;
            return deg;
        };
                
        this.buildPerimeter = function(){
            for (var i=0;i<360;i+=3){
                if (i<=90 || i>=180) {
                    var notch = document.createElement('DIV'),
                        dot = document.createElement('DIV');

                    notch.className = 'perimeter notch';
                    dot.className = 'perimeter dot';

                    if (i === 180) { 
                        notch.className += ' long highlight';
                        dot.className += ' highlight';
                    }

                    if (i % 90 === 0) {
                        notch.className += ' long';
                    }

                    notch.style.transform = 'rotate('+i+'deg) translate(150px)';
                    dot.style.transform = 'rotate('+i+'deg) translate(130px)';               
                    
                    this.dialContainer.append(notch);
                    this.dialContainer.append(dot);

                    var deg = i+180;
                    if (deg >= 360) deg -= 360;
                    this.perimeter.push({
                        notch: notch,
                        dot: dot,
                        deg: deg
                    });
                }
            }
            this.perimeter = this.perimeter.sort(function(a,b){
                return a.deg - b.deg;
            });
        }
    </script>

    <style>
        dial div.dial-container {
            position: absolute;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
            width: 500px;
            height: 500px;
            border-radius: 50%;
            margin: auto;
        }

        dial div.dial-container div.perimeter {
            display: block;
            overflow: hidden;
            position: absolute;
            top: 50%; left: 50%;
            background-color: #878787;
            transform-origin: left center;
        }
        dial div.dial-container div.perimeter.notch {
            width: 15px;
            height: 2px;
        }
        dial div.dial-container div.perimeter.dot {
            width: 4px;
            height: 4px;
            border-radius: 5px;
        }
        dial div.dial-container div.perimeter.highlight {
            background-color: #FFF;
        }
        dial div.dial-container div.perimeter.notch.long {
            width: 20px;
        }
        dial div.logo-container {
            position: absolute;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
            width: 24em;
            height: 24em;
            padding: 2.8em;
            border-radius: 50%;
            margin: auto;  
        }
        dial div.logo-container div.logo {
            margin: 0 auto;
            height: 155px;
            width: 100px;
            background-repeat: no-repeat;
            background-size: 100% auto;
        }
    </style>

</dial>
