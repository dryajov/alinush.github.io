---
layout: article
tags:
- vector-commitments
title: Feist-Khovratovich technique for computing KZG proofs fast
#published: false
sidebar:
    nav: cryptomat
---

{: .info}
**tl;dr:** Given a polynomial $f(X)$ of degree $m$, can we compute all [KZG](/2020/05/06/kzg-polynomial-commitments.html) proofs for $f(\omega^k), k\in[0,n-1]$ in $O(n\log{n})$ time, where $\omega$ is a primitive $n$th root of unity?
Dankrad Feist and Dmitry Khovratovich give a resounding 'yes!'

<!--more-->

<p hidden>$$
\def\Adv{\mathcal{A}}
\def\Badv{\mathcal{B}}
\def\vect#1{\mathbf{#1}}
$$</p>

Let $f(X)$ be a polynomial:

\begin{align}
    f(X) &= f_m X^m + f_{m-1} X^{m-1} + \cdots f_1 X + f_0\\\\\
         &= \sum_{i\in[0,m]} f_i X^i
\end{align}

First, recall that a KZG proof for $f(\omega^i)$ is a KZG commitment to a **quotient polynomial** $q_i(X)$ defined as:
\begin{align}
    q_i(X) &= \frac{f(X) - f(\omega^i)}{X-\omega^i} = f(X) // (X-\omega_i)
\end{align}

{: .info}
The '//' notation means $q_i$ is obtained by dividing $f$ by $X-\omega_i$, since the constant $f(\omega^i)$ does not matter: it is just the remainder of the division.

Our task? We want to compute commitments to **all** $q_i(X), i\in[0, n)$!
Naively, this takes $O(m)$ time per $q_i$, so $O(nm)$ for all $i$.

{: .warning}
Indeed, this $O(nm)$ time complexity appears to be inherent, since each $q_i$ polynomial is of size $O(m)$ and in order to commit to it one would think we first need to compute it.

Fortunately, Feist and Khovratovich observe that these $q_i$'s are algebraically-related and so are their KZG commitments.
As a result, they observe that computing all commitments does not require computing the actual polynomials $q_i$.
This way, they can remove the $O(nm)$ overhead and replace it with something much faster.

This post explains how their faster technique works.

## The relationship between the quotient polynomials

Perhaps it is best to consider one example when $m=4$.
Let us divide $f(X) = f_4 X^4 + f_3 X^3 + \dots + f_0$ by $X-\omega^i$.
We will gradually build the quotient $q_i$.
(Recall that the remainder is $f(\omega^i)$.)

{: .error}
**TODO:** Continue.

<!--
\begin{array}{cccccccccccccccc}
& f_4 X^4 & + & f_3 X^3 & + & f_2 X^2 & + & f_1 X & + & f_0 & // & (X-\omega^i) & & = & & ???
\end{array}

\begin{array}{cccccccccccccccc}
&  f_4 X^4 & + & f_3 X^3 & + & f_2 X^2 & + & f_1 X & + & f_0 & // & (X-\omega^i) & & = & & f_4 X^3\\\\\
& -f_4 X^4 & - & \omega^i f_4 X^3 & & & & & & & &                                & &   & & \\\\\
\hline\\\\\
\end{array}
-->

---

{% include refs.md %}
