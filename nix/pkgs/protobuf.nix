{ pkgs, lib, ... }:

let
  # setup protoc
  protoc-custom = pkgs.stdenv.mkDerivation {
    pname = "protoc";
    version = "34.1";
    src = pkgs.fetchzip {
      url = "https://github.com/protocolbuffers/protobuf/releases/download/v34.1/protoc-34.1-linux-x86_64.zip";
      hash = "sha256-LmEfymOm15DLLVicXj1w4xpGfzRjeekPwQpxnsYe7h4=";
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

  # setup protoc-gen-go
  protoc-gen-go = pkgs.buildGoModule {
    pname = "protoc-gen-go";
    version = "1.36.11";
    src = pkgs.fetchFromGitHub {
      owner = "protocolbuffers";
      repo = "protobuf-go";
      rev = "v1.36.11";
      hash = "sha256-7+w3f5dDcQCw87A6P+JZXfMejS4QHANaLGK8QbUAaQs=";
    };
    vendorHash = "sha256-EAkrbx9pTBhZ0y0ub14PnMINrk1M6yEgnGapzpgXqBU=";
    subPackages = [ "cmd/protoc-gen-go" ];
  };

  # install protoc-gen-go-grpc
  protoc-gen-go-grpc = pkgs.buildGoModule rec {
    pname = "protoc-gen-go-grpc";
    version = "1.6.1";
    src = pkgs.fetchFromGitHub {
      owner = "grpc";
      repo = "grpc-go";
      rev = "cmd/protoc-gen-go-grpc/v${version}";
      hash = "sha256-s6GZ9K0Wy18YF1RBL0RGDCbtCfAV2bskq6DNXwyorgg=";
    };
    vendorHash = "sha256-+D3prb03c/Vgm+p3CxCZw14UMCvrDc1Cllzn1znZAE0=";
    modRoot = "cmd/protoc-gen-go-grpc";
  };

  # pull grpc-gateway repo tag
  grpc-gateway-src = pkgs.fetchFromGitHub {
    owner = "grpc-ecosystem";
    repo = "grpc-gateway";
    rev = "v2.22.0";
    hash = "sha256-I1w3gfV06J8xG1xJ+XuMIGkV2/Ofszo7SCC+z4Xb6l4=";
  };

  # install protoc-gen-grpc-gateway from grpc-gateway repo
  protoc-gen-grpc-gateway = pkgs.buildGoModule {
    pname = "protoc-gen-grpc-gateway";
    version = "2.22.0";
    src = grpc-gateway-src;
    vendorHash = "sha256-S4hcD5/BSGxM2qdJHMxOkxsJ5+Ks6m4lKHSS9+yZ17c=";
    subPackages = [ "protoc-gen-grpc-gateway" ];
  };

  # install protoc-gen-openapiv2 from grpc-gateway repo
  protoc-gen-openapiv2 = pkgs.buildGoModule {
    pname = "protoc-gen-openapiv2";
    version = "2.22.0";
    src = grpc-gateway-src;
    vendorHash = "sha256-S4hcD5/BSGxM2qdJHMxOkxsJ5+Ks6m4lKHSS9+yZ17c=";
    subPackages = [ "protoc-gen-openapiv2" ];
  };
in
{
  # install the above protobuf packages into user profile
  home.packages = [
    pkgs.buf
    pkgs.grpcurl
    protoc-custom
    protoc-gen-go
    protoc-gen-go-grpc
    protoc-gen-grpc-gateway
    protoc-gen-openapiv2
  ];
}
