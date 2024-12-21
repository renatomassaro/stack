defmodule Stack do
  @moduledoc "README.md"
             |> File.read!()
             |> String.split("<!-- MDOC !-->")
             |> Enum.at(1)

  @enforce_keys [:entries]
  defstruct [:entries]

  @type t(value_type) :: %__MODULE__{entries: [value_type]}
  @typep generic_stack :: t(v)
  @typep v :: term

  @spec new() :: generic_stack
  def new, do: %__MODULE__{entries: []}

  @spec from_list([v]) :: generic_stack
  def from_list(entries),
    do: %__MODULE__{entries: Enum.reverse(entries)}

  @spec to_list(generic_stack) :: [v]
  def to_list(%__MODULE__{entries: entries}), do: Enum.reverse(entries)

  @spec push(generic_stack, v) :: generic_stack
  def push(%__MODULE__{entries: entries}, entry), do: %__MODULE__{entries: [entry | entries]}

  @spec pop(generic_stack) ::
          {:ok, {generic_stack, v}}
          | {:error, :empty}
  def pop(%__MODULE__{entries: []}), do: {:error, :empty}
  def pop(%__MODULE__{entries: [entry | rest]}), do: {:ok, {%__MODULE__{entries: rest}, entry}}

  @spec pop!(generic_stack) ::
          {generic_stack, v}
          | no_return
  def pop!(stack) do
    {:ok, result} = pop(stack)
    result
  end

  @spec peek(generic_stack) ::
          {:ok, v}
          | {:error, :empty}
  def peek(%__MODULE__{entries: []}), do: {:error, :empty}
  def peek(%__MODULE__{entries: [entry | _]}), do: {:ok, entry}

  @spec peek!(generic_stack) ::
          v
          | no_return
  def peek!(stack) do
    {:ok, v} = peek(stack)
    v
  end

  @spec head(generic_stack) ::
          {:ok, v}
          | {:error, :empty}
  def head(%__MODULE__{entries: []}), do: {:error, :empty}
  def head(%__MODULE__{entries: entries}), do: {:ok, entries |> Enum.reverse() |> List.first()}

  @spec head!(generic_stack) ::
          v
          | no_return
  def head!(stack) do
    {:ok, v} = head(stack)
    v
  end

  @spec empty?(generic_stack) :: boolean
  def empty?(%__MODULE__{entries: []}), do: true
  def empty?(%__MODULE__{entries: _}), do: false

  @spec find(generic_stack, (v -> boolean) | v) ::
          v | nil
  def find(%__MODULE__{entries: entries}, finder_fn) when is_function(finder_fn) do
    entries
    |> Enum.reduce_while(nil, fn entry, acc ->
      if finder_fn.(entry) do
        {:halt, entry}
      else
        {:cont, acc}
      end
    end)
  end

  def find(%__MODULE__{} = stack, entry_to_find), do: find(stack, &(&1 == entry_to_find))

  @spec any?(generic_stack, (v -> boolean) | v) :: boolean
  def any?(stack, function_or_entry_to_find),
    do: not is_nil(find(stack, function_or_entry_to_find))

  @spec size(generic_stack) :: integer
  def size(%__MODULE__{entries: entries}), do: length(entries)

  @spec remove(generic_stack, (v -> boolean) | v) ::
          {:ok, {generic_stack, v}}
          | {:error, :not_found}
  def remove(%__MODULE__{entries: entries}, remover_fn) when is_function(remover_fn) do
    entries
    |> Enum.reduce_while({entries, nil}, fn entry, {acc_entries, _} = acc ->
      if remover_fn.(entry) do
        {:halt, {List.delete(acc_entries, entry), {:ok, entry}}}
      else
        {:cont, acc}
      end
    end)
    |> case do
      {new_entries, {:ok, entry}} ->
        {:ok, {%__MODULE__{entries: new_entries}, entry}}

      {_, nil} ->
        {:error, :not_found}
    end
  end

  def remove(%__MODULE__{} = stack, entry_to_remove), do: remove(stack, &(&1 == entry_to_remove))

  @spec remove!(generic_stack, (v -> boolean) | v) ::
          {generic_stack, v}
          | no_return
  def remove!(%__MODULE__{} = stack, function_or_entry_to_find) do
    {:ok, result} = remove(stack, function_or_entry_to_find)
    result
  end

  @spec reduce(generic_stack, (v, acc :: term -> acc :: term), initial_value :: term) ::
          generic_stack
  def reduce(%__MODULE__{entries: entries}, reducer, initial_value) do
    Enum.reduce(entries, initial_value, fn entry, acc -> reducer.(entry, acc) end)
  end

  @spec map(generic_stack, (v -> v)) ::
          generic_stack
  def map(%__MODULE__{entries: entries}, mapper) do
    %__MODULE__{entries: Enum.map(entries, mapper)}
  end

  @spec filter(generic_stack, (v -> boolean)) ::
          generic_stack
  def filter(%__MODULE__{entries: entries}, filter_fn) when is_function(filter_fn) do
    %__MODULE__{entries: Enum.filter(entries, filter_fn)}
  end

  @spec reject(generic_stack, (v -> boolean)) ::
          generic_stack
  def reject(%__MODULE__{entries: entries}, reject_fn) when is_function(reject_fn) do
    %__MODULE__{entries: Enum.reject(entries, reject_fn)}
  end
end
