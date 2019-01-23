defmodule Practice.Calc do
  def calc(expr) do
    # This should handle +,-,*,/ with order of operations,
    # but doesn't need to handle parens.
    cond do
      not String.contains?(expr, ["+", "-", "/", "*"]) ->
        String.to_integer(expr)

      true ->
        expr
        |> String.replace(" ", "")
        |> add_delimiter()
        |> String.split(",")
        |> tag_tokens()
        |> Enum.reverse()
        |> convert_to_postfix()
        |> evaluate()
    end
  end

  def add_delimiter(string) do
    string
    |> String.replace("+", ",+,")
    |> String.replace("-", ",-,")
    |> String.replace("*", ",*,")
    |> String.replace("/", ",/,")
  end

  def tag_tokens(tokens) do
    Enum.map(tokens, &tag_token/1)
  end

  def tag_token(token) do
    cond do
      token == "+" ||
        token == "-" ||
        token == "/" ||
          token == "*" ->
        %{type: :op, value: token}

      true ->
        %{type: :num, value: token}
    end
  end

  def get_operator_value("+"), do: 0
  def get_operator_value("-"), do: 0
  def get_operator_value("*"), do: 1
  def get_operator_value("/"), do: 1

  def convert_to_postfix(tokens) do
    convert_to_postfix(tokens, [], [])
  end

  def convert_to_postfix(tokens, acc, stack) do
    cond do
      length(tokens) == 0 ->
        add_stack(acc, stack)

      hd(tokens).type == :num ->
        convert_to_postfix(tl(tokens), acc ++ [hd(tokens)], stack)

      Enum.empty?(stack) ||
          get_operator_value(hd(tokens).value) >
            get_operator_value(hd(make_list(stack)).value) ->
        convert_to_postfix(tl(tokens), acc, make_list(stack) ++ [hd(tokens)])

      true ->
        convert_to_postfix(tl(tokens), acc ++ Enum.reverse(stack), hd(tokens))
    end
  end

  def make_list(stack) when is_list(stack) do
    stack
  end

  def make_list(stack) when not is_list(stack) do
    [stack]
  end

  def add_stack(stack1, stack2) when is_list(stack2) do
    stack1 ++ Enum.reverse(stack2)
  end

  def add_stack(stack1, stack2) when not is_list(stack2) do
    stack1 ++ [stack2]
  end

  def evaluate(stack) when is_list(stack) do
    startNum = get_next_op(stack).num
    evaluate(stack -- [startNum], String.to_integer(startNum.value))
  end

  def evaluate(stack, acc) do
    cond do
      length(stack) == 0 ->
        acc

      true ->
        operation = get_next_op(stack)
        num = operation.num
        op = operation.op
        evaluate((stack -- [num]) -- [op], operate(acc, String.to_integer(num.value), op.value))
    end
  end

  def get_next_op(stack) do
    cond do
      hd(tl(stack)).type == :op -> %{num: hd(stack), op: hd(tl(stack))}
      hd(tl(stack)).type == :num -> get_next_op(tl(stack))
    end
  end

  def operate(x, y, op) when op == "+" do
    x + y
  end

  def operate(x, y, op) when op == "-" do
    x - y
  end

  def operate(x, y, op) when op == "*" do
    x * y
  end

  def operate(x, y, op) when op == "/" do
    x / y
  end
end
