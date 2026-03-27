{ pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    # Security hardening for SSH client
    # Note: For SSH servers you manage, also configure server-side rate limiting:
    #   - MaxAuthTries 3
    #   - MaxSessions 2
    #   - LoginGraceTime 30
    #   - Use fail2ban or sshguard for IP-based rate limiting
    matchBlocks = {
      # Apply these settings to all hosts
      "*" = {
        extraOptions = {
          # Common useful defaults
          "AddKeysToAgent" = "yes";
          "Compression" = "yes";
          "ControlMaster" = "auto";
          "ControlPath" = "~/.ssh/master-%r@%n:%p";
          "ControlPersist" = "30s";

          # Disable deprecated and insecure features
          "UseRoaming" = "no";

          # Hash known_hosts file for privacy
          "HashKnownHosts" = "yes";

          # Show visual host key for easier verification
          "VisualHostKey" = "yes";

          # Disable password authentication (use keys only)
          "PasswordAuthentication" = "no";
          "ChallengeResponseAuthentication" = "no";

          # Verify host keys strictly (ask on first connection)
          "StrictHostKeyChecking" = "ask";

          # Verify host keys using DNSSEC when available
          "VerifyHostKeyDNS" = "yes";

          # Use only strong key exchange algorithms
          "KexAlgorithms" = "curve25519-sha256,curve25519-sha256@libssh.org,diffie-hellman-group16-sha512,diffie-hellman-group18-sha512,diffie-hellman-group-exchange-sha256";

          # Use only strong ciphers
          "Ciphers" = "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr";

          # Use only strong MAC algorithms
          "MACs" = "hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com";

          # Use only strong host key algorithms
          "HostKeyAlgorithms" = "ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-256-cert-v01@openssh.com";

          # Prefer public key authentication
          "PubkeyAuthentication" = "yes";

          # Connection timeouts
          "ServerAliveInterval" = "60";
          "ServerAliveCountMax" = "3";
          "ConnectTimeout" = "10";

          # Limit connection attempts to prevent brute force
          # Limits retry attempts if initial connection fails
          "ConnectionAttempts" = "5";

          # Disable X11 forwarding by default (enable per-host if needed)
          "ForwardX11" = "no";

          # Disable agent forwarding by default (enable per-host if needed)
          "ForwardAgent" = "no";
        };
      };

      # Example: Override for specific trusted hosts
      # "github.com" = {
      #   extraOptions = {
      #     "ForwardAgent" = "yes";
      #   };
      # };
    };
  };
}
