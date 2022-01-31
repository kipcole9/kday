defmodule KdayTest do
  use ExUnit.Case

  doctest Kday

  test "nth kday for k-day == day of date" do
    assert Kday.nth_kday(~D[2022-01-01], 1, 5) == ~D[2022-01-07]
    assert Kday.nth_kday(~D[2022-01-01], -1, 5) == ~D[2021-12-31]
  end
end
