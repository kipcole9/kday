defmodule Kday.HolidaysTest do
  use ExUnit.Case, async: true

  test "NYSE holidays in 2024" do
    holidays = Kday.Holidays.nyse_holidays(2024)

    assert Enum.any?(holidays, fn date -> date == {:new_years_day, ~D[2024-01-01]} end), "New Year's Day"
    assert Enum.any?(holidays, fn date -> date == {:martin_luther_king_jr_day, ~D[2024-01-15]} end), "Martin Luther King Jr. Day"
    assert Enum.any?(holidays, fn date -> date == {:washingtons_birthday, ~D[2024-02-19]} end), "Washington's Birthday"
    assert Enum.any?(holidays, fn date -> date == {:good_friday, ~D[2024-03-29]} end), "Good Friday"
    assert Enum.any?(holidays, fn date -> date == {:memorial_day, ~D[2024-05-27]} end), "Memorial Day"
    assert Enum.any?(holidays, fn date -> date == {:juneteenth, ~D[2024-06-19]} end), "Juneteenth"
    assert Enum.any?(holidays, fn date -> date == {:independence_day, ~D[2024-07-04]} end), "Independence Day"
    assert Enum.any?(holidays, fn date -> date == {:labor_day, ~D[2024-09-02]} end), "Labor Day"
    assert Enum.any?(holidays, fn date -> date == {:thanksgiving_day, ~D[2024-11-28]} end), "Thanksgiving Day"
    assert Enum.any?(holidays, fn date -> date == {:christmas_day, ~D[2024-12-25]} end), "Christmas Day"
  end

end