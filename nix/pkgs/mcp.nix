{ pkgs, lib, ... }:

# One declaration of every MCP server, for every client that reads it. The
# module writes ~/.config/mcp/mcp.json, and zed.nix merges the same servers
# into "context_servers" with "enableMcpIntegration".
#
# Claude Code reads none of this. Its settings file holds no "mcpServers" key,
# thus claude.nix carries a plugin for each server of the agent.
#
# A remote server needs a sign-in in the client, which holds the token of the
# flow. No secret reaches the store.
{
  programs.mcp = {
    enable = true;

    servers = {
      linear.url = "https://mcp.linear.app/mcp";

      # The four servers of Chainguard, each of one data source. The session
      # of chainctl carries the sign-in.
      cg-oci.url = "https://cgr.dev/mcp";
      cg-apk.url = "https://apk.cgr.dev/mcp";
      cg-versions.url = "https://versions.cgr.dev/mcp";
      cg-api.url = "https://console-api.enforce.dev/mcp";

      # Registry and provider documents, for the terraform of cloud.nix.
      terraform = {
        command = lib.getExe pkgs.terraform-mcp-server;
        args = [ "stdio" ];
      };

      # Package and option search, for this repository.
      nixos.command = lib.getExe pkgs.mcp-nixos;
    };
  };
}
