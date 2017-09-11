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
