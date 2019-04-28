{lib, crate2nix}:

let featureMap = {
      default = ["tls"];
      resolvable = [ "feature1" "tls/extra_feature" ];
      feature1 = [];
      extra = [];
    };
    dependencies = {
      "tls" = "pkgid_tls";
      "extra" = "pkgid_extra";
      "with_target" = {
        target_cfg = true;
        optional = false;
        with_defaults = false;
        package_id = "pkgid_target";
      };
    };
in lib.runTests {
  testEmpty = {
      expr = crate2nix.expandFeatures featureMap [];
      expected = [];
    };
  testDefault = {
    expr = crate2nix.expandFeatures featureMap ["default"];
    expected = ["default" "tls" ];
  };
  testDefaultPlus = {
    expr = crate2nix.expandFeatures featureMap ["default" "resolvable"];
    expected = ["default" "feature1" "resolvable" "tls" "tls/extra_feature" ];
  };
}
