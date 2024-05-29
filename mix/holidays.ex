defmodule Kday.Holidays do
  # Requires Elixir 1.17

  @holidays [
    {:new_years_day, [:fixed, 1, :January]},
    {:new_years_day_observed, [:nearest_weekday_to, 1, :January]},
    {:martin_luther_king_jr_day, [:third, :monday, :January]},
    {:washingtons_birthday, [:third, :monday, :February]},
    {:good_friday, &Kday.Holidays.compute_good_friday/1},
    {:memorial_day, [:last, :monday, :May]},
    {:juneteenth, [:fixed, 19, :June]},
    {:independence_day, [:fixed, 4, :July]},
    {:independence_day_observed, [:nearest_weekday_to, 4, :July]},
    {:labor_day, [:first, :monday, :September]},
    {:thanksgiving_day, [:fourth, :thursday, :November]},
    {:christmas_day, [:fixed, 25, :December]},
    {:christmas_day_observed, [:nearest_weekday_to, 25, :December]},
    {:easter, &Kday.Holidays.compute_easter/1}
  ]

  @months %{
    January: 1,
    February: 2,
    March: 3,
    April: 4,
    May: 5,
    June: 6,
    July: 7,
    August: 8,
    September: 9,
    October: 10,
    November: 11,
    December: 12
  }

  @weeks %{
    first: 1,
    second: 2,
    third: 3,
    fourth: 4
  }

  @weekdays %{
    monday: 1,
    tuesday: 2,
    wednesday: 3,
    thursday: 4,
    friday: 5,
    saturday: 6,
    sunday: 7
  }

  def nyse_holidays(year) do
    @holidays
    |> Enum.map(fn {holiday, desc} -> {holiday, compute_holiday(year, desc)} end)
    |> Enum.filter(fn {_holiday, date} -> date != nil end)
  end

  def compute_holiday(year, [:fixed, day, month]) do
    Date.new!(year, @months[month], day)
  end

  def compute_holiday(year, [:nearest_weekday_to, day, month]) do
    date = Date.new!(year, @months[month], day)
    adjust_for_weekend(date)
  end

  def compute_holiday(year, [:last, weekday, month]) do
    date = Date.new!(year, @months[month], 30)
    Kday.last_kday(date, @weekdays[weekday])
  end

  def compute_holiday(year, [week, weekday, month]) do
    date = Date.new!(year, @months[month], 1)
    Kday.nth_kday(date, @weeks[week], @weekdays[weekday])
  end

  def compute_holiday(year, special_function) when is_function(special_function) do
    special_function.(year)
  end

  def compute_good_friday(year) do
    easter = compute_easter(year)
    Date.shift(easter, day: -2)
  end

  def compute_easter(year) do
    # Using the Anonymous Gregorian algorithm
    a = rem(year, 19)
    b = div(year, 100)
    c = rem(year, 100)
    d = div(b, 4)
    e = rem(b, 4)
    f = div(b + 8, 25)
    g = div(b - f + 1, 3)
    h = rem(19 * a + b - d - g + 15, 30)
    i = div(c, 4)
    k = rem(c, 4)
    l = rem(32 + 2 * e + 2 * i - h - k, 7)
    m = div(a + 11 * h + 22 * l, 451)
    month = div(h + l - 7 * m + 114, 31)
    day = rem(h + l - 7 * m + 114, 31) + 1

    Date.new!(year, month, day)
  end

  def adjust_for_weekend(date) do
    case Kday.day_of_week(date) do
      6 -> Date.shift(date, day: -1) # If Saturday, shift to Friday
      7 -> Date.shift(date, day: 1)  # If Sunday, shift to Monday
      _ -> date
    end
  end
end