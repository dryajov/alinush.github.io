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
**tl;dr:** Given a polynomial $f(X)$ of degree $m$, can we compute all $n$ [KZG](/2020/05/06/kzg-polynomial-commitments.html) proofs for $f(\omega^k), k\in[0,n-1]$ in $O(n\log{n})$ time, where $\omega$ is a primitive $n$th root of unity?
Dankrad Feist and Dmitry Khovratovich give a resounding 'yes!'

<!--more-->

<p hidden>$$
\def\Adv{\mathcal{A}}
\def\Badv{\mathcal{B}}
\def\vect#1{\mathbf{#1}}
%\definecolor{myBlueColor}{HTML}{268BD2}
%\definecolor{myPinkColor}{HTML}{D33682}
%\definecolor{myGreenColor}{HTML}{859900}
%\def\mygreen#1{\color{myGreenColor}{#1}}
%\def\mygreen#1{\color{green}{#1}}
%\newcommand{\myblue}[1]{\textcolor{myBlueColor}{#1}}
%\newcommand{\mypink}[1]{\textcolor{myPinkColor}{#1}}
$$</p>

## Preliminaries

Assume:

 - $g$ generates a "bilinear" group $\Gr$ of prime order $p$, endowed with a pairing $e : \Gr\times\Gr\rightarrow\Gr_T$
 - there exists a primitive $n$th root of unity $\omega$
 - we have $q$-SDH public parameters $g, g^\tau,g^{\tau^2},\dots,g^{\tau^q}$
 - we work with polynomials in $\Zp[X]$ of degree $\le n$

## Refresher: Computing $n$ different KZG proofs

Let $f(X)$ be a polynomial with coefficients $f_i$:

\begin{align}
    f(X) &= f_m X^m + f_{m-1} X^{m-1} + \cdots f_1 X + f_0\\\\\
         &= \sum_{i\in[0,m]} f_i X^i
\end{align}

First, [recall that](/2020/05/06/kzg-polynomial-commitments.html) a KZG **evaluation proof** $\pi_i$ for $f(\omega^i)$ is a KZG commitment to a **quotient polynomial** $q_i(X) = \frac{f(X) - f(\omega^i)}{X-\omega^i}$:
\begin{align}
    \pi_i = g^{q_i(\tau)} = g^{\frac{f(\tau) - f(\omega^i)}{\tau-\omega^i}}
\end{align}

Second, what if we want to compute **all** $\pi_i, i\in[0, n)$?
If done naively, this takes $O(m)$ time per $\pi_i$, so $O(nm)$ for all $i$.

{: .warning}
Indeed, this $O(nm)$ time complexity _appears_ to be inherent, since each $q_i(X)$ polynomial is of size $O(m)$ and in order to commit to it one would think we first need to compute it.

Fortunately, Feist and Khovratovich observe that the $q_i(X)$'s are algebraically-related and so are their KZG commitments $\pi_i$!
As a result, they observe that computing all $\pi_i$'s does not require computing all $q_i$'s.
This way, they replace the $O(nm)$ overhead with something much faster: $O(n\log{n})$.

An important **caveat** is that their technique relies on the evaluation points being $\omega^0,\dots,\omega^{n-1}$. 

## The relationship between KZG proofs

To understand how the $\pi_i$'s relate to one other, let us look at the coefficients of $q_i(X)$.

We can show that when dividing $f$ (of degree $m$) by $(X-\omega^i)$ we obtain a quotient polynomial with coefficients $t_0, t_1, \dots, t_{m-1}$ such that:
\begin{align}
        \label{eq:div-coeffs-1}
        t_{m-1} &= f_m\\\\\
        %t_{m-2} &= f_{m-1} + \omega^i \cdot f_m\\\\\
        %t_{m-3} &= f_{m-2} + \omega^i \cdot t_{m-2}\\\\\
        %        &= f_{m-2} + \omega^i \cdot (f_{m-1} + \omega^i \cdot f_m)\\\\\
        %        &= f_{m-2} + \omega^i \cdot f_{m-1} + \omega^{2i} \cdot f_m\\\\\
        %t_{m-4} &= f_{m-3} + \omega^i \cdot t_{m-3}\\\\\
        %        &= f_{m-3} + \omega^i \cdot (f_{m-2} + \omega^i \cdot f_{m-1} + \omega^{2i} \cdot f_m)\\\\\
        %        &= f_{m-3} + \omega^i \cdot f_{m-2} + \omega^{2i} \cdot f_{m-1} + \omega^{3i} \cdot f_m\\\\\ 
        %        & \vdots\\\\\
        \label{eq:div-coeffs-2}
          t_{j} &= f_{j+1} + \omega^i \cdot t_{j+1}, \forall j \in [0, m-1)
        %        & \vdots\\\\\
        %    t_0 &= f_1 + \omega^i \cdot f_2 + \omega^{2i} f_3 + \dots + \omega^{m-1} f_m
\end{align}
Note that the $t_i$'s are a function of $f_m, f_{m-1},\dots, f_1$, but not of $f_0$!

{: .info}
<details>
 <summary>
  <b style="color: #f5222d">Proof:</b> One could prove by induction that the coefficients above are correct.
  However, it's easiest to take an example and convince yourself, as shown below for $m=4$.
 </summary>

 <div style="margin-left: .3em; border-left: .15em solid #f5222d; padding-left: .5em;"><p>
  Indeed, the quotient obtained when dividing $f(X) = f_3 X^3 + f_2 X^2 + \dots + f_0$ by $X-\omega^i$ exactly matches Equations \ref{eq:div-coeffs-1} and \ref{eq:div-coeffs-2} above:
  <!-- WARNING: No support for cline in MathJax, so that's why this is a .png -->
  <div align="center">
   <a href="/pictures/fk-division-example.png">
    <img style="width:95%" src="/pictures/fk-division-example.png" />
   </a>
  </div>
  Specifically, the quotient's coefficients, as expected, are:
  \begin{align}
    t_2 &= \color{green}{f_3}\\
    t_1 &= f_2 + \omega^i t_2\\
        &= \color{blue}{f_2 + \omega^i f_3}\\
    t_0 &= f_1 + \omega^i t_1 = f_1 + \omega^i \cdot (f_2 + \omega^i f_3)\\
        &= \color{pink}{f_1 + \omega^i f_2 + \omega^{2i} f_3}
  \end{align}
 </p></div>
</details>

{: .error}
**TODO:** Continue.

---

{% include refs.md %}

[poly-division]: https://en.wikipedia.org/wiki/Polynomial_long_division#Pseudocode
