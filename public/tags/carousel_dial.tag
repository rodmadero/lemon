<carousel-dial>

    <div class="logo-container">
        <div class="logo" />
        <div class="tagline">
            TRANSPORTIVE VR EXPERIENCES
        </div>
    </div>
    <div class="dial-container" />
    <div class="highlight-container">
        <div class="highlight notch" />
        <div class="highlight dot" />
    </div>

    <script>
        this.on('mount',function(){
            this.dialContainer = $(this.root).children('.dial-container');
            this.logoContainer = $(this.root).children('.logo-container');
            this.perimeter = [];
            this.dragging = false;
            this.currentPosition = 0;
            this.notchFactor = 90;
			this.autoRotating = false;
            this.sizes = {
                large: {
                    notchRadius: 220,
                    dotRadius: 200 
                },
                medium: {
                    notchRadius: 150,
                    dotRadius: 135
                },
                small: {
                    notchRadius: 100,
                    dotRadius: 90
                }
            };
            this.size = this.getSize();
            this.buildDial();

            $(window).on('resize',function(){
                var newSize = this.getSize();
                if (newSize !== this.size) {
                    this.size = newSize;
                    this.buildDial();
                }
                this.setOrigin();
            }.bind(this));

            this.initListeners();

            this.inactivityCount = 0;
            this.startInactivity();

            this.mixin('event-bus');
        });

        this.startInactivity = function(){
            setInterval(function(){
                this.inactivityCount++;
                if (this.inactivityCount > 10) {
                    this.autoRotate.start(this.nextNotch());
                    this.inactivityCount = 0;
                }
            }.bind(this),1000);
        };

        this.getSize = function() {
            var size;
            if (window.innerWidth >= 1440) {
                size = 'large';
            } else if (window.innerWidth < 1440 && window.innerWidth >= 768) {
                size = 'medium';
            } else {
                size = 'small';
            }
            return size;
        };

        this.initListeners = function(){
            var h_x,h_y,
                o_x,o_y,
                s_x,s_y,s_rad,
                last_angle;
            this.dialContainer.on('mousedown touchstart',function(e){
				console.log('touch');
                h_x = e.pageX || e.originalEvent.touches[0].pageX;
                h_y = e.pageY || e.originalEvent.touches[0].pageY;
                e.preventDefault();
                e.stopPropagation();

                if (!this.rotationOrigin) this.setOrigin();

                clearInterval(this.interval);

                o_x = this.rotationOrigin.left;
                o_y = this.rotationOrigin.top; // origin point
                
                last_angle = this.dialContainer.data("last_angle") || 0;
                $(document.body).on('mousemove touchmove',function(e){
                    this.dragging = true;
                    s_x = e.pageX || e.originalEvent.touches[0].pageX;
                    s_y = e.pageY || e.originalEvent.touches[0].pageY; // start rotate point
                    if(s_x !== o_x && s_y !== o_y){ // start rotate
                        s_rad = Math.atan2(s_y - o_y, s_x - o_x); // current to origin
                        s_rad -= Math.atan2(h_y - o_y, h_x - o_x); // handle to origin
                        var degree = this.tameDegree(this.getDegree(s_rad) + last_angle);
                        this.rotate(degree);
                    }
                }.bind(this));
            }.bind(this));
            $(document.body).on('mouseup touchend',function(e){
                if ( this.dragging ) {
                    this.dragging = false; 
                    this.autoRotate.start(this.nearestNotch());
                } else {
                    if (e.target.className.indexOf('long') !== -1) {
                        this.autoRotate.start($(e.target).data('degree'));
                    }
                    e.preventDefault();
                    e.stopPropagation();
                }
                $(document.body).off('mousemove touchmove');
            }.bind(this));
            $(document.body).on('keydown',function(e){
                if (this.autoRotating) return;
                if (e.which === 37) this.autoRotate.start(this.previousNotch());
                if (e.which === 39) this.autoRotate.start(this.nextNotch());
            }.bind(this));
        }

        this.setOrigin = function() {
            this.rotationOrigin = {
                left: this.dialContainer.offset().left + this.dialContainer.outerWidth()/2, 
                top: this.dialContainer.offset().top + this.dialContainer.outerHeight()/2
            };
            //this.markOrigin();
        };

        this.markOrigin = function(){
            $('#origin-marker').remove();
            var originMarker = document.createElement('div');
            originMarker.style.position = 'absolute';
            originMarker.style.top = this.rotationOrigin.top+'px';
            originMarker.style.left = this.rotationOrigin.left+'px';
            originMarker.style.backgroundColor = 'red';
            originMarker.style.height = '5px';
            originMarker.style.width = '5px';
            originMarker.id = 'origin-marker';
            $(document.body).append(originMarker);
        };

        this.rotate = function(degree) {

            this.inactivityCount = 0;

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

            this.currentPosition = degree;

            this.events.carousel.trigger('change-slide',(degree/this.notchFactor)*-1);
        };

        this.nearestNotch = function() {
            return Math.round(this.currentPosition / this.notchFactor) * this.notchFactor;
        };

        this.nextNotch = function() {
            var next = (Math.round(this.currentPosition / this.notchFactor) * this.notchFactor) - this.notchFactor;
            if (next < -270) next = 0;
            return next;
        };

        this.previousNotch = function(){
            var prev = (Math.round(this.currentPosition / this.notchFactor) * this.notchFactor) + this.notchFactor;
            if (prev > 0) prev = -270;
            return prev;
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
            }.bind(this)
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
                
        this.buildDial = function() {
            if (this.perimeter.length > 0) {
                $('.perimeter').remove();
                this.perimeter = [];
            }
            for (var i=0;i<360;i+=3){
                if (i<=90 || i>=180) {
                    var notch = document.createElement('DIV'),
                        dot = document.createElement('DIV');

                    notch.className = 'perimeter notch';
                    dot.className = 'perimeter dot';

                    var deg = i+180;
                    if (deg >= 360) deg -= 360;

                    if (i % 90 === 0) {
                        notch.className += ' long';
                        $(notch).data('degree',deg*-1);
                        dot.className += ' big';
                    }

                    notch.style.transform = 'rotate('+i+'deg) translate('+this.sizes[this.size].notchRadius+'px)';
                    dot.style.transform = 'rotate('+i+'deg) translate('+this.sizes[this.size].dotRadius+'px)';

                    this.dialContainer.append(notch);
                    this.dialContainer.append(dot);

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
            this.logoContainer.removeClass('medium').removeClass('small');
            $('.highlight').removeClass('medium').removeClass('small'); 
            if (this.size !== 'large') {
                this.logoContainer.addClass(this.size);
                $('.highlight').addClass(this.size);
            }
        }
    </script>

    <style>
        carousel-dial {
            position: absolute;
            left: 0;
            right: 0;
            top: -10%;
            bottom: 0;
        }
        @media (max-height: 775px) {
            carousel-dial {
                top: 0;
            }
        }
        @media (max-height: 500px) {
            carousel-dial {
                top: 10px;
            }
        }
        carousel-dial div.dial-container {
            position: absolute;
            left: 0;
            right: 0;
            top: 0;
            bottom: 0;
        }

        carousel-dial div.dial-container div.perimeter {
            display: block;
            overflow: hidden;
            position: absolute;
            top: 50%; left: 50%;
            background-color: #FFF;
            opacity: 0.45;
            transform-origin: left center;
        }

        carousel-dial div.dial-container div.perimeter.notch {
            width: 15px;
            height: 3px;
        }

        carousel-dial div.dial-container div.perimeter.notch.long {
            width: 20px;
            cursor: pointer;
        }

        carousel-dial div.dial-container div.perimeter.notch.long:hover, 
		carousel-dial div.dial-container div.perimeter.notch.long:hover + div.perimeter.dot {
            opacity: 1;
        }

        carousel-dial div.dial-container div.perimeter.dot {
            width: 2px;
            height: 2px;
            border-radius: 100px;
        }

        carousel-dial div.dial-container div.perimeter.dot.big {
            width: 4px;
            height: 4px;
        }

        carousel-dial div.highlight-container {
            position: absolute;
            top: 50%;
            left: 50%;
        }

        carousel-dial div.highlight-container div.highlight {
            display: block;
            overflow: hidden;
            position: relative;
            top: 50%; left: 0;
            background-color: #FFF;
            transform-origin: left center;
            opacity: 1;
        }

        carousel-dial div.highlight-container div.notch.highlight {
            height: 5px;
            width: 21px;
            transform: rotate(180.5deg) translate(220px);
            float: left;
        }

        carousel-dial div.highlight-container div.dot.highlight {
            width: 8px;
            height: 8px;
            border-radius: 100px;
            transform: rotate(180.8deg) translate(219px); 
        }

        carousel-dial div.highlight-container div.notch.highlight.medium {
            transform: rotate(180.5deg) translate(150px);
        }

        carousel-dial div.highlight-container div.dot.highlight.medium {
            transform: rotate(181deg) translate(132px);
        }

        carousel-dial div.highlight-container div.notch.highlight.small {
            transform: rotate(180.7deg) translate(100px);
        }

        carousel-dial div.highlight-container div.dot.highlight.small {
            transform: rotate(181.5deg) translate(88px);
        }

        carousel-dial div.logo-container {
            position: absolute;
            left: 0;
            right: 0;
            top: 10px;
            bottom: 0;
            width: 430px;
            height: 200px;
            margin: auto;
        }
        carousel-dial div.logo-container.medium {
            width: 140px;
            padding-top: 70px;
        }
        carousel-dial div.logo-container.small {
            width: 140px;
            padding-top: 80px;
        }
        carousel-dial div.logo-container div.logo {
            margin: 0 auto;
            height: 101px;
            width: 80%;
            background-repeat: no-repeat;
            background-size: 100% auto;
            background-position: bottom center;
            background-image: url(/img/logo_long.svg);
        }
        carousel-dial div.logo-container.medium div.logo, carousel-dial div.logo-container.small div.logo {
            display: none;
        }
        carousel-dial div.logo-container div.tagline {
            text-align: center;
            color: #cacaca;
            padding-top: 10px;
            font-size: 16px; 
        }
        carousel-dial div.logo-container.small div.tagline {
            font-size: 10px;
        }
    </style>

</carousel-dial>
