defmodule TesseraxLive do
  @moduledoc """
  Creates a canvas component with functionality to read the image drawn in the canvas via Tesseract.
  """
  use Phoenix.LiveComponent
  alias TesseraxLive.CanvasComponent
  alias Phoenix.LiveView

  @js_reset_event "reset-canvas"
  @js_read_event "read-image"

  @doc """
  Sends an update to Tesserax LiveComponent by ID and with parameters for setting Tesserax command.

  ## Examples

      tesserax_canvas_id = "tesserax-canvas"
      opts = [
        languages: "eng", 
        tessdata: "path/to/tessdata", 
        config: "path/to/config", 
        psm: 3, 
        oem: 3
      ]
      TesseraxLive.set_opts(tesserax_canvas_id, opts)
  """
  @spec set_opts(id :: String.t(), opts :: keyword()) :: :ok
  def set_opts(id, opts) do
    LiveView.send_update(TesseraxLive, id: id, action: {:set_opts, opts})
    :ok
  end

  @doc """
  Sends an update telling the LiveComponent to read the currently drawn image in the canvas via Tesseract OCR.

  ## Examples

      tesserax_canvas_id = "tesserax_canvas"
      TesseraxLive.read(tesserax_canvas_id)
  """
  @spec read(id :: String.t()) :: :ok
  def read(id) do
    LiveView.send_update(TesseraxLive, id: id, action: :read)
    :ok
  end

  @spec read(id :: String.t(), path :: String.t()) :: :ok
  def read(id, path) do
    LiveView.send_update(TesseraxLive, id: id, action: {:read_path, path})
    :ok
  end

  @doc """
  Sends an update telling the LiveComponent to reset the canvas.

  ## Examples

      tesserax_canvas_id = "tesserax_canvas"
      TesseraxLive.reset(tesserax_canvas_id)
  """
  @spec reset(id :: String.t()) :: :ok
  def reset(id) do
    LiveView.send_update(TesseraxLive, id: id, action: :reset)
    :ok
  end

  @doc false
  @impl Phoenix.LiveComponent
  def mount(socket) do
    socket =
      socket
      |> assign(:tesserax_command, Tesserax.Command.make_command([]))

    {:ok, socket}
  end

  @doc false
  @impl Phoenix.LiveComponent
  def render(assigns) do
    ~H"""
    <div>
      <CanvasComponent.canvas
        id={@id}
        width={@width}
        height={@height}
        line_cap={@line_cap}
        stroke_style={@stroke_style}
        line_width={@line_width}
      />
    </div>
    """
  end

  @doc false
  @impl Phoenix.LiveComponent
  def update(%{action: :reset}, socket) do
    {:ok, LiveView.push_event(socket, @js_reset_event, %{})}
  end

  def update(%{action: :read}, socket) do
    {:ok, LiveView.push_event(socket, @js_read_event, %{})}
  end

  def update(%{action: {:read_path, path}}, socket) do
    socket = socket |> update_tesserax_command(image: path)

    send(self(), {:tesserax_read, Tesserax.read_from_file(socket.assigns.tesserax_command)})
    {:noreply, socket}
  end

  def update(%{action: {:set_opts, opts}}, socket) do
    socket = socket |> update_tesserax_command(opts)

    {:ok, socket}
  end

  def update(%{id: id} = assigns, socket) do
    socket =
      socket
      |> assign(:id, id)
      |> assign(:width, assigns[:width] || CanvasComponent.default_width())
      |> assign(:height, assigns[:height] || CanvasComponent.default_height())
      |> assign(:line_cap, assigns[:line_cap] || CanvasComponent.default_line_cap())
      |> assign(:stroke_style, assigns[:stroke_style] || CanvasComponent.default_stroke_style())
      |> assign(:line_width, assigns[:line_width] || CanvasComponent.default_line_width())

    {:ok, socket}
  end

  @doc false
  @impl Phoenix.LiveComponent
  def handle_event(
        "data-url",
        %{"dataURL" => "data:image/png;base64," <> enc_image_bin},
        socket
      ) do
    decoded_image = Base.decode64!(enc_image_bin)

    socket = socket |> update_tesserax_command(image: decoded_image)

    send(self(), {:tesserax_read, Tesserax.read_from_mem(socket.assigns.tesserax_command)})

    {:noreply, socket}
  end

  defp update_tesserax_command(socket, opts) do
    socket
    |> update(:tesserax_command, &Tesserax.Command.make_command(&1, opts))
  end
end
