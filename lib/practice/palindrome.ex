defmodule Practice.Palindrome do
  def palindrome?(s) do
    string = remove_middle(String.downcase(s))
    length = String.length(string)
    half1 = String.slice(string, 0, floor(length / 2))
    half2 = String.slice(string, floor(length / 2), length - 1)
    half2rev = String.reverse(half2)
    half1 == half2rev
  end

  def remove_middle(s) do
    len = String.length(s)

    if rem(len, 2) != 0 do
      half1 = String.slice(s, 0, floor(len / 2))
      half2 = String.slice(s, floor(len / 2) + 1, len - 1)
      half1 <> half2
    else
      s
    end
  end
end
