<dial>

    <div class="logo-container">
        <div class="logo" />
    </div>
    <div class="dial-container" />

    <script>
        this.on('mount',function(){
            var deg = 0;
            this.dialContainer = $(this.root).children('.dial-container');
            this.perimeter = [];

            this.buildPerimeter();
            this.initListeners();
        });

        this.initListeners = function(){
            var h_x,h_y,
                o_x,o_y,
                s_x,s_y,s_rad,
                dragging=false,
                last_angle;
            this.dialContainer.on('mousedown touchstart',function(e){
                h_x = e.pageX || e.originalEvent.touches[0].pageX;
                h_y = e.pageY || e.originalEvent.touches[0].pageY;
                e.preventDefault();
                e.stopPropagation();
                dragging = true;
                if(!this.dialContainer.data('origin')) this.setOrigin();
                                    
                o_x = this.dialContainer.data('origin').left;
                o_y = this.dialContainer.data('origin').top; // origin point
                
                last_angle = this.dialContainer.data("last_angle") || 0;
                $(document.body).on('mousemove touchmove',function(e){
                   if(dragging){
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
                if ( dragging ) {
                    dragging = false;
                    s_x = e.pageX || e.originalEvent.changedTouches[0].pageX;
                    s_y = e.pageY || e.originalEvent.changedTouches[0].pageY;
                    // save last angle for future iterations
                    s_rad = Math.atan2(s_y - o_y, s_x - o_x); // current to origin
                    s_rad -= Math.atan2(h_y - o_y, h_x - o_x); // handle to origin
                    var degree = this.tameDegree(this.getDegree(s_rad) + last_angle);
                    this.toNearestNotch(degree,90);
                }
                $(document.body).off('mousemove touchmove');
            }.bind(this));
        }

        this.setOrigin = function() {
            this.dialContainer.data('origin',{
                left: this.dialContainer.offset().left + this.dialContainer.outerWidth()/2, 
                top: this.dialContainer.offset().top + this.dialContainer.outerHeight()/2
            });
        };

        this.rotate = function(degree) {

            if (degree <= -270) {
                var currentAngle = this.dialContainer.data('current-angle');
                var closest = [0,-270].reduce(function (prev, curr) {
                    return (Math.abs(curr - currentAngle) < Math.abs(prev - currentAngle) ? curr : prev);
                });
                degree = closest; 
            }

            this.dialContainer.css('transform','rotate('+degree+'deg)')
                .css('transform-origin','rotate('+degree+'deg)')
                .css('-moz-transform', 'rotate(' + degree + 'deg)')
                .css('-moz-transform-origin', '50% 50%')
                .css('-webkit-transform', 'rotate(' + degree + 'deg)')
                .css('-webkit-transform-origin', '50% 50%')
                .css('-o-transform', 'rotate(' + degree + 'deg)')
                .css('-o-transform-origin', '50% 50%')
                .css('-ms-transform', 'rotate(' + degree + 'deg)')
                .css('-ms-transform-origin', '50% 50%')
                .data('current-angle',degree);

            for (var i=0;i<this.perimeter.length;i++) {
                if (Math.abs(Math.round(degree) + Math.round(this.perimeter[i].deg)) < 2) {
                    $(this.perimeter[i].notch).addClass('highlight');
                    $(this.perimeter[i].dot).addClass('highlight');
                } else {
                    $(this.perimeter[i].notch).removeClass('highlight');
                    $(this.perimeter[i].dot).removeClass('highlight');
                }
            }
        };

        this.setTransition = function(transition) {
            this.dialContainer.css('transition',transition);
        };

        this.toNearestNotch = function(degree,factor) {
            var nearest = Math.round(degree / factor) * factor;
            this.dialContainer.data('last_angle',nearest);
            this.autoRotate(nearest);
        }

        this.autoRotate = function(deg){
            this.dialContainer.on('transitionend mousedown touchstart',function(){   
                this.setTransition('none');
            }.bind(this));
            this.setTransition('transform 500ms');
             
            this.rotate(deg);
        };

        this.getDegree = function(rad) {
            var degree = (rad * (360 / (2 * Math.PI)))
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
        dial div.dial-container div.perimeter.notch.long {
            width: 30px;
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
