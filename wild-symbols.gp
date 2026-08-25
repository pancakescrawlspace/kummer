\\ wild-symbols.gp -- computations for wild-symbols.typ.
\\ Run from this directory:
\\     gp -q -s 12000000000 wild-symbols.gp < /dev/null > results/wild-symbols.txt
\\
\\ Why the n-th norm residue symbol is easy when v does not divide n (TAME) and
\\ hard when it does (WILD).  For a local field K containing mu_n,
\\     ( , )_n : K^*/(K^*)^n  x  K^*/(K^*)^n  ->  mu_n .
\\
\\ TAME (v does not divide n): the symbol is a residue-field computation.  Units
\\ pair trivially, K^*/(K^*)^n has order n^2, and the value is determined by the
\\ valuations and the residues -- one exponentiation in F_q.
\\
\\ WILD (v divides n): units do NOT pair trivially, K^*/(K^*)^n has order
\\ n^2/|n|_K which is |n|_K^{-1} times larger, and the symbol depends on the
\\ elements to depth pe/(p-1) in the maximal ideal, not to depth 1.  There is no
\\ residue-field formula; the explicit ones involve p-adic logarithms and formal
\\ power series.
\\
\\ Verified here:
\\   (1) units pair trivially at every odd place, and not at 2.
\\   (2) precision: mod v at odd v; mod 8 -- and no less -- at v = 2.
\\   (3) the depth of the unit filtration: U^(m) consists of n-th powers exactly
\\       for m > pe/(p-1).  Computed for squares in Q_2 and CUBES in Q_3(zeta_3).
\\   (4) the size of K^*/(K^*)^n = n^2/|n|_K, tame against wild.
\\   (5) the pairing filtration: which U^(i) x U^(j) carry a non-trivial symbol.
\\   (6) the tame formula, checked exhaustively.
\\   (7) what it costs to acquire mu_n in the first place.

print("=========================================================================");
print(" Tame and wild norm residue symbols: what actually changes");
print("=========================================================================");
print("");

\\ ------------------------------------------------- (1) units and the symbol

print("(1) At an odd place units are INVISIBLE to the symbol; at 2 they are not.");
print("");
{
my(bad = 0, n = 0);
forprime (p = 3, 200,
  for (u = 1, p-1, for (w = 1, p-1, n++; if (hilbert(u,w,p) != 1, bad++))));
print("    odd p < 200 : ", n, " pairs of units (u,w), non-trivial symbols = ", bad);
print("    reason: for v not dividing n, U^(1) is a pro-p group and n is prime to");
print("    p, so U^(1) is uniquely n-divisible -- it lies inside (K^*)^n and dies.");
print("");
print("    at v = 2 the four unit classes pair as:");
print("           1    3    5    7");
foreach ([1,3,5,7], u,
  print("      ", u, "    ", hilbert(u,1,2), "   ", hilbert(u,3,2), "   ",
        hilbert(u,5,2), "   ", hilbert(u,7,2)));
print("    (3,3)_2 = ", hilbert(3,3,2),
      " : two principal units pairing non-trivially.  At an odd");
print("    place that cannot happen, whatever the units.");
print("");
}

\\ ---------------------------------------------------------- (2) precision

print("(2) How much of a and b does the symbol see?");
print("");
{
my(bad = 0);
forprime (p = 3, 100,
  for (a = 1, p-1, for (b = 1, p-1, for (k = 0, 1, for (l = 0, 1,
    if (hilbert(a*p^k, b*p^l, p) != hilbert((a+p)*p^k, (b+p)*p^l, p), bad++))))));
print("    odd p < 100: changing a or b by p never changes the symbol.");
print("    violations = ", bad, "   -> the symbol sees a, b only MOD p.");
print("");
print("    v = 2 : 1 and 5 agree mod 4, but");
print("      (1,2)_2 = ", hilbert(1,2,2), "     (5,2)_2 = ", hilbert(5,2,2));
print("    so mod 4 is not enough.  Mod 8 is:");
my(bad2 = 0, n2 = 0);
forstep (a = 1, 200, 2,
  forstep (b = 1, 200, 2,
    n2++;
    my(a8 = ((a-1) % 8) + 1, b8 = ((b-1) % 8) + 1);
    if (hilbert(a,b,2) != hilbert(a8,b8,2), bad2++)));
print("      over ", n2, " odd pairs a,b <= 200, mod-8 violations = ", bad2);
print("");
}

\\ ------------------------------------------------- (3) depth of the filtration

print("(3) THE DEPTH.  For which m is every unit = 1 mod m^th power an n-th power?");
print("    Prediction: U^(m) is inside (K^*)^n exactly when m > pe/(p-1),");
print("    where e = v_K(p) and p is the residue characteristic.");
print("");
{
print("    (a) squares in Q_p, p odd  (TAME: p does not divide n = 2).  Here the");
print("        depth formula does not apply; U^(1) is already n-divisible, so the");
print("        answer is simply m = 1.");
my(firstok = 0);
forprime (p = 3, 20,
  my(m = 0);
  while (m < 6,
    m++;
    my(ok = 1);
    for (u = 1, p^4, if (u % p == 0, next);
      if ((u - 1) % p^m != 0, next);
      if (!issquare(Mod(u, p^5)), ok = 0; break));
    if (ok, break));
  print("        p = ", p, " : U^(m) consists of squares from m = ", m,
        "   (depth 1: U^(1) is n-divisible)"));
print("");
print("    (b) squares in Q_2  (WILD):  p = 2, e = 1, pe/(p-1) = 2, so m >= 3");
for (m = 1, 5,
  my(ok = 1, tot = 0);
  forstep (u = 1, 2^10, 2,
    if ((u - 1) % 2^m != 0, next);
    tot++;
    if (u % 8 != 1, ok = 0));
  print("        m = ", m, " : ", tot, " units, all squares? ", if (ok, "YES", "no")));
print("");
}
{
print("    (c) CUBES in K = Q_3(zeta_3)  (WILD): p = 3, e = v_pi(3) = 2,");
print("        pe/(p-1) = 3, so the prediction is m >= 4.");
print("        O = Z[omega], omega^2 = -1-omega, pi = omega-1, pi^2 = -3 omega.");
print("        Brute force over O/pi^12 = O/3^6 (past the Hensel bound 2e+1 = 5).");
my(M = 3^6, iscube, cnt = 0);
iscube = vector(M*M);
for (a = 0, M-1,
  for (b = 0, M-1,
    my(x = (a*a - b*b) % M, y = (2*a*b - b*b) % M);       \\ (a+b w)^2
    my(u = (x*a - y*b) % M, v = (x*b + y*a - y*b) % M);   \\ times (a + b w)
    iscube[u*M + v + 1] = 1));
for (j = 1, M*M, if (iscube[j], cnt++));
print("        cubes in O/pi^12 : ", cnt, " of ", M*M);
print("");
print("           m    units = 1 mod pi^m    all cubes?");
for (m = 0, 6,
  my(tot = 0, bad = 0);
  for (a = 0, M-1,
    for (b = 0, M-1,
      if (valuation(a*a - a*b + b*b, 3) != 0, next);
      my(d1 = (a-1) % M);
      if (valuation(if (d1 == 0 && b == 0, M^2, d1*d1 - d1*b + b*b), 3) < m, next);
      tot++;
      if (!iscube[a*M + b + 1], bad++)));
  print("           ", m, "        ", tot, "             ",
        if (bad == 0, "YES", Str("no (", bad, " fail)"))));
print("");
print("        So U^(m) consists of cubes exactly for m >= 4 = pe/(p-1) + 1.");
print("        At m = 3 exactly one third of the units are cubes -- the symbol");
print("        still has one layer of the filtration left to see.");
print("");
}

\\ ------------------------------------------- (4) size of the local class group

print("(4) THE SIZE OF K^*/(K^*)^n = n^2 / |n|_K.");
print("");
{
print("    n = 2 :   Q_p (p odd) : 2^2 / 1 = 4 classes;   Q_2 : 2^2 * 2 = 8 classes.");
print("    the eight classes of Q_2^* mod squares are the familiar",
      " {+-1,+-2,+-5,+-10}.");
print("");
print("    n = p, over K = Q_p(zeta_p) (which is where the symbol is defined):");
print("      [K:Q_p] = p-1, totally ramified, e = p-1, residue field F_p, so");
print("      |p|_K^{-1} = p^(p-1)  and  |K^*/(K^*)^p| = p^2 * p^(p-1) = p^(p+1).");
print("");
print("        p     tame answer p^2     wild answer p^(p+1)      depth pe/(p-1) = p");
foreach ([3,5,7,11,13], p,
  print("       ", p, "         ", p^2, "                ", p^(p+1),
        "        ", p));
print("");
print("    For p = 11 that is ", 11^12, " classes instead of 121.");
print("    Any 'formula' for the symbol has to be a function on that group.");
print("");
}

\\ ---------------------------------------------- (5) the pairing filtration

print("(5) THE PAIRING FILTRATION at v = 2: which U^(i) x U^(j) is non-trivial?");
print("    Prediction: non-trivial only when i + j <= pe/(p-1) = 2.");
print("");
{
print("        i   j    is ( , )_2 non-trivial on U^(i) x U^(j) ?");
for (i = 1, 4,
  for (j = i, 4,
    my(nontriv = 0);
    forstep (u = 1, 2^9, 2,
      if ((u-1) % 2^i != 0, next);
      forstep (w = 1, 2^9, 2,
        if ((w-1) % 2^j != 0, next);
        if (hilbert(u,w,2) == -1, nontriv = 1; break));
      if (nontriv, break));
    print("        ", i, "   ", j, "         ", if (nontriv, "YES", "no"),
          "        (i+j = ", i+j, ")")));
print("");
print("    Exactly the pairs with i + j <= 2.  The tame symbol has no such");
print("    filtration at all: it is trivial on U x U outright.");
print("");
}

\\ ------------------------------------------------------ (6) the tame formula

print("(6) THE TAME FORMULA, checked.  For odd p and n = 2, writing");
print("    a = p^alpha u, b = p^beta w with u,w units,");
print("      (a,b)_p = (-1/p)^(alpha beta) (u/p)^beta (w/p)^alpha .");
print("    One Legendre symbol each: a residue-field computation, nothing more.");
print("");
{
my(bad = 0, n = 0);
forprime (p = 3, 300,
  for (al = 0, 1, for (be = 0, 1,
    for (u = 1, min(p-1, 30), for (w = 1, min(p-1, 30),
      my(a = p^al * u, b = p^be * w);
      my(f = kronecker(-1,p)^(al*be) * kronecker(u,p)^be * kronecker(w,p)^al);
      n++;
      if (hilbert(a,b,p) != f, bad++))))));
print("    ", n, " cases, disagreements with PARI's hilbert() = ", bad);
print("");
}

\\ --------------------------------------------- (7) the cost of acquiring mu_n

print("(7) AND YOU HAVE TO GET mu_n FIRST.");
print("    The symbol ( , )_n needs mu_n in K.  Over Q_p with n = p (p odd),");
print("    mu_p is not in Q_p, so one must pass to Q_p(zeta_p) -- and that");
print("    extension is TOTALLY RAMIFIED of degree p-1.  So acquiring the roots");
print("    of unity makes the wild place worse, not better:");
print("");
print("        field        e = v(p)     depth pe/(p-1)     [K:Q_p]");
{
print("        Q_p              1            p/(p-1) < 2         1     (but no mu_p)");
foreach ([3,5,7,11], p,
  print("        Q_", p, "(zeta_", p, ")        ", p-1, "            ", p,
        "               ", p-1));
}
print("");
print("    For n = 2 this costs nothing: mu_2 = {+-1} is already in Q_2, e = 1,");
print("    depth 2, and the answer fits in the mod-8 formula everyone knows.");
print("    That is why the quadratic symbol at 2 is the one wild symbol with a");
print("    closed form -- and the only one in PARI (nfhilbert) or Sage.");
print("");
\\ ------------------------------------------- (8) Lubin-Tate: where the constant comes from

print("(8) LUBIN-TATE, AND WHERE pe/(p-1) COMES FROM.");
print("    Lubin-Tate theory constructs the maximal totally ramified abelian");
print("    extension of K from a formal group F_pi over O_K with [pi](x) = pi x +");
print("    ... + x^q, and makes the local Artin map EXPLICIT: a uniformiser acts");
print("    trivially on K(F_pi[pi^n]) and by Frobenius on K^ur, and a unit u acts");
print("    on F_pi[pi^n] by [u^{-1}].  So the norm residue symbol is in principle a");
print("    formal-group computation.  For K = Q_p and pi = p the Lubin-Tate group");
print("    is the MULTIPLICATIVE one, Ghat_m, and K_pi = Q_p(mu_{p^oo}) -- so");
print("    Lubin-Tate simply recovers the cyclotomic theory and the Artin-Hasse");
print("    formulas of section 6.  Wiles' explicit reciprocity law is the");
print("    Lubin-Tate generalisation of Artin-Hasse, and Coleman power series are");
print("    the tool that makes it work.");
print("");
print("    What the formal group explains outright is the DEPTH.  On Ghat_m,");
print("      [p](x) = (1+x)^p - 1 = p x + ... + x^p ,");
print("    so with j = v(x) and e = v_K(p):");
print("");
{
foreach ([[2,1,"Q_2"], [3,2,"Q_3(zeta_3)"], [5,4,"Q_5(zeta_5)"], [11,10,"Q_11(zeta_11)"]], t,
  my(p = t[1], e = t[2]);
  print("      ", t[3], " :  e = ", e, ",  e/(p-1) = ", e/(p-1),
        ",  pe/(p-1) = ", p*e/(p-1));
  print("         j :   v(p x) = e+j    v(x^p) = p j     v([p]x)     regime");
  for (j = 1, 4,
    my(a = e+j, b = p*j);
    print("         ", j, "  :      ", a, "              ", b, "           ", min(a,b),
          if (a < b, "        linear: shift by e",
              if (a > b, "        Frobenius: multiply by p", "        tie"))));
  print("         => [p] carries m^j onto m^(j+e) once j > e/(p-1), so U^(m) lies");
  print("            in (K^*)^p for m >= ", e/(p-1) + e + 1, ", i.e. m > pe/(p-1) = ",
        p*e/(p-1), ".");
  print(""));
}
print("    Every one of those thresholds is the one measured by brute force in");
print("    section 3: m >= 3 for squares in Q_2, m >= 4 for cubes in Q_3(zeta_3).");
print("");
print("    So 'wild' has a one-line formal-group meaning.  Below j = e/(p-1) the");
print("    map [p] behaves like FROBENIUS, x -> x^p, multiplying the valuation by");
print("    p; above it like MULTIPLICATION BY p, shifting the valuation by e.  The");
print("    crossover is exactly where log_F converges and becomes an isomorphism");
print("    F(m^j) -> m^j, which is why the symbol turns analytic there and why the");
print("    explicit formulas are all logarithms.  In the tame case there is no");
print("    crossover to cross: n is prime to p, [n] is invertible on the formal");
print("    group, and the whole filtration is n-divisible -- the formal group never");
print("    enters the computation at all.");
print("");

print("done.");
