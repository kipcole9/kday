defmodule Kday do
  @moduledoc """
  Functions to return the date of the first, last or nth day of the week
  on, nearest, before or after a given date.

  """

  @days_in_a_week 7

  @doc """
  Return the date of the `day_of_week` on or before the
  specified `date`.

  ## Arguments

  * `date` is `%Date{}`, a `%DateTime{}`, `%NaiveDateTime{}` or a Rata Die

  * `k` is an integer day of the week.

  ## Returns

  * A `%Date{}` in the calendar of the date provided as an argument

  ## Examples

      iex> Kday.kday_on_or_before(~D[2016-02-29], 2)
      ~D[2016-02-23]

      iex> Kday.kday_on_or_before(~D[2017-11-30], 1)
      ~D[2017-11-27]

      iex> Kday.kday_on_or_before(~D[2017-06-30], 6)
      ~D[2017-06-24]

  """
  @spec kday_on_or_before(Calendar.day() | Date.t(), Calendar.day_of_week()) ::
          Calendar.day() | Date.t()

  def kday_on_or_before(%{year: _, month: _, day: _, calendar: calendar} = date, k)
      when k in 1..@days_in_a_week do
    date
    |> Date.to_gregorian_days
    |> kday_on_or_before(k)
    |> Date.from_gregorian_days(calendar)
  end

  def kday_on_or_before(iso_days, k) when is_integer(iso_days) do
    iso_days - iso_days_to_day_of_week(iso_days - k)
  end

  @doc """
  Return the date of the `day_of_week` on or after the
  specified `date`.

  ## Arguments

  * `date` is `%Date{}`, a `%DateTime{}`, `%NaiveDateTime{}` or a Rata Die

  * `k` is an integer day of the week.

  ## Returns

  * A `%Date{}` in the calendar of the date provided as an argument

  ## Examples

      iex> Kday.kday_on_or_after(~D[2016-02-29], 2)
      ~D[2016-03-01]

      iex> Kday.kday_on_or_after(~D[2017-11-30], 1)
      ~D[2017-12-04]

      iex> Kday.kday_on_or_after(~D[2017-06-30], 6)
      ~D[2017-07-01]

  """
  @spec kday_on_or_after(Calendar.day() | Date.t(), Calendar.day_of_week()) ::
          Calendar.day() | Date.t()

  def kday_on_or_after(%{year: _, month: _, day: _, calendar: calendar} = date, k)
      when k in 1..@days_in_a_week do
    date
    |> Date.to_gregorian_days
    |> kday_on_or_after(k)
    |> Date.from_gregorian_days(calendar)
  end

  def kday_on_or_after(iso_days, k) when is_integer(iso_days) do
    kday_on_or_before(iso_days + @days_in_a_week, k)
  end

  @doc """
  Return the date of the `day_of_week` nearest the
  specified `date`.

  ## Arguments

  * `date` is `%Date{}`, a `%DateTime{}`, `%NaiveDateTime{}` or a Rata Die

  * `k` is an integer day of the week.

  ## Returns

  * A `%Date{}` in the calendar of the date provided as an argument

  ## Examples

      iex> Kday.kday_nearest(~D[2016-02-29], 2)
      ~D[2016-03-01]

      iex> Kday.kday_nearest(~D[2017-11-30], 1)
      ~D[2017-11-27]

      iex> Kday.kday_nearest(~D[2017-06-30], 6)
      ~D[2017-07-01]

  """
  @spec kday_nearest(Calendar.day() | Date.t(), Calendar.day_of_week()) ::
          Calendar.day() | Date.t()

  def kday_nearest(%{year: _, month: _, day: _, calendar: calendar} = date, k)
      when k in 1..@days_in_a_week do
    date
    |> Date.to_gregorian_days
    |> kday_nearest(k)
    |> Date.from_gregorian_days(calendar)
  end

  def kday_nearest(iso_days, k) when is_integer(iso_days) do
    kday_on_or_before(iso_days + 3, k)
  end

  @doc """
  Return the date of the `day_of_week` before the
  specified `date`.

  ## Arguments

  * `date` is `%Date{}`, a `%DateTime{}`, `%NaiveDateTime{}` or a Rata Die

  * `k` is an integer day of the week.

  ## Returns

  * A `%Date{}` in the calendar of the date provided as an argument

  ## Examples

      iex> Kday.kday_before(~D[2016-02-29], 2)
      ~D[2016-02-23]

      iex> Kday.kday_before(~D[2017-11-30], 1)
      ~D[2017-11-27]

      # 6 means Saturday.  Use either the integer value or the atom form.
      iex> Kday.kday_before(~D[2017-06-30], 6)
      ~D[2017-06-24]

  """
  @spec kday_before(Calendar.day() | Date.t(), Calendar.day_of_week()) ::
          Calendar.day() | Date.t()

  def kday_before(%{year: _, month: _, day: _, calendar: calendar} = date, k)
      when k in 1..@days_in_a_week do
    date
    |> Date.to_gregorian_days
    |> kday_before(k)
    |> Date.from_gregorian_days(calendar)
  end

  def kday_before(iso_days, k) do
    kday_on_or_before(iso_days - 1, k)
  end

  @doc """
  Return the date of the `day_of_week` after the
  specified `date`.

  ## Arguments

  * `date` is `%Date{}`, a `%DateTime{}`, `%NaiveDateTime{}` or
    ISO days since epoch.

  * `k` is an integer day of the week.

  ## Returns

  * A `%Date{}` in the calendar of the date provided as an argument

  ## Examples

      iex> Kday.kday_after(~D[2016-02-29], 2)
      ~D[2016-03-01]

      iex> Kday.kday_after(~D[2017-11-30], 1)
      ~D[2017-12-04]

      iex> Kday.kday_after(~D[2017-06-30], 6)
      ~D[2017-07-01]

      iex> Kday.kday_after(~D[2021-03-28], 7)
      ~D[2021-04-04]

  """
  @spec kday_after(Calendar.day() | Date.t(), Calendar.day_of_week()) ::
          Calendar.day() | Date.t()

  def kday_after(%{year: _, month: _, day: _, calendar: calendar} = date, k)
      when k in 1..@days_in_a_week do
    date
    |> Date.to_gregorian_days()
    |> kday_after(k)
    |> Date.from_gregorian_days(calendar)
  end

  def kday_after(iso_days, k) do
    kday_on_or_after(iso_days + 1, k)
  end

  @doc """
  Return the date of the `nth` `day_of_week` on or before/after the
  specified `date`.

  ## Arguments

  * `date` is `%Date{}`, a `%DateTime{}`, `%NaiveDateTime{}` or
    ISO days since epoch.

  * `n` is the cardinal number of `k` before (negative `n`) or after
    (positive `n`) the specified date

  * `k` is an integer day of the week.

  ## Returns

  * A `%Date{}` in the calendar of the date provided as an argument

  ## Examples

      # Thanksgiving in the US
      iex> Kday.nth_kday(~D[2017-11-01], 4, 4)
      ~D[2017-11-23]

      # Labor day in the US
      iex> Kday.nth_kday(~D[2017-09-01], 1, 1)
      ~D[2017-09-04]

      # Daylight savings time starts in the US
      iex> Kday.nth_kday(~D[2017-03-01], 2, 7)
      ~D[2017-03-12]

  """
  @spec nth_kday(Calendar.day() | Date.t(), integer(), Calendar.day_of_week()) ::
          Calendar.day() | Date.t()

  def nth_kday(%{year: _, month: _, day: _, calendar: calendar} = date, n, k)
      when k in 1..@days_in_a_week and is_integer(n) do
    date
    |> Date.to_gregorian_days
    |> nth_kday(n, k)
    |> Date.from_gregorian_days(calendar)
  end

  def nth_kday(iso_days, n, k) when is_integer(iso_days) and n > 0 do
    weeks_to_days(n) + kday_before(iso_days, k)
  end

  def nth_kday(iso_days, n, k) when is_integer(iso_days) do
    weeks_to_days(n) + kday_after(iso_days, k)
  end

  @doc """
  Return the date of the first `day_of_week` on or after the
  specified `date`.

  ## Arguments

  * `date` is `%Date{}`, a `%DateTime{}`, `%NaiveDateTime{}` or
    ISO days since epoch.

  * `k` is an integer day of the week.

  ## Returns

  * A `%Date{”}` in the calendar of the date provided as an argument

  ## Examples

      # US election day
      iex> Kday.first_kday(~D[2017-11-02], 2)
      ~D[2017-11-07]

      # US Daylight savings end
      iex> Kday.first_kday(~D[2017-11-01], 7)
      ~D[2017-11-05]

  """
  @spec first_kday(Calendar.day() | Date.t(), Calendar.day_of_week()) ::
          Calendar.day() | Date.t()

  def first_kday(%{year: _, month: _, day: _, calendar: calendar} = date, k)
      when k in 1..@days_in_a_week do
    date
    |> Date.to_gregorian_days
    |> first_kday(k)
    |> Date.from_gregorian_days(calendar)
  end

  def first_kday(iso_days, k) do
    nth_kday(iso_days, 1, k)
  end

  @doc """
  Return the date of the last `day_of_week` on or before the
  specified `date`.

  ## Arguments

  * `date` is `%Date{}`, a `%DateTime{}`, `%NaiveDateTime{}` or
    ISO days since epoch.

  * `k` is an integer day of the week.

  ## Returns

  * A `%Date{}` in the calendar of the date provided as an argument

  ## Example

      # Memorial Day in the US
      iex> Kday.last_kday(~D[2017-05-31], 1)
      ~D[2017-05-29]

  """
  @spec last_kday(Calendar.day() | Date.t(), Calendar.day_of_week()) ::
          Calendar.day() | Date.t()

  def last_kday(%{year: _, month: _, day: _, calendar: calendar} = date, k)
      when k in 1..@days_in_a_week do
    date
    |> Date.to_gregorian_days
    |> last_kday(k)
    |> Date.from_gregorian_days(calendar)
  end

  def last_kday(iso_days, k) do
    nth_kday(iso_days, -1, k)
  end

  @doc """
  Returns the day of the week for a given
  `iso_day_number`

  ## Arguments

  * `iso_day_number` is the number of days since the start
    of the epoch.

  ## Returns

  * An integer representing a day of the week where Monday
    is represented by `1` and Sunday is represented by `7`

  ## Examples

      iex> days = Date.to_gregorian_days ~D[2019-01-01]
      iex> Kday.iso_days_to_day_of_week(days) == 2
      true

  """
  @spec iso_days_to_day_of_week(integer()) :: Calendar.day_of_week()
  def iso_days_to_day_of_week(iso_day_number) when is_integer(iso_day_number) do
    Integer.mod(iso_day_number + 5, @days_in_a_week) + 1
  end

  @doc """
  Returns the number of days in `n` weeks

  ## Example

      iex> Kday.weeks_to_days(2)
      14

  """
  @spec weeks_to_days(integer) :: integer
  def weeks_to_days(n) do
    n * @days_in_a_week
  end
end
