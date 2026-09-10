/* ============================================================================
   corollary6-additive.gp -- obstructed surfaces whose curve has ADDITIVE
   reduction at the critical prime (survey document §10.9.2).

   Theorem 8's hypothesis (a) is about E_d, not E.  By §10.8.1 the square class
   making E_d split multiplicative is RAMIFIED when E is of type I_n*, i.e.
   potentially multiplicative.  Twisting the defining cubic of a known example
   by its own critical prime, f_p(x) = p^3 f(x/p) -- which gives the SAME Kummer
   surface -- produces exactly that: E is additive at p, and the critical class
   moves from [1] or [u] to the ramified [p] or [u*p].

   These are therefore the same four surfaces as before in different models, and
   the check is a real one: chapter 3's search must now fail in a DIFFERENT
   square class, the ramified one, at the same prime.  It tests §10.8.1 and the
   class-label transport of §4 at once.

   Output: results/survey-corollary6-additive.txt
   ============================================================================ */
read("survey.gp");

main() = {
  print("=== additive at the critical prime: the class must move to a ramified one ===");
  print("");
  print(">>> f = x^3 + 28x^2 + 7056x + 27440   (ell=3, I3* at 7)");
  print(">>> PREDICTED: p = 7, class [7], i.e. the THIRD slot");
  runsurface("add-7", [28, 7056, 27440], 1500, 50, 200, 60, 3000, 300);
  print(">>> f = x^3 + 13x^2 - 12168x - 1089712   (ell=3, I3* at 13)");
  print(">>> PREDICTED: p = 13, class [13], i.e. the THIRD slot");
  runsurface("add-13", [13, -12168, -1089712], 1500, 50, 200, 60, 3000, 300);
  print(">>> f = x^3 + 148x^2 - 503792x - 161279152   (ell=3, I3* at 37)");
  print(">>> PREDICTED: p = 37, class [37], i.e. the THIRD slot");
  runsurface("add-37", [148, -503792, -161279152], 1500, 50, 200, 60, 3000, 300);
  print(">>> f = x^3 + 284x^2 - 348353264x - 2300594642240   (ell=5, I5* at 71)");
  print(">>> PREDICTED: p = 71, class [u*71], i.e. the FOURTH slot");
  runsurface("add-71", [284, -348353264, -2300594642240], 1500, 50, 200, 60, 3000, 300);
}
main();
print("### corollary6-additive finished");
quit;
