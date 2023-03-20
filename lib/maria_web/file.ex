defmodule MariaWeb.File do
  @storage_dependency Application.compile_env(
    :maria, :storage_dependency, ExAws
  )
  require Logger

  def bucket, do: Application.get_env(:maria, MariaWeb.RecipeController)[:s3][:bucket]
  def region, do: Application.get_env(:ex_aws, :region)

  @doc """
  Uploads a blob to S3.
  """
  def upload(file, filename, socket) do
    Phoenix.LiveView.consume_uploaded_entry(socket, file, fn %{path: path} ->
      {_, image_binary} = File.read(path)

      case @storage_dependency.S3.put_object(bucket(), filename, image_binary) |> @storage_dependency.request do
        {:ok, _} ->
          {:ok, "https://#{bucket()}.s3.#{region()}.amazonaws.com/#{filename}"}
        {:error, exception} ->
          Logger.debug("Failed to upload file: #{exception}")
         {:ok, ""}
      end
    end)
  end

  def delete(url) do
    unique_filename = url |> String.split("/") |> List.last()
    @storage_dependency.S3.delete_object(bucket(), unique_filename) |> @storage_dependency.request()
  end

  def generate_name(filename, title) do
    file_uuid = UUID.uuid4(:hex)
    image_filename = String.replace(title, " ", "-") |> String.downcase()
    "#{image_filename}-#{file_uuid}" <> Path.extname(filename)
  end
end
