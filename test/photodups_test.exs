defmodule PhotodupsTest do
  use ExUnit.Case
  doctest Photodups

  test "scans directory for duplicates" do
    assert ["test/fixtures/album_2/IMG_5510 (1).JPG", "test/fixtures/album_2/IMG_3900.JPG"] == Photodups.scan("test/fixtures/album_2/")
  end

  test "reads date created for image" do
    assert {"test/fixtures/album/IMG_1751.JPG", "2014:12:01 19:50:49", 1432, 1432} == Photodups.read_data("test/fixtures/album/IMG_1751.JPG")
  end

  test "lists files for given directory" do
    files = [
      "test/fixtures/album/afraid.jpg",
      "test/fixtures/album/IMG_1751.JPG",
      "test/fixtures/album/IMG_5266.JPG"
    ] |> Enum.sort

    assert files == Photodups.list_files("test/fixtures/album/")
  end

  test "remove_dups/1 should remove dups and keep highest quality" do
    files = [
        {"test/fixtures/album/IMG_5266.JPG", "2014:12:01 19:50:49", 2400, 2800},
        {"test/fixtures/album/IMG_1751.JPG", "2014:12:01 19:50:49", 1600, 1800}
    ]

    assert "test/fixtures/album/IMG_5266.JPG" == Photodups.remove_dups(files)
  end

  test "remove_dups/1 should return the file name if no dups" do
    files = [{"test/fixtures/album/afraid.jpg", "2013:06:09 14:06:52", 2400, 2800}]

    assert "test/fixtures/album/afraid.jpg" == Photodups.remove_dups(files)
  end
end
