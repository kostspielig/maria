defmodule MariaWeb.File do
    require Logger

  def bucket, do: Application.get_env(:maria, MariaWeb.RecipeController)[:s3][:bucket]
  def region, do: Application.get_env(:ex_aws, :region)

  @doc """
  Uploads a blob to S3.
  """
  def upload(file, filename) do
    {_, image_binary} = File.read(file.path)

    # Upload picture to AWS
    case ExAws.S3.put_object(bucket(), filename, image_binary) |> ExAws.request do
      {:ok, _} ->
        "https://#{bucket()}.s3.#{region()}.amazonaws.com/#{filename}"
      {:error, exception} ->
        Logger.debug("Failed to upload file: #{exception}")
        ""
    end
  end

  def delete(url) do
    unique_filename = url |> String.split("/") |> List.last()
    ExAws.S3.delete_object(bucket(), unique_filename) |> ExAws.request()
  end

  def generate_name(filename, title) do
    file_uuid = UUID.uuid4(:hex)
    image_filename = String.replace(title, " ", "-") |> String.downcase()
    "#{image_filename}-#{file_uuid}" <> Path.extname(filename)
  end
end
