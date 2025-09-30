# SearXNG service configuration
{ config, pkgs, ... }:

{
  services.searx = {
    enable = true;
    settings = {
      server = {
        port = 3001;
        bind_address = "127.0.0.1";
        secret_key = "changeme-generate-a-secret-key";
        base_url = "http://localhost:3001/";
      };
      
      ui = {
        static_use_hash = true;
        default_theme = "simple";
        theme_args = {
          simple_style = "dark";
        };
      };

      search = {
        safe_search = 0;
        autocomplete = "google";
        default_lang = "en";
        ban_time_on_fail = 5;
        max_ban_time_on_fail = 120;
      };

      engines = [
        {
          name = "google";
          disabled = false;
        }
        {
          name = "duckduckgo";
          disabled = false;
        }
        {
          name = "wikipedia";
          disabled = false;
        }
        {
          name = "github";
          disabled = false;
        }
      ];
    };
  };

  # Ensure the service starts on boot
  systemd.services.searx.wantedBy = [ "multi-user.target" ];
}
