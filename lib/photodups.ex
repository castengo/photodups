defmodule Photodups do
  @moduledoc """
  Documentation for Photodups.
  """

  def scan(dir) do
    result = dir
    |> list_files()
    |> Enum.map(&read_data(&1))
    |> Enum.sort(&(elem(&1, 2) >= elem(&2, 2)))
    |> Enum.chunk_by(fn {_file, date, _width, _height} -> date end)
    |> Enum.map(&remove_dups(&1))

    total_files = list_files(dir) |> Enum.count()
    total_after = result |> Enum.count()
    removed = list_files(dir) -- result
  #   IO.puts "Total files: #{total_files}"
  #   IO.puts "Total duplicates: #{total_files - total_after}"
  #   IO.puts "After dedup files: #{total_after}"
  #   IO.puts "FILES TO BE REMOVED:"
  #   Enum.each(removed, &IO.puts(&1))
  end

  @spec remove_dups([{String.t, String.t, non_neg_integer, non_neg_integer}]) :: String.t
  def remove_dups(list) when length(list) > 1 do
    IO.puts "------"
    list
    # should return true if first element precedes second one
    |> Enum.sort(&((elem(&1, 2) * elem(&1, 3)) >= (elem(&2, 2) * elem(&2, 3))))
    |> IO.inspect
    |> List.first()
    # |> IO.inspect
    |> elem(0)
  end
  def remove_dups([{file, _date, _width, _height}]), do: file

  # def print(list) do
  #   [chosen | others] = list
  #   rejected = Enum.map(others, fn {file, _date, _size} -> file end) |> Enum.join(", ")
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
    case Exexif.exif_from_jpeg_file(path) do
      {:ok, info} -> do_read_data(path, info)
      {:error, _} -> do_read_data(path, nil)
    end
  end

  @spec do_read_data(String.t, map | nil) :: {String.t, non_neg_integer}
  defp do_read_data(file, %{exif: %{datetime_original: date, exif_image_width: width, exif_image_height: height}}), do: {file, date, width, height}
  defp do_read_data(file, _), do: {file, "unknown_#{:rand.uniform(6)}", 1, 1}
end
