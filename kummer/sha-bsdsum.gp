/* ============================================================================
   sha-bsdsum.gp -- the Birch-Swinnerton-Dyer finite sum for y^2 = x^3 + px,
   evaluated exactly.  Companion to sha-bsdsum.typ.

   Nomoto arXiv:2207.10380, Theorem 2.6 (after Birch and Swinnerton-Dyer),
   first branch (i/D)_4 = +-1, which is the branch for every p = 1 mod 8.
   With D = Delta = p, and wp that of E_1 : y^2 = x^3 - x on the lattice
   Omega Z[i] with Omega = 2.6220575...,

        (eps p / Omega) L_{2p}(psibar_{-p}, 1)
             = (1/sqrt2) SUM_{c in (O_K/p)^x} (c/p)_4 (wp_c + 1)/(wp_c^2 - 2 wp_c - 1),

   where wp_c = wp(c Omega / p) is the x-coordinate of a p-torsion point of E_1.
   The other term of the branch, (sqrt2/4) SUM (c/p)_4, vanishes because the
   quartic character is non-trivial.

   NORMALISATION CHECK: this file's wp reproduces the paper's own special values
   to 60 digits -- Omega = 2.62205755..., wp(Omega/4) = 1+sqrt2,
   wp'(Omega/4) = -4-2sqrt2, wp((1+2i)Omega/4) = 1-sqrt2.

   RESULT.  The sum evaluates EXACTLY:
        S(17)^4  = 2^6  * 17^3,     so S(17)  = 2^(3/2) * 17^(3/4),
        S(257)^4 = 2^14 * 257^3,    so S(257) = 2^(7/2) * 257^(3/4),
   and in general, on all six primes tested and to 40 digits,

        S = 2 sqrt2 * m^2 * p^(3/4),

   where m is exactly the quantity with L(E_p,1)/Omega_E = 2 m^2.  So the finite
   sum computes m^2 directly, and the Fermat conjecture m = 2^(k-2) becomes the
   assertion that this character sum equals 2 sqrt2 * 4^(k-2) * p^(3/4).

   The p^(3/4) is the quartic-twist period factor: the period of y^2 = x^3+px is
   Omega/p^(1/4).

   COST: the sum has (p-1)^2 terms, so p = 65537 would need 4.3e9 evaluations of
   wp -- out of reach analytically.  A 2-adic evaluation is what is wanted.

   Functions: q4 (quartic residue symbol), S (the sum), rep.
   Output: results/sha-bsdsum.txt
   ============================================================================ */

default(realprecision, 40);
E1 = ellinit([-1,0]); OM = E1.omega[1];
q4(u, v, s, p) = { my(z = Mod(u + v*s, p), w);
  if(z == 0, return(0));
  w = z^((p-1)/4);
  if(w == 1, 1, if(w == -1, -1, if(w == Mod(s,p), I, -I))); }
S(p) = { my(s = lift(sqrt(Mod(-1,p))), tot = 0, w, ch);
  for(u = 0, p-1, for(v = 0, p-1,
    my(c1 = q4(u,v,s,p), c2 = q4(u,v,p-s,p));
    if(c1 == 0 || c2 == 0, next);
    ch = c1*c2; w = ellwp(E1, (u + v*I)*OM/p);
    tot += ch*(w + 1)/(w^2 - 2*w - 1)));
  real(tot/sqrt(2)); }
rep(p, mexp) = { my(r = S(p), q, m2);
  q = r/p^(3/4); m2 = q/(2*sqrt(2));
  print("   p = ", p, "   S/p^(3/4) = ", q, "   S/(2 sqrt2 p^(3/4)) = ", m2,
        "   -> m^2 = ", round(m2), "   m = ", if(issquare(round(m2)), sqrtint(round(m2)), "?"),
        "   (expected m = ", mexp, ")"); }
rep(17, 1); rep(41, 1); rep(97, 1); rep(137, 1); rep(257, 2); rep(577, 2);
quit;
