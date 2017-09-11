defmodule Photodups do
  @moduledoc """
  Documentation for Photodups.
  """

  def report(dir) do
    all_files = list_files(dir)
    final_files = scan(dir)
    total_files = Enum.count all_files
    total_after = Enum.count final_files
    removed = all_files -- final_files
    IO.puts "Total files: #{total_files}"
    IO.puts "Total duplicates: #{total_files - total_after}"
    IO.puts "After dedup files: #{total_after}"
    # IO.puts "FILES TO BE REMOVED:"
    # Enum.each(removed, &IO.puts(&1))
  end

  def scan(dir) do
    dir
    |> list_files()
    |> Enum.map(&read_data(&1))
    |> Enum.sort(&(elem(&1, 1) >= elem(&2, 1)))
    |> IO.inspect()
    |> Enum.chunk_by(fn {_file, date, _width, _height} -> date end)
    |> Enum.map(&remove_dups(&1))
  end

  @spec remove_dups([{String.t, String.t, non_neg_integer, non_neg_integer}]) :: String.t
  def remove_dups(list) when length(list) > 1 do
    list
    |> Enum.sort(&((elem(&1, 2) * elem(&1, 3)) >= (elem(&2, 2) * elem(&2, 3))))
    # |> print()
    |> List.first()
    |> elem(0)
  end
  def remove_dups([{file, _date, _width, _height}]), do: file
  #
  # def print(list) do
  #   [chosen | others] = list
  #   rejected = Enum.map(others, fn {file, _date, _width, _height} -> file end) |> Enum.join(", ")
  #   IO.puts "#{rejected} are duplicates of #{elem(chosen, 0)}"
  #   IO.puts "____________________________________"
  #   list
  # end

  def list_files(dir) do
    path = dir <> "*.{jpg,JPG}"
    Path.wildcard(path)
  end

  @spec read_data(String.t) :: {String.t, non_neg_integer, non_neg_integer}
  def read_data(path) do
    path
    |> Exexif.exif_from_jpeg_file()
    |> case do
      {:ok, info} -> {path, info}
      {:error, _} -> {path, nil}
      things -> {path, things}
    end
    |> get_date()
    |> get_dimensions()
  end

  @spec get_date({String.t, map | nil}) :: {String.t, non_neg_integer}
  defp get_date({file, %{exif: %{datetime_original: date}}}) do
    IO.puts "YES METADATA"
    {file, date}
  end
  defp get_date({file, nil}) do
    IO.puts "file #{file} didn't have metadata"
    {file, "unknown_#{:rand.uniform(100000)}"}
  end
  defp get_date({file, things}) do
    IO.puts "WHAT the hell is this?"
    IO.inspect things
    {file, "unknown_#{:rand.uniform(100000)}"}
  end


  defp get_dimensions({file, date}) do
    {_type, width, height, _info} = ExImageInfo.info File.read!(file)
    {file, date, width, height}
  end
end
