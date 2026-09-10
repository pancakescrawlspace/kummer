/* ============================================================================
   corollary6-check.gp -- the chapter 3 density check on the surfaces that
   corollary6.gp predicts have exactly ONE critical prime.

   For each, chapter 3's search should witness all four square classes at every
   odd p <= 200 EXCEPT one class at the predicted p, where Corollary 6 says
   X(Q) is not dense in X(Q_p).  Same parameters as the survey run.

   Output: results/survey-corollary6-check.txt
   ============================================================================ */
read("survey.gp");

/* label, F = [a2,a4,a6], predicted critical prime, predicted class */
CASES = [["N=26  (ell=3)", [1,-72,-496], 13, 1], ["N=35  (ell=3)", [4,144,80], 7, 1], ["N=37  (ell=3)", [4,-368,-3184], 37, 1], ["N=38  (ell=3)", [1,152,5776], 19, 1], ["N=91  (ell=3)", [4,208,2704], 13, 1], ["N=370 (ell=3)", [1,-296,21904], 37, 1]];

main() = {
  print("=== density check on the Corollary 6 predictions ===");
  print("prediction: all four classes witnessed at every odd p <= 200,");
  print("except ONE class at the predicted critical prime.");
  for(i = 1, #CASES,
    my(C = CASES[i]);
    print("");
    print(">>> ", C[1], "   PREDICTED critical prime p = ", C[3], ", class of ", C[4]);
    runsurface(C[1], C[2], 1500, 50, 200, 60, 3000, 300));
}
main();
print("### corollary6-check finished");
quit;
