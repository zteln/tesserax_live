# TesseraxLive

This package provides a `LiveComponent` to be used with `LiveView` that creates a canvas HTML component. 
Furthermore, this package utilizes `Tesserax`, which uses Tesseract OCR, to recognize the drawn text inside the canvas HTML component. 

## Usage
In `./assets/js/app.js` add
```
...
import { TesseraxCanvas } from "tesserax_live"

let Hooks = {};

Hooks.TesseraxCanvas = TesseraxCanvas;

...
let liveSocket = new LiveSocket("/live", Socket, {
    ...
    hooks: Hooks
})
...
```

In your LiveView HEEx, add the following
```
~H"""
...
<.live_component module={TesseraxLive} id="canvas-ID" />
...
"""
```

Use the interface functions to interact with the canvas component:
- `read/1`: reads the image in the canvas and sends it for recognition with [Tesserax](https://github.com/zteln/tesserax).
- `read/2`: takes a path to an image (e.g. file upload) and uses Tesserax to read the image.
- `set_opts/2`: sets opts in the `%Tesserax.Command{}` struct.
- `reset/1`: resets the canvas component.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `tesserax_live` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:tesserax_live, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/tesserax_live>.

