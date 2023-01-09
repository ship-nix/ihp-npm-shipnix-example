# Shipnix recommended settings
# IMPORTANT: These settings are here for ship-nix to function properly on your server
# Modify with care

{ config, pkgs, modulesPath, lib, ... }:
{
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes ca-derivations
    '';
    settings = {
      trusted-users = [ "root" "ship" "nix-ssh" ];
    };
  };

  programs.git.enable = true;
  programs.git.config = {
    advice.detachedHead = false;
  };

  services.openssh = {
    enable = true;
    # ship-nix uses SSH keys to gain access to the server
    # Manage permitted public keys in the `authorized_keys` file
    passwordAuthentication = false;
    #  permitRootLogin = "no";
  };


  users.users.ship = {
    isNormalUser = true;
    extraGroups = [ "wheel" "nginx" ];
    # If you don't want public keys to live in the repo, you can remove the line below
    # ~/.ssh will be used instead and will not be checked into version control. 
    # Note that this requires you to manage SSH keys manually via SSH,
    # and your will need to manage authorized keys for root and ship user separately
    openssh.authorizedKeys.keyFiles = [ ./authorized_keys ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdgh2CbsQ8wjdEs9X6+kxJ+PdbW0Jis4YvZQa2N/Q+RYKxQXcGWLZfK1l8XWilwfsKLEUFGXnfJTZVjCIBZ3nef4caOMwUq9n3hk/zb6eFXt8LQ8QGqlv2plRqcYGaLHNiaI1HdXYRj/t/OjuKamVZKF7V2t5LOMt/3h7oGBymDHuJeQyWracBO1AHvqSwafjd9XiNd2B/W+bN9hrG1IeRNz8Su930MVpLo1/wdhKNnHdDYjyATtzyVqPMxjQaFJpbwQUCIuN1cPR8SDPEswAt2qI29iIxwNjZGyGvbk9/gNXNVBGfeooCLKjHTEqz9WKGBums7PqXVB5FXhpb5xYpOiAuh4JY72xFQ1yhB2NhK7f3xjxvfADGJkJKRdnFIwBKb54KncUwHWrX0ll4OGVYJv5ImRRIo2GpSVgCKJMcKDaPN3aCVethjU6FzNUKHNZeDMzI9aLCFckC76G09YrNEh97g//5Kp0r30+Cr8PZ5DRBjVDwD+Kio8SqmEsTkMU= lillo@kodeFant
"
    ];
  };

  # Can be removed if you want authorized keys to only live on server, not in repository
  # Se note above for users.users.ship.openssh.authorizedKeys.keyFiles
  users.users.root.openssh.authorizedKeys.keyFiles = [ ./authorized_keys ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDdgh2CbsQ8wjdEs9X6+kxJ+PdbW0Jis4YvZQa2N/Q+RYKxQXcGWLZfK1l8XWilwfsKLEUFGXnfJTZVjCIBZ3nef4caOMwUq9n3hk/zb6eFXt8LQ8QGqlv2plRqcYGaLHNiaI1HdXYRj/t/OjuKamVZKF7V2t5LOMt/3h7oGBymDHuJeQyWracBO1AHvqSwafjd9XiNd2B/W+bN9hrG1IeRNz8Su930MVpLo1/wdhKNnHdDYjyATtzyVqPMxjQaFJpbwQUCIuN1cPR8SDPEswAt2qI29iIxwNjZGyGvbk9/gNXNVBGfeooCLKjHTEqz9WKGBums7PqXVB5FXhpb5xYpOiAuh4JY72xFQ1yhB2NhK7f3xjxvfADGJkJKRdnFIwBKb54KncUwHWrX0ll4OGVYJv5ImRRIo2GpSVgCKJMcKDaPN3aCVethjU6FzNUKHNZeDMzI9aLCFckC76G09YrNEh97g//5Kp0r30+Cr8PZ5DRBjVDwD+Kio8SqmEsTkMU= lillo@kodeFant
"
  ];

  security.sudo.extraRules = [
    {
      users = [ "ship" ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" "SETENV" ];
        }
      ];
    }
  ];
}
