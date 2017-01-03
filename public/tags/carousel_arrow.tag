<carousel-arrow>
    <div class="arrow-container">
        <p class="arrow-explore">
            EXPLORE
        </p>
        <img src="/img/ico-scroll-arrow.svg" class="arrow-img">
    </div>

    <style>
        carousel-arrow div.arrow-container {
            position: absolute;
            bottom: 0px;
            right: 100px;
            height: 130px;
            width: 150px;
            text-align: center;
            cursor: pointer;
            opacity: 0.7;
            transition: opacity 500ms;
        }

        carousel-arrow div.arrow-container p.arrow-explore {
            font-size: 14px;
            color: #cacaca;
        }
        carousel-arrow div.arrow-container img.arrow-img {
            width: 41px;
            height: 50px;
            opacity: 0.5;
        }
        carousel-arrow div.arrow-container:hover {
            opacity: 1;
        }
    </style>
</carousel-arrow>
