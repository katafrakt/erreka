defmodule Erreka.User do
  use Erreka.Web, :model

  schema "users" do
    field :email, :string
    field :name, :string
    field :crypted_password, :string

    timestamps
  end

  @required_fields ~w(email name)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    # TODO: add unique constraint
    |> validate_length(:name, min: 3)
    |> validate_length(:password, min: 6)
    |> validate_length(:password_confirmation, min: 6)
    |> validate_confirmation(:password)
  end
end
