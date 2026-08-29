\\ mersenne-fermat-class.gp -- checks for mersenne-fermat-class.typ
\\
\\ Run from this directory:
\\     gp -q -s 8000000000 mersenne-fermat-class.gp < /dev/null \
\\         > results/mersenne-fermat-class.txt
\\
\\ Reconstructing Franz Lemmermeyer's comment on MathOverflow 151396: "There are
\\ similar phenomena in connection with class groups of quadratic fields whose
\\ discriminants are Mersenne or Fermat primes.  These things are not trivial."
\\ He was asked for a reference and did not give one.  Two readings are tested
\\ here; both are real, and they are different phenomena.

MERS = [3,5,7,13,17,19,31];
FERM = [1,2,3,4];

\\ ---------------------------------------------------------------- check 1
\\ Both families give PRIME discriminants, so genus theory makes h odd:
\\   M_p = 3 mod 4, so -M_p = 1 mod 4 is a discriminant, and it is prime;
\\   F_k = 1 mod 4 is itself a discriminant, and prime.
\\ By contrast disc -4F_k has TWO prime discriminant factors and h is even.

check1() =
{ my(bad = 0, n = 0, ev = 0);
  for (i = 1, #MERS,
    my(M = 2^MERS[i] - 1); n++;
    if (quaddisc(-M) != -M || qfbclassno(-M) % 2 == 0, bad++));
  for (i = 1, #FERM,
    my(F = 2^(2^FERM[i]) + 1); n++;
    if (quaddisc(F) != F || qfbclassno(F) % 2 == 0, bad++));
  for (i = 1, #FERM,
    my(F = 2^(2^FERM[i]) + 1);
    if (qfbclassno(-4*F) % 2 == 1, ev++));
  printf("  (1) -M_p and F_k are prime discriminants with h odd : %d wrong of %d\n", bad, n);
  printf("      and h(-4F_k) is even in all %d cases (2-rank 1) : %d odd\n", #FERM, ev);
};

\\ ---------------------------------------------------------------- check 2
\\ READING A, the Mersenne one.  In Q(sqrt(-M_p)) the element (1+sqrt(-M_p))/2
\\ has norm (1+M_p)/4 = 2^(p-2), so p_2^(p-2) is principal.  No smaller power is:
\\ x^2 + M_p y^2 = 2^(k+2) with y != 0 forces 2^p - 1 <= 2^(k+2), and y = 0 is
\\ impossible since p_2 != conj(p_2).  So [p_2] has order EXACTLY p-2 and
\\
\\                        (p - 2)  |  h(-M_p) ,
\\
\\ a lower bound growing like log_2 of the discriminant, forced by nothing but
\\ the binary shape of the number.

check2() =
{ my(bad = 0, bad2 = 0);
  printf("  (2) Mersenne: the forced cyclic subgroup\n");
  for (i = 1, #MERS,
    my(p = MERS[i], M = 2^p - 1, D = -M, h = qfbclassno(D), F, G, o);
    F = qfbprimeform(D, 2); G = F; o = 1;
    while (Vec(qfbred(G))[1] != 1, G = qfbcomp(G, F); o++);
    if (h % (p-2) != 0, bad++);
    if (o != p-2, bad2++);
    printf("      p=%-3d M_p=%-11d h=%-7d p-2=%-3d ord[p_2]=%-4d %-8s Cl=%s\n",
      p, M, h, p-2, o, if (o == p-2, "= p-2", "DIFFERS"), quadclassunit(D)[2]));
  printf("      ord[p_2] != p-2 : %d times;  (p-2) does not divide h : %d times\n",
         bad2, bad);
};

\\ ---------------------------------------------------------------- check 3
\\ READING B, the Fermat one.  A Fermat prime is F_k = 1^2 + (2^(2^(k-1)))^2, so
\\ the representation p = a^2 + b^2 that governs biquadratic residues is
\\ EXPLICIT: a = 1, b = 2^(2^(k-1)).  Every quartic symbol therefore collapses to
\\ a condition on k.  By cubic-residues.typ 6.3, 2 is a fourth power mod p iff
\\ 8 | b -- here iff 2^(k-1) >= 3, i.e. iff k >= 3.  And the 2-class group of
\\ Q(sqrt(-F_k)) jumps exactly there.

check3() =
{ my(bad = 0);
  printf("  (3) Fermat: explicit symbols, and where the 2-class group jumps\n");
  for (i = 1, #FERM,
    my(k = FERM[i], p = 2^(2^k) + 1, b = 2^(2^(k-1)),
       cl = quadclassunit(-4*p), h = cl[1], h2 = 2^valuation(h, 2),
       q4 = (Mod(2,p)^((p-1)/4) == 1));
    if ((b % 8 == 0) != q4, bad++);
    printf("      k=%d F_k=%-6d a=1 b=%-4d  2 a 4th power: %-3s (8|b: %-3s)  Cl(-4F_k)=%-7s 2-part=%d\n",
      k, p, b, if (q4, "yes", "no"), if (b % 8 == 0, "yes", "no"), Str(cl[2]), h2));
  printf("      the criterion 8|b agrees with the direct test : %d wrong\n", bad);
  printf("      2-part runs 2, 4, 16, 64 -- it skips 8, and the skip is at k=3,\n");
  printf("      exactly where 2 becomes a fourth power mod F_k\n");
};

\\ ---------------------------------------------------------------- check 4
\\ Lemmermeyer's own nearby subject: class numbers of the quartic field
\\ Q(p^(1/4)).  His theorem (see arXiv:1009.3990) is that p = 9 mod 16 forces
\\ h = 2 mod 4 there.  Fermat primes are 1 mod 16 for k >= 2, so it does not
\\ apply -- but the class number grows anyway.

check4() =
{ printf("  (4) the quartic fields Q(F_k^(1/4)) -- Lemmermeyer's own territory\n");
  for (i = 1, 3,
    my(k = FERM[i], p = 2^(2^k) + 1, K = bnfinit(x^4 - p, 1));
    printf("      k=%d p=%-6d  h(Q(p^(1/4))) = %-4d  Cl = %-7s p mod 16 = %d\n",
      k, p, K.no, Str(K.clgp[2]), p % 16));
  printf("      (k=4 omitted: bnfinit on x^4 - 65537 is slow)\n");
};

\\ ---------------------------------------------------------------- check 5
\\ How big is the Mersenne bound?  p-2 is about log_2 of the discriminant, while
\\ h is about its square root.  So the phenomenon is real but tiny: it is a
\\ foothold on an otherwise inaccessible quantity, not an estimate of it.

check5() =
{ printf("  (5) the size of the forced subgroup against the whole class number\n");
  for (i = 1, #MERS,
    my(p = MERS[i], M = 2^p - 1, h = qfbclassno(-M));
    printf("      p=%-3d  p-2 = %-4d  h = %-8d  h/(p-2) = %-9.1f  sqrt(M_p) = %.0f\n",
      p, p-2, h, h*1.0/(p-2), sqrt(M*1.0)));
};

\\ ---------------------------------------------------------------- check 6
\\ THE NEGATIVE CONTROL: the REAL field Q(sqrt(M_p)), discriminant 4M_p.
\\ Here 2 RAMIFIES rather than splits, so [p_2]^2 = 1 and no large cyclic
\\ subgroup can come from it.  And h is odd: disc = (-4)(-M_p) has two prime
\\ discriminant factors so the NARROW 2-rank is 1, while M_p = 3 mod 4 makes
\\ -1 a non-residue, so negative Pell is unsolvable, N(eps) = +1 and h+ = 2h.
\\ Hence the wide 2-rank is 0, and p_2 is actually PRINCIPAL.

check6() =
{ my(bad = 0);
  printf("  (6) the real fields Q(sqrt(M_p)) -- where the mechanism dies\n");
  for (i = 1, #MERS,
    my(p = MERS[i], M = 2^p - 1, K = bnfinit(x^2 - M, 1), P = idealprimedec(K,2)[1],
       v = bnfisprincipal(K, P, 0), triv, eps = quadunit(4*M), h = K.no);
    triv = (v == []~ || vecsum(Vec(v)) == 0);
    if (!triv || h % 2 == 0 || norm(eps) != 1, bad++);
    printf("      p=%-3d M_p=%-11d h=%-5d e(2)=%d f(2)=%d  N(eps)=%-3d h odd: %-3s [p_2] principal: %s\n",
      p, M, h, P.e, P.f, norm(eps), if (h % 2 == 1, "yes", "NO"), if (triv, "yes", "NO")));
  printf("      violations of (2 ramifies, h odd, N(eps)=+1, p_2 principal) : %d\n", bad);
};

\\ ---------------------------------------------------------------- check 7
\\ Where the size went.  By the class number formula the real field's h*R and
\\ the imaginary field's h are both of size sqrt(M_p) L(1,chi).  The imaginary
\\ field spends all of it on the class number; the real field spends nearly all
\\ of it on the REGULATOR, leaving h small and erratic.

check7() =
{ printf("  (7) the class number formula, and where each field spends it\n");
  for (i = 1, #MERS,
    my(p = MERS[i], M = 2^p - 1, cl = quadclassunit(4*M), h = cl[1], R = cl[4],
       hm = qfbclassno(-M));
    printf("      p=%-3d  h(+)=%-4d R=%-11.2f  h*R=%-11.1f   h(-M_p)=%-8d ratio %.2f   sqrt(M)=%.0f\n",
      p, h, R, h*R, hm, h*R/hm, sqrt(M*1.0)));
  printf("      h(+) runs 1,1,1,1,9,1,5 while h(-M_p) runs 1,3,5,55,285,255,19865;\n");
  printf("      h*R and h(-M_p) are the same size throughout.  h(+) > 1 happens\n");
  printf("      exactly where the regulator is anomalously SMALL (p=17: R=53 against\n");
  printf("      sqrt(M)=362), never where it is large (p=19: R=1421 > 724, h=1).\n");
};

\\ ------------------------------------------------------------------------ run

{
print("======================================================================");
print("mersenne-fermat-class.gp -- what Lemmermeyer's comment might mean");
print("");
check1();
print("");
check2();
print("");
check3();
print("");
check4();
print("");
check5();
print("");
check6();
print("");
check7();
print("");
print("Two different phenomena, both real.  For Mersenne discriminants the shape");
print("of the number forces a large cyclic subgroup of the class group, by an");
print("elementary norm computation.  For Fermat discriminants the shape instead");
print("makes the residue symbols that govern the 2-class group explicit, so the");
print("4-rank and 8-rank become computable conditions on k.  Both match the shape");
print("of the Sha question they were a comment on: what the special form of the");
print("prime gives you is the STRUCTURE, and never the SIZE.");
}
quit;
