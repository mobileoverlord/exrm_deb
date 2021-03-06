defmodule ExrmDeb.Generators.Systemd do
  @moduledoc ~S"""
  This module produces a systemd unit file from the config and a template.
  """
  alias ReleaseManager.Utils.Logger
  alias ExrmDeb.Generators.TemplateFinder
  import Logger, only: [debug: 1]

  def build(data_dir, config) do
    debug "Building Systemd Service File"

    systemd_script =
      ["init_scripts", "systemd.service.eex"]
      |> TemplateFinder.retrieve
      |> EEx.eval_file([
        description: config.description,
        name: config.name,
        uid: config.owner[:user],
        gid: config.owner[:group]
      ])

    out_dir =
      [data_dir, "lib", "systemd", "system"]
      |> Path.join

    :ok = File.mkdir_p(out_dir)

    :ok =
      [out_dir, config.sanitized_name <> ".service"]
      |> Path.join
      |> File.write(systemd_script)
  end

end
