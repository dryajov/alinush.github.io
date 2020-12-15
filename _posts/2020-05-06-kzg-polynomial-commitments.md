---
tags: polynomials polycommit cryptography
title: Kate-Zaverucha-Goldberg (KZG) Constant-Sized Polynomial Commitments
date: 2020-05-06 22:38:00
sidebar:
    nav: cryptomat
---

Kate, Zaverucha and Goldberg introduced a constant-sized polynomial commitment scheme in 2010[^KZG10b].
We refer to this scheme as **KZG** and quickly introduce it below.

**Prerequisites:**

 - Pairings (or bilinear maps)
 - [Polynomials](/2020/03/16/polynomials-for-crypto.html)

## Trusted setup

To commit to degree $\le \ell$ polynomials, need $\ell$-SDH public parameters:
$$(g,g^\tau,g^{\tau^2},\dots,g^{\tau^\ell}) = (g^{\tau^i})_{i\in[0,\ell]}$$

Here, $\tau$ is called the **trapdoor**.
These parameters should be generated via a distributed protocol[^BCGplus15]$^,$[^BGG18]$^,$[^BGM17] that outputs just the $g^{\tau^i}$'s and **forgets the trapdoor** $\tau$.

The public parameters are **updatable**: given $g^{\tau^i}$'s, anyone can update them to $g^{\alpha^i}$'s where $\alpha = \tau + \Delta$ by picking a random $\Delta$ and computing:
$$g^{\alpha^i} = \left(g^{\tau^i}\right)^{\Delta^i}$$

This is useful when you want to safely re-use a pre-generated set of public parameters, without trusting that nobody knows the trapdoor.

## Commitments

Commitment to $\phi(X)=\prod_{i\in[0,d]} \phi_i X^i$ is $c=g^{\phi(\tau)}$ computed as:

$$c=\prod_{i\in[0,\deg{\phi}]} \left(g^{\tau^i}\right)^{\phi_i}$$

Since it is just one group element, the commitment is _constant-sized_.

## Evaluation proofs

To prove an evaluation $\phi(a) = y$, a _quotient_ is computed in $O(d)$ time: 
$$q(X) = \frac{\phi(X) - y}{X - a}$$

Then, the _constant-sized_ **evaluation proof** is:

$$\pi = g^{q(\tau)}$$

Note that this leverages the [polynomial remainder theorem](/2020/03/16/polynomials-for-crypto.html#the-polynomial-remainder-theorem).

### Verifying an evaluation proof

A verifier who has the commitment $c=g^{\phi(\tau)}$ and the proof $\pi=g^{q(\tau)}$ can verify it in _constant-time_ using two pairings:

\begin{align}
e(c / g^y, g) &= e(\pi, g^\tau / g^a) \Leftrightarrow\\\\\
e(g^{\phi(\tau)-y}, g) &= e(g^{q(\tau)}, g^{\tau-a}) \Leftrightarrow\\\\\
e(g,g)^{\phi(\tau)-y} &= e(g,g)^{q(\tau)(\tau-a)}\\\\\
\phi(\tau)-y &= q(\tau)(\tau-a)
\end{align}

This effectively checks that $q(X) = \frac{\phi(X) - y}{X-a}$ by checking this equality holds for $X=\tau$.
In other words, it checks that the [polynomial remainder theorem](/2020/03/16/polynomials-for-crypto.html#the-polynomial-remainder-theorem) holds at $X\=\tau$.

## Batch proofs

Can prove multiple evaluations $(\phi(a_i) = y_i)_{i\in I}$ using a constant-sized **KZG batch proof** $\pi_I = g^{q_I(\tau)}$, where:

\begin{align}
\label{eq:batch-proof-rel}
q_I(X) &=\frac{\phi(X)-R_I(X)}{A_I(X)}\\\\\
A_I(X) &=\prod_{i\in I} (X - a_i)\\\\\
R_I(a_i) &= y_i,\forall i\in I\\\\\
\end{align}

$R_I(X)$ can be interpolated via Lagrange interpolation as:
$$R_I(X)=\sum_{i\in I} y_i \prod_{j\in I,j\ne i}\frac{X - a_j}{a_i - a_j}$$
<!-- TODO: Lagrange interpolation background in cryptomat -->

### Verifying a batch proof

The verifier who has the commitment $c$, the evaluations $(a_i, y_i)_{i\in I}$ and a batch proof $\pi_I=g^{q_I(\tau)}$ can verify them as follows.
 
 1. First, he interpolates the **accumulator polynomial** $$A_I(X)=\prod_{i\in I} (X-a_i)$$ via a subproduct tree in $O(\vert I\vert\log^2{\vert I\vert})$ time[^vG13ModernCh10].
    Then, commits to it as $g^{A_I(\tau)}$ in $O(\vert I \vert)$ time.
 2. Second, he interpolates $R_I(X)$ s.t. $R_I(a_i)=y_i,\forall i \in I$ via fast Lagrange interpolation in $O(\vert I\vert\log^2{\vert I\vert})$ time[^vG13ModernCh10].
    Then, commits to it as $g^{R_I(\tau)}$ in $O(\vert I \vert)$ time.
 3. Third, he checks Equation \ref{eq:batch-proof-rel} holds at $X=\tau$ using two pairings: $e(c / r, g) = e(\pi_I, a)$.

Note that:

\begin{align}
e(g^{\phi(\tau) / g^R_I(\tau)}, g) &= e(g^{q\_I(\tau)}, g^{A\_I(\tau)})\Leftrightarrow\\\\\
e(g^{\phi(\tau) - R_I(\tau)}, g) &= e(g,g)^{q_I(\tau) A_I(\tau)}\Leftrightarrow\\\\\
\phi(\tau) - R_I(\tau) &= q_I(\tau) A_I(\tau)
\end{align}

<!-- TODO: ## Commitment and proof homomorphism -->
<!-- TODO: ## Aggregation of proofs -->
<!-- TODO: ## Information-theoretic hiding -->

### References

[^KZG10b]: **Polynomial commitments**, by Kate, Aniket and Zaverucha, Gregory M and Goldberg, Ian, 2010, [[URL]](https://pdfs.semanticscholar.org/31eb/add7a0109a584cfbf94b3afaa3c117c78c91.pdf)
[^BCGplus15]: **Secure Sampling of Public Parameters for Succinct Zero Knowledge Proofs**, by E. Ben-Sasson and A. Chiesa and M. Green and E. Tromer and M. Virza, *in 2015 IEEE Symposium on Security and Privacy*, 2015
[^BGG18]: **A Multi-party Protocol for Constructing the Public Parameters of the Pinocchio zk-SNARK**, by Bowe, Sean and Gabizon, Ariel and Green, Matthew D., *in Financial Cryptography and Data Security*, 2019
[^BGM17]: **Scalable Multi-party Computation for zk-SNARK Parameters in the Random Beacon Model**, by Sean Bowe and Ariel Gabizon and Ian Miers, 2017, [[URL]](https://eprint.iacr.org/2017/1050)
[^vG13ModernCh10]: **Fast polynomial evaluation and interpolation**, by von zur Gathen, Joachim and Gerhard, Jurgen, *in Modern Computer Algebra*, 2013
