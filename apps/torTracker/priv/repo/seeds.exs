# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TorTracker.Repo.insert!(%TorTracker.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#
alias TorTracker.Repo
alias TorTracker.Accounts.User
alias TorTracker.Accounts
alias TorTracker.Relay.Info
alias TorTracker.Relay

Repo.delete_all Info
Repo.delete_all User

{:ok, user} = Accounts.register_user(%{email: "test@mail.com", password: "testtesttest"})

Relay.create_info(user, %{fingerprint: "11testFINGERPRINTtest11", ip: "192.168.0.17", port: 9051})

Relay.create_info(user, %{fingerprint: "22testFINGERPRINTtest22", ip: "192.168.0.17", port: 22})

