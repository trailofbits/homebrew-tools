# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
require_relative "lib/private"
class Cloudfuzz < Formula
  desc ""
  homepage "https://github.com/trailofbits/cloudfuzz"
  version "0.0.1"

  on_macos do
    if Hardware::CPU.intel?
      url "https://github.com/trailofbits/cloudfuzz/releases/download/v0.0.1/cloudfuzz_darwin_x86_64.tar.gz", using: GitHubPrivateReleaseDownloadStrategy
      sha256 "85f933633f242be47afee93ce9f41807de31fd7e1130c4762541326c6d5a9ffa"

      def install
        bin.install "cloudfuzz"
      end
    end
    if Hardware::CPU.arm?
      url "https://github.com/trailofbits/cloudfuzz/releases/download/v0.0.1/cloudfuzz_darwin_arm64.tar.gz", using: GitHubPrivateReleaseDownloadStrategy
      sha256 "a23cca3e154c1aa648babdca98f1b0af76258e2c5fa0e615e68d3d8a8b562476"

      def install
        bin.install "cloudfuzz"
      end
    end
  end

  on_linux do
    if Hardware::CPU.intel?
      url "https://github.com/trailofbits/cloudfuzz/releases/download/v0.0.1/cloudfuzz_linux_x86_64.tar.gz", using: GitHubPrivateReleaseDownloadStrategy
      sha256 "e9c43bf87cf60841485ba657090729c626d3b1371d25ab9768c53600d94adbd4"

      def install
        bin.install "cloudfuzz"
      end
    end
    if Hardware::CPU.arm? && Hardware::CPU.is_64_bit?
      url "https://github.com/trailofbits/cloudfuzz/releases/download/v0.0.1/cloudfuzz_linux_arm64.tar.gz", using: GitHubPrivateReleaseDownloadStrategy
      sha256 "538eddc8aec6223742755bd15295357c15e4a8f6c658a2d246b2295a42a16b80"

      def install
        bin.install "cloudfuzz"
      end
    end
  end

  test do
    system "#{bin}/cloudfuzz version"
  end
end
