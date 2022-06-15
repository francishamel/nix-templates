
{
  description = "francishamel's flake templates";

  outputs = { self }: {
    templates = {
      elixir = {
        path = ./templates/elixir;
        description = "A flake for an elixir environment.";
      };
    };
  };
}
