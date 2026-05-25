class NwauPy < Formula
  include Language::Python::Virtualenv

  desc "Utilities for calculating IHACPA National Weighted Activity Units"
  homepage "https://github.com/edithatogo/mchs"
  url "https://files.pythonhosted.org/packages/90/5f/b64f960d692ac550af6ac05239f34c61f40093cc41d7d9f529c434bb204b/nwau_py-0.2.2.tar.gz"
  sha256 "c0998035a2e0ceebe913717170994ef668159c6e384524932c55c18fc1ce0480"
  license "MIT"

  depends_on "python@3.13"

  resource "click" do
    url "https://files.pythonhosted.org/packages/9b/98/518d8e5081007684232226f475082b30087d0f585e8457db087298259f49/click-8.4.1.tar.gz"
    sha256 "918b5633eddf6b41c32d4f454bf0de810065c74e3f7dbf8ee5452f8be88d3e96"
  end

  def install
    inreplace "nwau_py/cli/main.py" do |s|
      eager_imports = [
        "import click",
        "import pandas as pd",
        "",
        "from nwau_py.calculators import (",
        "    AcuteParams,",
        "    EDParams,",
        "    OutpatientParams,",
        "    calculate_acute,",
        "    calculate_ed,",
        "    calculate_outpatients,",
        ")",
        "from nwau_py.classification_validation import get_classification_requirement",
        "from nwau_py.coding_set_registry import (",
        "    CodingSetRegistryError,",
        "    list_coding_set_families,",
        "    validate_coding_set_compatibility,",
        ")",
        "from nwau_py.pricing_year_diff import (",
        "    compare_pricing_year_manifests,",
        "    format_pricing_year_diff_report,",
        ")",
        "from nwau_py.pricing_year_validation import (",
        "    format_pricing_year_validation_report,",
        "    validate_pricing_year,",
        ")",
        "from nwau_py.reference_manifest import ReferenceManifestError",
        "from nwau_py.runtime import run_csv_calculation",
        "from nwau_py.source_scanner import manifest_to_json, scan_sources_dry_run",
        "",
      ].join("\n")
      s.gsub! eager_imports, "import click\n"
      s.gsub! "def _write_output(df: pd.DataFrame, outfh: IO[str]) -> None:",
              "def _write_output(df: Any, outfh: IO[str]) -> None:"
      run_imports = [
        "    import pandas as pd",
        "",
        "    from nwau_py.classification_validation import get_classification_requirement",
        "    from nwau_py.runtime import run_csv_calculation",
        "",
        "    validation_year = year or \"2025\"",
      ].join("\n").concat("\n")
      s.gsub! "    validation_year = year or \"2025\"\n",
              run_imports
      s.gsub! "    families = []\n",
              "    from nwau_py.coding_set_registry import list_coding_set_families\n\n    families = []\n"
      coding_imports = [
        "    from nwau_py.coding_set_registry import (",
        "        CodingSetRegistryError,",
        "        validate_coding_set_compatibility,",
        "    )",
        "",
        "    try:",
        "        result = validate_coding_set_compatibility(system, year, version)",
      ].join("\n").concat("\n")
      s.gsub! "    try:\n        result = validate_coding_set_compatibility(system, year, version)\n",
              coding_imports
      source_scan_imports = [
        "    from nwau_py.source_scanner import (",
        "        manifest_to_json,",
        "        scan_sources_dry_run,",
        "    )",
        "",
        "    result = scan_sources_dry_run(",
      ].join("\n").concat("\n")
      s.gsub! "    result = scan_sources_dry_run(\n",
              source_scan_imports
      validation_imports = [
        "    from nwau_py.pricing_year_validation import (",
        "        format_pricing_year_validation_report,",
        "        validate_pricing_year,",
        "    )",
        "",
        "    report = validate_pricing_year(year)",
      ].join("\n").concat("\n")
      s.gsub! "    report = validate_pricing_year(year)\n",
              validation_imports
      diff_imports = [
        "    from nwau_py.pricing_year_diff import (",
        "        compare_pricing_year_manifests,",
        "        format_pricing_year_diff_report,",
        "    )",
        "    from nwau_py.reference_manifest import ReferenceManifestError",
        "",
        "    try:",
        "        report = compare_pricing_year_manifests(from_year, to_year)",
      ].join("\n").concat("\n")
      s.gsub! "    try:\n        report = compare_pricing_year_manifests(from_year, to_year)\n",
              diff_imports
      acute_imports = [
        "    from nwau_py.calculators import AcuteParams, calculate_acute",
        "",
        "    _run(\"acute\", calculate_acute, AcuteParams(), input_csv, output, year, params)",
      ].join("\n").concat("\n")
      s.gsub! "    _run(\"acute\", calculate_acute, AcuteParams(), input_csv, output, year, params)\n",
              acute_imports
      ed_imports = [
        "    from nwau_py.calculators import EDParams, calculate_ed",
        "",
        "    _run(\"ed\", calculate_ed, EDParams(), input_csv, output, year, params)",
      ].join("\n").concat("\n")
      s.gsub! "    _run(\"ed\", calculate_ed, EDParams(), input_csv, output, year, params)\n",
              ed_imports
      outpatient_imports = [
        "    from nwau_py.calculators import (",
        "        OutpatientParams,",
        "        calculate_outpatients,",
        "    )",
        "",
        "    _run(",
        "        \"outpatients\",",
      ].join("\n").concat("\n")
      s.gsub! "    _run(\n        \"outpatients\",\n",
              outpatient_imports
    end

    virtualenv_install_with_resources(using: "python3.13")
  end

  test do
    system bin/"funding-calculator", "--help"
  end
end
