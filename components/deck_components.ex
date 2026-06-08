defmodule UserlandWeb.DeckComponents do
  @moduledoc """
  Deck UI chrome — reusable cyberpunk-terminal primitives.

  Token-driven (see `assets/css/deck.css`, scoped under `.dk`). These are the
  shared building blocks for the deck screens: the CRT shell, segmented header
  bar, bracketed section labels, option tiles, tier buttons, read panels, and
  the status footer. Structure/content is original userland/Mindscape.
  """
  use Phoenix.Component

  @doc "Full-screen CRT deck shell (scanlines + vignette). Wrap a screen in this."
  attr :class, :string, default: ""
  slot :inner_block, required: true

  def deck_screen(assigns) do
    ~H"""
    <div class={["dk dk-scan min-h-screen px-4 py-3 md:px-6 md:py-4", @class]}>
      {render_slot(@inner_block)}
    </div>
    """
  end

  @doc "Top segmented header bar. Pass `:cell` slots; one may be `grow`."
  slot :cell, required: true do
    attr :grow, :boolean
  end

  def deck_bar(assigns) do
    ~H"""
    <div class="dk-bar">
      <div :for={c <- @cell} class={["dk-bar__cell", c[:grow] && "dk-bar__cell--grow"]}>
        {render_slot(c)}
      </div>
    </div>
    """
  end

  @doc "Bracketed section label: a `[A]` chip + an uppercase caption."
  attr :chip, :string, required: true
  attr :label, :string, required: true

  def deck_section_label(assigns) do
    ~H"""
    <div class="dk-seclabel">
      <span class="dk-seclabel__chip">{@chip}</span>
      <span class="dk-seclabel__text">{@label}</span>
    </div>
    """
  end

  @doc "Square option tile with a footer code row. `active` inverts it to the bright fill."
  attr :title, :string, required: true
  attr :code, :string, default: ""
  attr :sub, :string, default: ""
  attr :active, :boolean, default: false
  attr :rest, :global, include: ~w(phx-click phx-value-id navigate href)

  def deck_tile(assigns) do
    ~H"""
    <div class={["dk-tile", @active && "dk-tile--active"]} {@rest}>
      <div class="dk-tile__title">{@title}</div>
      <div :if={@code != "" or @sub != ""} class="dk-tile__foot">
        <div class="dk-mono">{@code}</div>
        <div>{@sub}</div>
      </div>
    </div>
    """
  end

  @doc "Tier button (T1..T4). `active` inverts it."
  attr :label, :string, required: true
  attr :active, :boolean, default: false
  attr :rest, :global, include: ~w(phx-click phx-value-id)

  def deck_tier(assigns) do
    ~H"""
    <button type="button" class={["dk-tier", @active && "dk-tier--active"]} {@rest}>
      {@label}
    </button>
    """
  end

  @doc "Message / read panel: title header + body slot."
  attr :title, :string, required: true
  attr :class, :string, default: ""
  slot :inner_block, required: true

  def deck_message(assigns) do
    ~H"""
    <div class={["dk-msg", @class]}>
      <div class="dk-msg__head">{@title}</div>
      <div class="dk-msg__body">{render_slot(@inner_block)}</div>
    </div>
    """
  end

  @doc "Bottom status bar with left/center/right slots."
  slot :left
  slot :center
  slot :right

  def deck_footbar(assigns) do
    ~H"""
    <div class="dk-footbar">
      <span>{render_slot(@left)}</span>
      <span>{render_slot(@center)}</span>
      <span>{render_slot(@right)}</span>
    </div>
    """
  end
end
