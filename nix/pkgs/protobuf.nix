{ pkgs, lib, ... }:

let
  protoc = pkgs.buildGoModule rec {
    pname = "protoc"; # Name of your application
    version = "29.3";   # Version of the application
    src = pkgs.fetchFromGitHub {
      owner = "protocolbuffers";
      repo = "protobuf";
      rev = "v${version}"; # The specific Git tag or commit hash
      sha256 = "sha256-ex0ya6drPoC0GhCtlBm2Wz0Qo3RPxBQwSkHU3XUozag=";
    };
    vendorHash = "sha256-yVeuz/S1VPEXDK/AOIGpS/gefdGnyWnMG/IJjB3ctDM=";
    meta = with lib; {
      description = "Compiler for Google's language-neutral, platform-neutral, extensible mechanism for serializing structured data";
      homepage = "https://github.com/protocolbuffers/protobuf";
      license = licenses.bsd3; # Choose the correct license
      platforms = platforms.all;
    };
  };

  protocgengo = pkgs.buildGoModule rec {
    pname = "protoc-gen-go"; # Name of your application
    version = "1.34.2";   # Version of the application
    src = pkgs.fetchFromGitHub {
      owner = "protocolbuffers";
      repo = "protobuf-go";
      rev = "v${version}"; # The specific Git tag or commit hash
      sha256 = "sha256-467+AhA3tADBg6+qbTd1SvLW+INL/1QVR8PzfAMYKFA=";
    };
    vendorHash = "sha256-nGI/Bd6eMEoY0sBwWEtyhFowHVvwLKjbT4yfzFz6Z3E=";
    meta = with lib; {
      description = "Golang compiler for Google's language-neutral, platform-neutral, extensible mechanism for serializing structured data";
      homepage = "https://github.com/protocolbuffers/protobuf-go";
      license = licenses.bsd3; # Choose the correct license
      platforms = platforms.all;
    };
  };

  # error "go: go.mod file not found in current directory or any parent directory"
  protocgengogrpc = pkgs.buildGoModule rec {
    pname = "protoc-gen-go-grpc";
    version = "1.5.1";
    src = pkgs.fetchFromGitHub {
      owner = "grpc";
      repo = "grpc-go";
      rev = "cmd/protoc-gen-go-grpc/v${version}";
      sha256 = "sha256-Zk1rNyVb1b9fbAAMlprPJjfXxFDSPLd+B3hB0rbh9yA=";
    };
    vendorHash = "sha256-0000Bd6eMEoY0sBwWEtyhFowHVvwLKjbT4yfzFz6Z3E=";
    meta = with lib; {
      description = "The Go implementation of gRPC: A high performance, open source, general RPC framework that puts mobile and HTTP/2 first.";
      homepage = "https://github.com/grpc/grpc-go";
      license = licenses.asl20;
      platforms = platforms.all;
    };
  };

  # TODO this is one of two modules in this repo. How does this work?
  grpcgateway = pkgs.buildGoModule rec {
    pname = "protoc-gen-grpc-gateway";
    version = "2.22.0";
    src = pkgs.fetchFromGitHub {
      owner = "grpc-ecosystem";
      repo = "grpc-gateway";
      rev = "v${version}";
      sha256 = "sha256-I1w3gfV06J8xG1xJ+XuMIGkV2/Ofszo7SCC+z4Xb6l4=";
    };
    vendorHash = "sha256-S4hcD5/BSGxM2qdJHMxOkxsJ5+Ks6m4lKHSS9+yZ17c=";
    meta = with lib; {
      description = "The gRPC-Gateway is a plugin of the Google protocol buffers compiler protoc. It reads protobuf service definitions and generates a reverse-proxy server which translates a RESTful HTTP API into gRPC";
      homepage = "https://github.com/grpc-ecosystem/grpc-gateway";
      license = licenses.bsd3;
      platforms = platforms.all;
    };
  };

  # TODO this is one of two modules in this repo. How does this work?
  protocgenopenapiv2 = pkgs.buildGoModule rec {
    pname = "protoc-gen-openapiv2";
    version = "2.22.0";
    src = pkgs.fetchFromGitHub {
      owner = "grpc-ecosystem";
      repo = "grpc-gateway";
      rev = "v${version}";
      sha256 = "sha256-I1w3gfV06J8xG1xJ+XuMIGkV2/Ofszo7SCC+z4Xb6l4=";
    };
    vendorHash = "sha256-S4hcD5/BSGxM2qdJHMxOkxsJ5+Ks6m4lKHSS9+yZ17c=";
    meta = with lib; {
      description = "The gRPC-Gateway is a plugin of the Google protocol buffers compiler protoc. It reads protobuf service definitions and generates a reverse-proxy server which translates a RESTful HTTP API into gRPC";
      homepage = "https://github.com/grpc-ecosystem/grpc-gateway";
      license = licenses.bsd3;
      platforms = platforms.all;
    };
  };

in
{
  # Ensure the package is added to your user environment
  home.packages = [
    protoc
    protocgengo
    # protocgengogrpc
    # grpcgateway
    # protocgenopenapiv2
  ];
}
