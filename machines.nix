{
  master = {config, pkgs, ...}: 
  let 
    documentRoot = pkgs.stdenv.mkDerivation {
      name = "documentroot";
      src = null;
      phases = "buildPhase";

      buildInputs = [ pkgs.gzip ];

      buildPhase = ''
        mkdir $out
        dd if=/dev/zero of=$out/download.raw bs=1MB count=10
        ${pkgs.gzip}/bin/gzip -k $out/download.raw

        mkdir tar_file
        for nr in `seq 10`; do
          dd if=/dev/zero of=tar_file/$nr bs=1MB count=10
        done
        ${pkgs.gnutar}/bin/tar -c tar_file/* > $out/tar_file.tar
        ${pkgs.gzip}/bin/gzip -k -c $out/tar_file.tar > $out/tar_file.tgz
      '';
    };
  in {
    deployment = {
      targetEnv = "virtualbox";
      virtualbox = { 
        memorySize = 512;
        headless = true;
      };
    };

    networking.firewall.enable = false;

    services.zookeeper = {
        enable = true;
        id = 1;
        servers = "servers.0=master:2888:3888";
    };

    environment.systemPackages = with pkgs; [ curl ];

    services.httpd = { 
      adminAddr = "no@one.com";
      enable = true;
      documentRoot = documentRoot;
    };

    services.mesos.master = {
      enable = true;
      zk = "zk://master:2181/mesos";
      quorum = 1;
    };

    services.marathon = {
      enable = true;
      master = "zk://master:2181/mesos";
      zookeeperHosts = ["master:2181"];
      user = "root";
    };
  };

  slave = {config, pkgs, ...}: 
  {
    deployment = {
      targetEnv = "virtualbox";
      virtualbox = { 
        memorySize = 512;
        headless = true;
      };
    };


    environment.systemPackages = with pkgs; [ jq ];

    networking.firewall.enable = false;

    systemd.services.mesos-slave.path = [ pkgs.curl pkgs.jdk pkgs.gnutar pkgs.gzip pkgs.bzip2 ];
    services.mesos.slave = {
      enable = true;
      master = "zk://master:2181/mesos";
      extraCmdLineOptions = ["--no-switch_user"];
    };
  };
}
