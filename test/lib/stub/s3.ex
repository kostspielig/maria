defmodule  Maria.Test.Stub.Storage do
  @moduledoc """
  This module defines test stub for ExAws.S3
  entities.
  """
  def request(type \\ :ok) do
    case type do
      :error -> {:error, ""}
      _ -> {:ok, ""}
    end
  end

  defmodule  S3 do
    def put_object(_, _, _) do "" end
    def delete_object(_, _) do "" end
  end
end
