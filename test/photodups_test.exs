defmodule PhotodupsTest do
  use ExUnit.Case
  doctest Photodups

  test "scans directory for duplicates" do
    Photodups.scan("test/fixtures/album/")
  end

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

  test "remove_dups/1 should remove dups and keep highest quality" do
    files = [
        {"test/fixtures/album/IMG_5266.JPG", "2014:12:01 19:50:49", 1671746},
        {"test/fixtures/album/IMG_1751.JPG", "2014:12:01 19:50:49", 598247}
    ]

    assert "test/fixtures/album/IMG_5266.JPG" == Photodups.remove_dups(files)
  end

  test "remove_dups/1 should return the file name if no dups" do
    files = [{"test/fixtures/album/afraid.jpg", "2013:06:09 14:06:52", 896855}]

    assert "test/fixtures/album/afraid.jpg" == Photodups.remove_dups(files)
  end
end
