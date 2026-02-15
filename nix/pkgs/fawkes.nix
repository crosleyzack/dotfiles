################################################################################
# Fawkes - Privacy Protection Against Facial Recognition
#
# Purpose:
#   Builds and installs Fawkes, a privacy protection tool that adds imperceptible
#   perturbations to images to prevent them from being used to train facial
#   recognition models without consent.
#
# What is Fawkes:
#   Developed by researchers at SANDLab, University of Chicago, Fawkes protects
#   personal images from unauthorized facial recognition by "cloaking" them with
#   subtle changes that are invisible to humans but confuse ML models.
#
# Package Details:
#   - Version: 0.3 (released July 30, 2020)
#   - Source: GitHub repository (Shawn-Shan/fawkes)
#   - Format: Python setuptools package
#   - Command: 'fawkes' CLI tool available after installation
#
# Dependencies:
#   - Python 3.5+
#   - numpy >= 1.19.5
#   - tensorflow 2.4.1
#   - keras 2.4.3
#   - mtcnn (facial detection)
#   - pillow >= 7.0.0
#   - bleach >= 2.1.0
#
# Usage:
#   After installation, run:
#     fawkes -d [directory] -m [low|mid|high]
#
#   Options:
#     -d, --directory: Directory containing images to cloak
#     -m, --mode: Protection mode (low/mid/high)
#     -g, --gpu: GPU device ID (default: 0)
#     -b, --batch-size: Batch size for processing
#     --format: Output image format
#
# Installation in home-manager:
#   Add this file to imports in your home.nix:
#     imports = [ ../pkgs/fawkes.nix ];
#
# License:
#   BSD-3-Clause
#
# References:
#   - GitHub: https://github.com/Shawn-Shan/fawkes
#   - Project: https://sandlab.cs.uchicago.edu/fawkes/
#   - Paper: "Fawkes: Protecting Privacy against Unauthorized Deep Face Recognition"
################################################################################

{ pkgs, lib, ... }:

let
  pythonPackages = pkgs.python3Packages;

  # Build Fawkes from source using buildPythonPackage
  fawkes = pythonPackages.buildPythonPackage rec {
    pname = "fawkes";
    version = "0.3";
    format = "setuptools";

    src = pkgs.fetchFromGitHub {
      owner = "Shawn-Shan";
      repo = "fawkes";
      rev = "v${version}";
      sha256 = "sha256-h/XFFUfDuJCh2l/H7xNS4njeIdrT8ODc7akMfdzzeZI=";
    };

    propagatedBuildInputs = with pythonPackages; [
      numpy
      tensorflow
      keras
      mtcnn
      pillow
      bleach
    ];

    # Fawkes doesn't have tests in the repository
    doCheck = false;

    pythonImportsCheck = [ "fawkes" ];

    meta = with lib; {
      description = "Privacy protection system to protect personal images from unauthorized facial recognition";
      longDescription = ''
        Fawkes is a privacy protection system developed by researchers at SANDLab,
        University of Chicago. It adds imperceptible perturbations to images to
        prevent them from being used to train facial recognition models without consent.
      '';
      homepage = "https://github.com/Shawn-Shan/fawkes";
      license = licenses.bsd3;
      maintainers = [ ];
      platforms = platforms.unix;
    };
  };
in
{
  # Install Fawkes into user profile
  home.packages = [ fawkes ];
}
