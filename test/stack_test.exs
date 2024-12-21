defmodule StackTest do
  use ExUnit.Case, async: true

  @empty Stack.new()
  @stack_1 Stack.new() |> Stack.push(1)
  @stack_12 @stack_1 |> Stack.push(2)
  @stack_123 @stack_12 |> Stack.push(3)
  @stack_1234 @stack_123 |> Stack.push(4)

  describe "push/2" do
    test "adds new entries to the stack" do
      stack = Stack.new()
      stack_1 = Stack.push(stack, 1)
      stack_12 = Stack.push(stack_1, 2)
      stack_123 = Stack.push(stack_12, 3)

      assert %Stack{entries: [1]} == stack_1
      assert %Stack{entries: [2, 1]} == stack_12
      assert %Stack{entries: [3, 2, 1]} == stack_123
    end
  end

  describe "pop/2" do
    test "removes the topmost element in the stack" do
      stack =
        Stack.new()
        |> Stack.push(1)
        |> Stack.push(2)
        |> Stack.push(3)

      assert {:ok, {stack, 3}} = Stack.pop(stack)
      assert {:ok, {stack, 2}} = Stack.pop(stack)
      assert {:ok, {stack, 1}} = Stack.pop(stack)
      assert {:error, :empty} = Stack.pop(stack)
    end
  end

  describe "pop!" do
    test "raises if empty" do
      assert {_, 1} = Stack.pop!(@stack_1)
      assert_raise(MatchError, fn -> Stack.pop!(Stack.new()) end)
    end
  end

  describe "peek/1" do
    test "returns the topmost element in the stack" do
      Stack.new()
      |> tap(&assert Stack.peek(&1) == {:error, :empty})
      |> Stack.push(1)
      |> tap(&assert Stack.peek(&1) == {:ok, 1})
      |> Stack.push(2)
      |> tap(&assert Stack.peek(&1) == {:ok, 2})
      |> Stack.push(3)
      |> tap(&assert Stack.peek(&1) == {:ok, 3})
    end
  end

  describe "peek!/1" do
    test "raises if stack is empty" do
      assert 1 == Stack.peek!(@stack_1)
      assert_raise(MatchError, fn -> Stack.peek!(Stack.new()) end)
    end
  end

  describe "empty?/1" do
    test "returns true if empty" do
      assert Stack.empty?(Stack.new())
    end

    test "returns false if not empty" do
      refute Stack.empty?(@stack_1)
    end
  end

  describe "find/1" do
    test "accepts a function" do
      callback = fn v -> v > 2 end

      assert Stack.find(@stack_123, callback)
      refute Stack.find(@stack_12, callback)
      refute Stack.find(@empty, callback)
    end

    test "accepts a value" do
      assert 3 == Stack.find(@stack_123, 3)
      assert 2 == Stack.find(@stack_12, 2)
      assert 1 == Stack.find(@stack_1, 1)
      refute Stack.find(@empty, nil)
    end
  end

  describe "any?/2" do
    test "accepts a function" do
      callback = fn v -> v == 3 end

      assert Stack.any?(@stack_123, callback)
      refute Stack.any?(@stack_12, callback)
      refute Stack.any?(@stack_1, callback)
      refute Stack.any?(@empty, callback)
    end

    test "accepts a value" do
      assert Stack.any?(@stack_123, 2)
      refute Stack.any?(@stack_12, 5)
      refute Stack.any?(@empty, nil)
    end
  end

  describe "to_list/1" do
    test "dumpts the stack into a list" do
      assert Stack.to_list(@empty) == []
      assert Stack.to_list(@stack_1) == [1]
      assert Stack.to_list(@stack_12) == [1, 2]
      assert Stack.to_list(@stack_123) == [1, 2, 3]
    end
  end

  describe "size/1" do
    test "returns the size of the list" do
      assert Stack.size(@empty) == 0
      assert Stack.size(@stack_1) == 1
      assert Stack.size(@stack_12) == 2
      assert Stack.size(@stack_123) == 3
    end
  end

  describe "remove/2" do
    test "removes the entry from the stack preserving the order" do
      assert %Stack{entries: [3, 2, 1]} = @stack_123
      assert {:ok, {%Stack{entries: [2, 1]}, 3}} = Stack.remove(@stack_123, 3)
      assert {:ok, {%Stack{entries: [3, 1]}, 2}} = Stack.remove(@stack_123, 2)
      assert {:ok, {%Stack{entries: [3, 2]}, 1}} = Stack.remove(@stack_123, 1)
    end

    test "accepts a function" do
      assert {:ok, {_, 3}} = Stack.remove(@stack_123, fn v -> v == 3 end)
      assert {:ok, {_, 2}} = Stack.remove(@stack_123, fn v -> v == 2 end)
      assert {:ok, {_, 1}} = Stack.remove(@stack_123, fn v -> v == 1 end)
      assert {:error, :not_found} = Stack.remove(@stack_123, fn v -> v == 0 end)
      assert {:error, :not_found} = Stack.remove(@empty, fn v -> v == 0 end)
    end

    test "accepts a value" do
      assert {:ok, {stack, 3}} = Stack.remove(@stack_123, 3)
      assert {:ok, {stack, 2}} = Stack.remove(stack, 2)
      assert {:ok, {stack, 1}} = Stack.remove(stack, 1)
      assert {:error, :not_found} = Stack.remove(stack, nil)
    end
  end

  describe "remove!/2" do
    test "raises if not found" do
      assert {%Stack{}, 1} = Stack.remove!(@stack_1, 1)
      assert_raise MatchError, fn -> Stack.remove!(@stack_1, 2) end
      assert_raise MatchError, fn -> Stack.remove!(@empty, true) end
    end
  end

  describe "reduce/3" do
    test "reduces the entries" do
      adder = fn v, acc -> v + acc end
      assert 6 == Stack.reduce(@stack_123, adder, 0)
      assert 3 == Stack.reduce(@stack_12, adder, 0)
      assert 1 == Stack.reduce(@stack_1, adder, 0)
      assert 0 == Stack.reduce(@empty, adder, 0)
    end
  end

  describe "map/2" do
    test "maps the values" do
      increment = fn v -> v + 1 end
      assert %Stack{entries: [4, 3, 2]} = Stack.map(@stack_123, increment)
      assert %Stack{entries: [3, 2]} = Stack.map(@stack_12, increment)
      assert %Stack{entries: [2]} = Stack.map(@stack_1, increment)
      assert %Stack{entries: []} = Stack.map(@empty, increment)
    end
  end

  describe "filter/2" do
    test "filters the stack based on the condition" do
      assert %Stack{entries: [3, 1]} = Stack.filter(@stack_1234, fn v -> rem(v, 2) == 1 end)
      assert @stack_123 == Stack.filter(@stack_1234, fn v -> v != 4 end)
      assert @stack_1234 == Stack.filter(@stack_1234, fn v -> v < 5 end)
    end
  end

  describe "reject/2" do
    test "rejects the stack based on the condition" do
      assert %Stack{entries: [4, 2]} = Stack.reject(@stack_1234, fn v -> rem(v, 2) == 1 end)
      assert @stack_123 == Stack.reject(@stack_1234, fn v -> v == 4 end)
      assert @stack_1234 == Stack.reject(@stack_1234, fn v -> v > 5 end)
      assert @empty == Stack.reject(@stack_1234, fn v -> v < 5 end)
    end
  end
end
