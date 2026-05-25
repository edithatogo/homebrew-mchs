class NwauPy < Formula
  include Language::Python::Virtualenv

  desc "Utilities for calculating IHACPA National Weighted Activity Units"
  homepage "https://github.com/edithatogo/mchs"
  url "https://files.pythonhosted.org/packages/90/5f/b64f960d692ac550af6ac05239f34c61f40093cc41d7d9f529c434bb204b/nwau_py-0.2.2.tar.gz"
  sha256 "c0998035a2e0ceebe913717170994ef668159c6e384524932c55c18fc1ce0480"
  license "MIT"

  depends_on "python@3.13"

  def install
    virtualenv_install_with_resources(using: "python3.13")
  end

  test do
    system bin/"funding-calculator", "--help"
  end
end
