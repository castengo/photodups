defmodule Photodups do
  @moduledoc """
  Documentation for Photodups.
  """

  def scan(dir, dest) do
    dir
    |> list_files()
    |> process(dest)
  end

  def process([file | files], dest) do
    
  end

  def list_files(dir) do
    path = dir <> "*.{jpg,JPG}"
    IO.inspect path
    Path.wildcard(path)
  end

  def read_date(path) do
    {:ok, info} = Exexif.exif_from_jpeg_file(path)
    do_read_date(info)
  end

  defp do_read_date(%{exif: %{datetime_original: date}}), do: date
  defp do_read_date(_), do: nil

  def read_size(path) do
    File.stat!(path)
    |> Map.get(:size)
  end
end
