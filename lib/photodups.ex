defmodule Photodups do
  @moduledoc """
  Documentation for Photodups.
  """

  def scan(dir) do
    result = dir
    |> list_files()
    |> Enum.map(&add_data(&1))
    |> Enum.sort()
    |> Enum.chunk_by(fn {_file, date, _size} -> date end)
    |> Enum.map(&remove_dups(&1))

    total_files = list_files(dir) |> Enum.count()
    total_after = result |> Enum.count()
    removed = list_files(dir) -- result
    IO.puts "Total files: #{total_files}"
    IO.puts "Total duplicates: #{total_files - total_after}"
    IO.puts "After dedup files: #{total_after}"
    # IO.puts "FILES TO BE REMOVED:"
    # Enum.each(removed, &IO.puts(&1))
  end

  def add_data(file), do: {file, read_date(file), read_size(file)}

  def remove_dups(list) when length(list) > 1 do
    list
    |> Enum.sort(&(elem(&1, 2) >= elem(&2, 2)))
    # |> print()
    |> List.first()
    |> elem(0)
  end
  def remove_dups([{file, _date, _size}]), do: file

  def print(list) do
    [chosen | others] = list
    rejected = Enum.map(others, fn {file, _date, _size} -> file end) |> Enum.join(", ")
    IO.puts "#{rejected} are duplicates of #{elem(chosen, 0)}"
    IO.puts "____________________________________"
    list
  end

  def list_files(dir) do
    path = dir <> "*.{jpg,JPG}"
    Path.wildcard(path)
  end

  def read_date(path) do
    case Exexif.exif_from_jpeg_file(path) do
      {:ok, info} -> do_read_date(info)
      {:error, _} -> :rand.uniform(6)
    end
  end

  defp do_read_date(%{exif: %{datetime_original: date}}), do: date
  defp do_read_date(_), do: nil

  def read_size(path) do
    File.stat!(path)
    |> Map.get(:size)
  end
end
