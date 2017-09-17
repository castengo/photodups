defmodule Photodups do
  @moduledoc """
  Documentation for Photodups.
  """

  def report(dir) do
    all_files = list_files(dir)
    originals = scan(dir)
    total_files = Enum.count all_files
    total_after = Enum.count originals
    duplicates = all_files -- originals
    IO.puts "Total files: #{total_files}"
    IO.puts "Total duplicates: #{total_files - total_after}"
    IO.puts "After dedup files: #{total_after}"
  end

  def scan(dir) do
    dir
    |> list_files()
    # get data if its there, if not mark as :skip
    |> Enum.map(&read_data(&1))
    # reject files that don't have data
    # |> Enum.reject(&(&1 == :skip))
    # sort by date
    |> Enum.sort(&(elem(&1, 1) >= elem(&2, 1)))
    # separate into list of list by date
    |> Enum.chunk_by(fn {_file, date, _width, _height} -> date end)
    # go through each list and pick the original and instagram files with highest rest
    |> Enum.map(&process_chunk(&1))
    |> List.flatten
    # get only the file name
    |> Enum.map(fn {file, _date, _width, _height} -> file end)
  end

  @spec process_chunk([tuple]) :: [String.t]
  def process_chunk(chunk) do
    case List.first(chunk) do
      {_, nil, _, _} -> chunk
      _ -> remove_dups(chunk)
    end
  end

  @spec remove_dups([{String.t, Setring.t, non_neg_integer, non_neg_integer}]) :: [String.t]
  def remove_dups(list) do
    #sort by highest resolution (height * width)
    ordered_list = Enum.sort(list, &((elem(&1, 2) * elem(&1, 3)) >= (elem(&2, 2) * elem(&2, 3))))
    original = Enum.find(ordered_list, [], fn {_file, _date, width, height} ->
      width/height != 1
    end)
    instagram = Enum.find(ordered_list, [], fn {_file, _date, width, height} ->
      width/height == 1
    end)
    # PRINT
    duplicates = (ordered_list -- [original]) -- [instagram]
    print(duplicates, original, instagram)
    # PRINT
    [original, instagram]
  end

  def print(dups, {original, _, _, _}, []) when length(dups) > 0 do
    dups = Enum.map(dups, fn {file,_,_,_} -> Path.basename(file) end) |> Enum.join(", ")
    orig = Path.basename(original)
    IO.puts "**********DUPLICATES*******************"
    IO.puts "#{dups} are duplicates of #{orig}"
    IO.puts "---------------------------------------"
  end
  def print(dups, {original,_,_,_}, {instagram,_,_,_}) when length(dups) > 0 do
    dups = Enum.map(dups, fn {file,_,_,_} -> Path.basename(file) end) |> Enum.join(", ")
    orig = Path.basename(original)
    inst = Path.basename(instagram)
    IO.puts "**********DUPLICATES*******************"
    IO.puts "#{dups} are duplicates of #{orig} and #{inst}"
    IO.puts "---------------------------------------"
  end
  def print(_, _, _), do: nil

  def list_files(dir) do
    path = dir <> "*.{jpg,JPG}"
    Path.wildcard(path)
  end

  @spec read_data(String.t) :: {String.t, non_neg_integer, non_neg_integer, non_neg_integer}
  def read_data(file) do
    file
    |> Exexif.exif_from_jpeg_file()
    |> case do
      {:ok, %{exif: %{datetime_original: date}}} -> {file, date}
      _ -> {file, nil}
    end
    |> add_dimensions()
  end

  @spec add_dimensions({String.t, String.t | nil}) :: {String.t, non_neg_integer, non_neg_integer, non_neg_integer}
  defp add_dimensions({file, nil}), do: {file, nil, nil, nil}
  defp add_dimensions({file, date}) do
    {_type, width, height, _info} = ExImageInfo.info File.read!(file)
    {file, date, width, height}
  end
end
