{ pkgs, lib, ... }:

let
  protoc-29 = pkgs.stdenv.mkDerivation {
    pname = "protoc";
    version = "29.3";

    src = pkgs.fetchzip {
      url = "https://github.com/protocolbuffers/protobuf/releases/download/v29.3/protoc-29.3-linux-x86_64.zip";
      hash = "sha256-qufshY1rXjBwFkNT0HR7+neMVFdkOARcb4f+nfuDng4=";
      stripRoot = false;
    };

    installPhase = ''
      mkdir -p $out
      cp -r bin $out/
      cp -r include $out/
    '';

    meta = with lib; {
      description = "Protocol Buffers compiler";
      homepage = "https://github.com/protocolbuffers/protobuf";
      license = licenses.bsd3;
      platforms = platforms.linux;
    };
  };

  protoc-gen-go = pkgs.buildGoModule {
    pname = "protoc-gen-go";
    version = "1.34.2";

    src = pkgs.fetchFromGitHub {
      owner = "protocolbuffers";
      repo = "protobuf-go";
      rev = "v1.34.2";
      hash = "sha256-467+AhA3tADBg6+qbTd1SvLW+INL/1QVR8PzfAMYKFA=";
    };

    vendorHash = "sha256-nGI/Bd6eMEoY0sBwWEtyhFowHVvwLKjbT4yfzFz6Z3E=";

    subPackages = [ "cmd/protoc-gen-go" ];
  };

  protoc-gen-go-grpc = pkgs.buildGoModule rec {
    pname = "protoc-gen-go-grpc";
    version = "1.5.1";

    src = pkgs.fetchFromGitHub {
      owner = "grpc";
      repo = "grpc-go";
      rev = "cmd/protoc-gen-go-grpc/v${version}";
      hash = "sha256-PAUM0chkZCb4hGDQtCgHF3omPm0jP1sSDolx4EuOwXo=";
    };

    vendorHash = "sha256-yn6jo6Ku/bnbSX8FL0B/Uu3Knn59r1arjhsVUkZ0m9g=";

    modRoot = "cmd/protoc-gen-go-grpc";
  };

  grpc-gateway-src = pkgs.fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-gateway";
    rev = "v2.22.0";
    hash = "sha256-I1w3gfV06J8xG1xJ+XuMIGkV2/Ofszo7SCC+z4Xb6l4=";
  };

  protoc-gen-grpc-gateway = pkgs.buildGoModule {
    pname = "protoc-gen-grpc-gateway";
    version = "2.22.0";

    src = grpc-gateway-src;

    vendorHash = "sha256-S4hcD5/BSGxM2qdJHMxOkxsJ5+Ks6m4lKHSS9+yZ17c=";

    subPackages = [ "protoc-gen-grpc-gateway" ];
  };

  protoc-gen-openapiv2 = pkgs.buildGoModule {
    pname = "protoc-gen-openapiv2";
    version = "2.22.0";

    src = grpc-gateway-src;

    vendorHash = "sha256-S4hcD5/BSGxM2qdJHMxOkxsJ5+Ks6m4lKHSS9+yZ17c=";

    subPackages = [ "protoc-gen-openapiv2" ];
  };
in

{
  home.packages = [
    protoc-29
    protoc-gen-go
    protoc-gen-go-grpc
    protoc-gen-grpc-gateway
    protoc-gen-openapiv2
  ];
}
