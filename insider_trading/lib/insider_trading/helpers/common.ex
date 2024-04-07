defmodule InsiderTrading.Helpers.Common do
  @moduledoc """
  This is for Common Helpers Methods
  """

  def get_current_date_time(), do: DateTime.truncate(DateTime.utc_now(), :second)

  def add_timestamps(attrs) when is_map(attrs) do
    timestamp = get_current_date_time()

    attrs
    |> Map.merge(%{inserted_at: timestamp, updated_at: timestamp})
  end

  def text_normalizer(value, replace_character \\ "_")

  def text_normalizer(value, replace_character) when is_bitstring(value) do
    value
    |> String.downcase()
    |> String.replace(~r/[^a-zA-Z0-9]/, replace_character)
  end

  def text_normalizer(value, _), do: value

  def humanize_text(value) when is_bitstring(value) do
    value
    |> String.split("_")
    |> Enum.map_join(" ", &String.capitalize/1)
  end

  def humanize_text(value), do: value
end
