---
title: Understanding Simulation and Zero-Knowledge
date: 2020-05-07 10:00:00
published: false
sidebar:
    nav: cryptomat
---

<!-- TODO:

Interesting subtleties to cover:

1. signatures are zkpoks of a secret key or not?

2. Simulation for deniable authentication should be 'straight line' (no rewinding allowed for some reason) according to Gennaro's presentation.
See:

 - straight line extraction[^BWN15e]: "An extractor is straight-line if it only
 sees a single execution of the prover (and learns the RO queries/answers that the
 prover makes), or rewinding if it is allowed to launch and interact with further
 copies of the prover (with the same coins used to produce the statement) before
 returning a witness"
 - Pass's paper on why: https://iacr.org/archive/crypto2003/27290315/27290315.pdf
 - https://www.dmi.unict.it/diraimondo/web/wp-content/uploads/papers/deniability-ake.pdf

3. NIZK versus interactive ZK: both have simulators, no? But NIZK guarantees are  weaker since you can send proof to others and convince them. How is the simulation different?

4. witness indistinguishability

5. adaptive ZK

-->

---

{% include bib.md %}
