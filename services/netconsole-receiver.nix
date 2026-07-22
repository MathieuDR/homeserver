# Receives netconsole kernel logs streamed from firesprout (192.168.178.210).
#
# firesprout hard-hangs with nothing on disk; it streams its kernel log over UDP
# so a panic/lockup's dying breath lands here instead of vanishing. hpi is the
# receiver because it has ~1000 days uptime and never sleeps.
#
# Output: /var/log/netconsole-firesprout.log (nc writes each datagram directly).
{pkgs, ...}: {
  _file = ./netconsole-receiver.nix;

  networking.firewall.allowedUDPPorts = [6666];

  systemd.services.netconsole-receiver = {
    description = "Receive netconsole kernel logs from firesprout";
    wantedBy = ["multi-user.target"];
    after = ["network.target"];
    serviceConfig = {
      ExecStart = "${pkgs.netcat-openbsd}/bin/nc -u -k -l 6666";
      Restart = "always";
      RestartSec = 2;
      StandardOutput = "append:/var/log/netconsole-firesprout.log";
      StandardError = "journal";
    };
  };
}
