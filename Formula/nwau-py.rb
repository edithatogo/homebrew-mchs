class NwauPy < Formula
  include Language::Python::Virtualenv

  desc "Utilities for calculating IHACPA National Weighted Activity Units"
  homepage "https://github.com/edithatogo/mchs"
  url "https://files.pythonhosted.org/packages/source/n/nwau-py/nwau_py-0.2.2.tar.gz"
  sha256 "c0998035a2e0ceebe913717170994ef668159c6e384524932c55c18fc1ce0480"
  version "0.2.2"
  license "MIT"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"funding-calculator", "--help"
  end
end
