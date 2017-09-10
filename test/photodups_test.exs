defmodule PhotodupsTest do
  use ExUnit.Case
  doctest Photodups

  test "reads date created for image" do
    assert "2014:12:01 19:50:49" == Photodups.read_date("test/fixtures/album/IMG_1751.JPG")
  end

  test "reads file size for image" do
    assert 598247 == Photodups.read_size("test/fixtures/album/IMG_1751.JPG")
  end

  test "lists files for given directory" do
    files = [
      "test/fixtures/album/afraid.jpg",
      "test/fixtures/album/IMG_1751.JPG",
      "test/fixtures/album/IMG_5266.JPG"
    ] |> Enum.sort

    assert files == Photodups.list_files("test/fixtures/album/")
  end
end
