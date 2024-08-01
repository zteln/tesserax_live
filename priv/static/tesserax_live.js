var TesseraxCanvas = {
    mounted() {
        this.el.style.border = "solid black";
        this.el.style.backgroundColor = "white";
        var positions = { x: 0, y: 0 };
        var ctx = this.el.getContext('2d');
        var line_cap = this.el.getAttribute('line_cap');
        var stroke_style = this.el.getAttribute('stroke_style');
        var line_width = this.el.getAttribute('line_width');
        initialize_context();
        this.el.addEventListener("mousemove", e => {
            if (e.buttons !== 1) return;
            drawPath(e, this.el);
        });
        this.el.addEventListener("mousedown", e => {
            setPosition(e, this.el);
        });
        this.handleEvent("reset-canvas", _e => {
            ctx.reset();
            initialize_context();
        });
        this.handleEvent("read-image", _e => {
            const dataURL = this.el.toDataURL("image/png");
            this.pushEventTo(
                this.el,
                "data-url",
                { dataURL: dataURL },
                (_reply, _ref) => { return; }
            )
        })
        function setPosition(event, canvas) {
            positions.x = event.clientX - canvas.getBoundingClientRect().left;
            positions.y = event.clientY - canvas.getBoundingClientRect().top;
        };
        function drawPath(event, canvas) {
            ctx.beginPath();
            ctx.moveTo(positions.x, positions.y);
            setPosition(event, canvas);
            ctx.lineTo(positions.x, positions.y);
            ctx.stroke();
        };
        function initialize_context() {
            ctx.lineCap = line_cap;
            ctx.strokeStyle = stroke_style;
            ctx.lineWidth = line_width;
        }
    }
}

export { TesseraxCanvas };
