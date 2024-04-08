defmodule InsiderTrading.Helpers.Common do
  @moduledoc """
  This is for Common Helpers Methods
  """
  import Ecto.Query, warn: false

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

  def add_offset_query(query, page, per_page) when is_nil(page) or is_nil(per_page) do
    query
  end

  def add_offset_query(query, page, per_page) do
    query
    |> offset(^((page - 1) * per_page))
  end

  def add_limit_query(query, per_page) when is_nil(per_page) do
    query
  end

  def add_limit_query(query, per_page) do
    query
    |> limit(^per_page)
  end

  def add_order_by(query, "", _direction) do
    query |> add_order_by("id", "asc")
  end

  def add_order_by(query, field, direction) do
    query
    |> order_by([q], [
      {^String.to_atom(direction), field(q, ^String.to_atom(field))}
    ])
  end
end
