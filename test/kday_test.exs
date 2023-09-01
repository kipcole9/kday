defmodule KdayTest do
  use ExUnit.Case

  doctest Kday

  test "nth kday for k-day == day of date" do
    assert Kday.nth_kday(~D[2022-01-01], 1, 5) == ~D[2022-01-07]
    assert Kday.nth_kday(~D[2022-01-01], -1, 5) == ~D[2021-12-31]
  end

  test "nearby k day" do
    assert Kday.kday_before(~D[2023-09-02], 1) == ~D[2023-08-28]
    assert Kday.kday_before(~D[2023-09-02], 2) == ~D[2023-08-29]
    assert Kday.kday_before(~D[2023-09-02], 3) == ~D[2023-08-30]
    assert Kday.kday_before(~D[2023-09-02], 4) == ~D[2023-08-31]
    assert Kday.kday_before(~D[2023-09-02], 5) == ~D[2023-09-01]
    assert Kday.kday_before(~D[2023-09-02], 6) == ~D[2023-08-26]
    assert Kday.kday_before(~D[2023-09-02], 7) == ~D[2023-08-27]
  end
end
