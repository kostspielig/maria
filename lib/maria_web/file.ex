defmodule MariaWeb.File do
  require Logger
  @extension_whitelist ~w(.jpg .jpeg .gif .png)

  def bucket, do: Application.get_env(:maria, MariaWeb.RecipeController)[:s3][:bucket]
  def region, do: Application.get_env(:ex_aws, :region)

  @doc """
  Uploads a blob to S3.
  """
  def upload(file, title, image_binary) do
    { upload, unique_filename } = file |> generate_name(title) |> validate

    # Upload picture to AWS
    try do
     upload && ExAws.S3.put_object(bucket(), unique_filename, image_binary)
      |> ExAws.request!
    rescue
      exception ->
        # Handle the exception here (e.g. log it, return an error message, etc.)
        Logger.debug("Failed to upload file: #{exception}")
    end

    "https://#{bucket()}.s3.#{region()}.amazonaws.com/#{unique_filename}"
  end

  defp validate(file) do
    file_extension = file |> Path.extname |> String.downcase
    { Enum.member?(@extension_whitelist, file_extension), file}
  end

  defp generate_name(filename, title) do
    file_uuid = UUID.uuid4(:hex)
    image_filename = String.replace(title, " ", "-") |> String.downcase()
    "#{image_filename}-#{file_uuid}" <> Path.extname(filename)
  end
end
