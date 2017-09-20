defmodule Annon.Plugins.UARestriction.SettingsValidator do
  @moduledoc """
  Validation rules for UARestriction plugin settings.
  """
  import Annon.Plugin.JsonSchemaValidator

  def validate_settings(%Ecto.Changeset{} = changeset) do
    # TODO: Validate that regexps is valid
    validate_with_json_schema(changeset, :settings, settings_validation_schema())
  end

  # TODO: a least one el. per values array
  # TODO: extract into meta
  def settings_validation_schema do
    %{
      "type" => "object",
      "anyOf" => [
        %{"required" => ["whitelist", "blacklist"]},
        %{"required" => ["whitelist"]},
        %{"required" => ["blacklist"]}
      ],
      "additionalProperties" => false,
      "properties" => %{
        "whitelist" => %{
          "type" => "array",
          "items" => %{
            "type" => "object",
            "properties" => %{
              "name" => %{
                "type" => "string"
              },
              "values" => %{
                "type" => "array",
                "items" => %{
                  "type" => "string"
                }
              }
            },
            "additionalProperties" => false
          }
        },
        "blacklist" => %{
          "type" => "array",
          "items" => %{
            "type" => "object",
            "properties" => %{
              "name" => %{
                "type" => "string"
              },
              "values" => %{
                "type" => "array",
                "items" => %{
                  "type" => "string"
                }
              }
            },
            "additionalProperties" => false
          }
        }
      }
    }
  end
end
