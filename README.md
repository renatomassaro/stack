# Stack

[![Coverage Status](https://coveralls.io/repos/github/renatomassaro/stack/badge.svg?branch=main)](https://coveralls.io/github/renatomassaro/stack?branch=main)

<!-- MDOC !-->

A simple yet complete implementation of a Stack data structure in Elixir.

## Basic usage

```elixir
# You have a stack with three entries, `3` being the topmost item
Stack.new()
|> Stack.push(1)
|> Stack.push(2)
|> Stack.push(3)

# You can pop entries from the stack
{:ok, {stack, 3}} = Stack.pop(stack)
{:ok, {stack, 2}} = Stack.pop(stack)
{:ok, {stack, 1}} = Stack.pop(stack)
{:error, :empty} = Stack.pop(stack)

{_stack, 3} = Stack.pop!(stack)

# You can look at the topmost item without altering the stack
Stack.peek(stack)  # {:ok, 3}
Stack.peek!(stack)  # 3

# You can get the first item of the stack
Stack.head(stack)  # {:ok, 1}
Stack.head!(stack)  # 1

# You can get the size of the stack
Stack.size(stack)  # 3

# You can convert the stack into a list
Stack.to_list(stack)  # [1, 2, 3]
```

## Advanced usage

```elixir
stack = Stack.from_list([1, 2, 3, 4])

# Find the first entry that matches your criteria
Stack.find(stack, fn item -> rem(item, 2) == 0 end)  # 2

# Reduce the entries
Stack.reduce(stack, fn item, acc -> item + acc, 0)  # 10

# Filter (or reject) entries
Stack.filter(stack, fn item -> rem(item, 2) == 0 end) # %Stack{entries: [2, 4]}
Stack.reject(stack, fn item -> rem(item, 2) == 0 end) # %Stack{entries: [1, 3]}

# Remove entries
Stack.remove(stack, fn item -> item <= 2 end)  # %Stack{entries: [3, 4]}
```

## Installation

Just add `stack` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:stack, "~> 1.0"}
  ]
end
```
