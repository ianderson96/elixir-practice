defmodule Practice.Factor do
  def factor(x) do
    cond do
      is_number(x) ->
        factor(x, [], 3)

      true ->
        num = String.to_integer(x)
        factor(num, [], 3)
    end
  end

  def factor(num, acc, count) when count <= num / 2 or num == 4 do
    x = round(num)

    cond do
      rem(x, 2) == 0 ->
        factor(x / 2, acc ++ [2], count)

      true ->
        if rem(x, count) == 0 do
          factor(x / count, acc ++ [count], 3)
        else
          factor(x, acc, count + 2)
        end
    end
  end

  def factor(x, acc, count) when count > x / 2 do
    acc ++ [round(x)]
  end
end
