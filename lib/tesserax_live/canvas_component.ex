defmodule TesseraxLive.CanvasComponent do
  @moduledoc false
  use Phoenix.Component
  @default_width 400
  @default_height 400
  @default_line_cap "round"
  @default_stroke_style "black"
  @default_line_width 4

  attr(:id, :string, required: true)
  attr(:width, :integer, required: true)
  attr(:height, :integer, required: true)
  attr(:line_cap, :string, required: true)
  attr(:stroke_style, :string, required: true)
  attr(:line_width, :integer, required: true)

  @doc false
  def canvas(assigns) do
    ~H"""
    <canvas
      id={@id}
      width={@width}
      height={@height}
      line_cap={@line_cap}
      stroke_style={@stroke_style}
      line_width={@line_width}
      phx-hook="TesseraxCanvas"
    />
    """
  end

  @doc false
  def default_width, do: @default_width

  @doc false
  def default_height, do: @default_height

  @doc false
  def default_line_cap, do: @default_line_cap

  @doc false
  def default_stroke_style, do: @default_stroke_style

  @doc false
  def default_line_width, do: @default_line_width
end
