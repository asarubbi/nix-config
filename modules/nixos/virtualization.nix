{ pkgs, ... }: {
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless = {
    enable = true;
    setSocketVariable = true;
  };
  
  virtualisation.podman.enable = true;
  
  virtualisation = {
    libvirtd = {
      enable = true;
      qemu = {
        package = pkgs.qemu_kvm;
        swtpm.enable = true;
      };
    };
    spiceUSBRedirection.enable = true;
  };
  
  services.spice-vdagentd.enable = true;
  
  environment.systemPackages = with pkgs; [
    distrobox
    docker-compose
    podman-compose
    qemu
    virt-manager
    virtio-win
    win-spice
  ];
}
