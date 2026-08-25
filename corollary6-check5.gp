read("survey.gp");
main() = {
  print("=== density check, the two new ell = 5 surfaces ===");
  print(">>> N=23808  PREDICTED critical p = 31, class [u]");
  runsurface("N=23808 (ell=5)", [-4, 30608, -5474624], 1500, 50, 200, 60, 3000, 300);
  print(">>> N=18176  PREDICTED critical p = 71, class [u]");
  runsurface("N=18176 (ell=5)", [4, -69104, -6427840], 1500, 50, 200, 60, 3000, 300);
}
main();
print("### check5 finished");
quit;
