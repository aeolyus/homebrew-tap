class Pastry < Formula
  desc "Sweet command-line tool to interact with multiple pastebin backends"
  homepage "https://github.com/aeolyus/pastry"
  url "https://github.com/aeolyus/pastry.git"
  version "0.1.0"
  license "MPL-2.0"
  head "https://github.com/aeolyus/pastry.git", branch: "master"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"pastry", "--version"
  end
end
