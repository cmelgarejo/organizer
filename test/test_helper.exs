ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Organizer.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Organizer.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Organizer.Repo)

