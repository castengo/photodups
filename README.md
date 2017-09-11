# Photodups

**TODO: Add description**

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `photodups` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:photodups, "~> 0.1.0"}]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/photodups](https://hexdocs.pm/photodups).

# Notes

When scanning the pictures by evaluating file size doesnt guarantee we will
have the highest resolution picture. We need to look at width and height.
Also if we want to keep the instagram picture, we need to compare the height to
width ratio since instagram only allowed square pictures in 2014. Videos don't
seem to be working at the time.


Steps at first compared with image size.

Then compared width.

Realized that instagram pictures where same resolution so decided to get height also.
Need to treat them separately.

For whatever reason, the height and width fields could get mixed up so im gonna
have to multiply one by the other for max resolution.

 --- With this the instagram picture will never win! because the height or the width
 is cut off!

 Metadata doesnt match actual image dimensions... it matches original dimensions.
 IMG_5523.jpg is the weird one!

 Google "elixir image dimensions" found package, used that to get actual dimensions.

 Will have to skip files with no metadata, TODO? also instagram pictures have more
 pixels than the original....cryyyyy
