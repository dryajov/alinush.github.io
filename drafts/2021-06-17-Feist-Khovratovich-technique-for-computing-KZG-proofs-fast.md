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

First, read:

 - [Basics of polynomials](/2020/03/16/polynomials-for-crypto.html)
 - The [Discrete Fourier Transform (DFT)](https://en.wikipedia.org/wiki/Discrete_Fourier_transform_(general)) for $n$th roots of unity
 - [KZG polynomial commitments](/2020/05/06/kzg-polynomial-commitments.html)

Notation:

 - $g$ generates a "bilinear" group $\Gr$ of prime order $p$, endowed with a _bilinear map_ or _pairing_ $e : \Gr\times\Gr\rightarrow\Gr_T$
    + we use multiplicative notation here: i.e., $g^a$ denotes composing $g$ with itself $a$ times
 - there exists a primitive $n$th root of unity $\omega$, where $n$ is a power of two
 - we have $q$-SDH public parameters $\left(g, g^\tau,g^{\tau^2},\dots,g^{\tau^q}\right)$, for $q \le n$
 - we work with polynomials in $\Zp[X]$ of degree $\le n$

## Refresher: Computing $n$ different KZG proofs

Let $f(X)$ be a polynomial with coefficients $f_i$:

\begin{align}
    f(X) &= f_m X^m + f_{m-1} X^{m-1} + \cdots f_1 X + f_0\\\\\
         &= \sum_{i\in[0,m]} f_i X^i
\end{align}

First, [recall that](/2020/05/06/kzg-polynomial-commitments.html) a KZG **evaluation proof** $\pi_i$ for $f(\omega^i)$ is a KZG commitment to a **quotient polynomial** $Q_i(X) = \frac{f(X) - f(\omega^i)}{X-\omega^i}$:
\begin{align}
    \pi_i = g^{Q_i(\tau)} = g^{\frac{f(\tau) - f(\omega^i)}{\tau-\omega^i}}
\end{align}

Second, what if we want to compute **all** $\pi_i, i\in[0, n)$?

If done naively, each $\pi_i$ takes $O(m)$ time, so all $\pi_i$'s take $O(nm)$, which is **expensive!**

{: .warning}
**Lower bound?** 
Indeed, isn't this $O(nm)$ time complexity inherent? After all, to compute $\pi_i$ don't we first need to compute $Q_i(X)$, which takes $O(m)$ time?

Fortunately, Feist and Khovratovich observe that the $Q_i(X)$'s are algebraically-related and so are their KZG commitments $\pi_i$!
As a result, they observe that computing all $\pi_i$'s does **not** require computing all $Q_i$'s.

Below, we explain how their faster, $O(n\log{n})$-time technique works!

An important **caveat** is that their technique relies on the evaluation points being $\omega^0,\dots,\omega^{n-1}$. 

## Quotient polynomials and their coefficients

To understand how the $\pi_i$'s relate to one other, let us look at the coefficients of $Q_i(X)$.

We can show that when dividing $f$ (of degree $m$) by $(X-\omega^i)$ we obtain a _quotient polynomial_ with coefficients $t_0, t_1, \dots, t_{m-1}$ such that:
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

## The relationship between KZG proofs

Next, let us expand Equations \ref{eq:div-coeffs-1} and \ref{eq:div-coeffs-2} above and get a better sense of the relationship between KZG quotient polynomials:
\begin{align}
        \color{green}{t_{m-1}} &= \underline{f_m}\\\\\
        \color{blue}{t_{m-2}} &= f_{m-1} + \omega^i \cdot \color{green}{t_{m-1}} =\\\\\
                &= \underline{f_{m-1} + \omega^i \cdot f_m}\\\\\
        \color{red}{t_{m-3}} &= f_{m-2} + \omega^i \cdot \color{blue}{t_{m-2}}\\\\\
                &= f_{m-2} + \omega^i \cdot (f_{m-1} + \omega^i \cdot f_m)\\\\\
                &= \underline{f_{m-2} + \omega^i \cdot f_{m-1} + \omega^{2i} \cdot f_m}\\\\\
        t_{m-4} &= f_{m-3} + \omega^i \cdot \color{red}{t_{m-3}}\\\\\
                &= f_{m-3} + \omega^i \cdot (f_{m-2} + \omega^i \cdot f_{m-1} + \omega^{2i} \cdot f_m)\\\\\
                &= \underline{f_{m-3} + \omega^i \cdot f_{m-2} + \omega^{2i} \cdot f_{m-1} + \omega^{3i} \cdot f_m}\\\\\ 
                &\hspace{.55em}\vdots\\\\\
        %  t_{j} &= f_{j+1} + \omega^i \cdot t_{j+1}, \forall j \in [0, m-1)\\\\\
        %        & \vdots\\\\\
            t_1 &= \underline{f_2 + \omega^i \cdot f_3 + \omega^{2i} \cdot f_4 + \dots + \omega^{(m-2)i} \cdot f_m}\\\\\
            t_0 &= \underline{f_1 + \omega^i \cdot f_2 + \omega^{2i} \cdot f_3 + \dots + \omega^{(m-1)i} \cdot f_m}
\end{align}
As you can see above, the quotient polynomial $Q_i(X)$ obtained when dividing $f(X)$ by $X-\omega^i$ is:
\begin{align}
    Q_i(X) &= f_m \cdot X^{m-1} + {}\\\\\
           &+ \left(f_{m-1} + \omega^i \cdot f_m\right) \cdot X^{m-2} + {}\\\\\
           &+ \left(f_{m-2} + \omega^i \cdot f_{m-1} + \omega^{2i} \cdot f_m\right) \cdot X^{m-3} + {}\\\\\
           &+ \left(f_{m-3} + \omega^i \cdot f_{m-2} + \omega^{2i} \cdot f_{m-1} + \omega^{3i} \cdot f_m\right) \cdot X^{m-4} + {}\\\\\ 
           &+ \dots + {}\\\\\ 
           &+ \left(f_2 + \omega^i \cdot f_3 + \omega^{2i} \cdot f_4 + \dots + \omega^{(m-2)i} \cdot f_m\right) \cdot X + {}\\\\\
           &+ \left(f_1 + \omega^i \cdot f_2 + \omega^{2i} \cdot f_3 + \dots + \omega^{(m-1)i} \cdot f_m\right)
\end{align}
Factoring out the roots of unity, we can rearrange this as follows:
\begin{align}
    Q_i(X) &= \left(f_m X^{m-1} + f_{m-1} X^{m-2} + \dots + f_1\right) (\omega^i)^0 + {}\\\\\
           &+ \left(f_m X^{m-2} + f_{m-1} X^{m-3} + \dots + f_2\right) (\omega^i)^1 + {}\\\\\
           &+ \left(f_m X^{m-3} + f_{m-1} X^{m-4} + \dots + f_3\right) (\omega^i)^2 + {}\\\\\
           &+ \dots + {}\\\\\
           &+ \left(f_m X + f_{m-1}\right) (\omega^i)^{m-2} + {}\\\\\
           &+ \left(f_m \right) (\omega^i)^{m-1}
\end{align}
Baptising the polynomials above as $H_j(X)$, we can rewrite as:
\begin{align}
    Q_i(X) &\bydef H_1(X) (\omega^i)^0 + {}\\\\\
           & + H_2(X) (\omega^i)^1 + {}\\\\\
           & + \dots + {}\\\\\
           & + H_m(X) (\omega^i)^{m-1}\Leftrightarrow\\\\\
    Q_i(X) &= \sum_{k=0}^{m-1} H_{j+1}(X) \cdot (\omega^i)^k
\end{align}

{: .error}
**Note:** At this point, it is not helpful to write down a closed form formula for $H_j(X)$, but we'll return to it later.

Next, let:
\begin{align}
    h_j = g^{H_j(\tau)},\forall j\in[m]
\end{align}
...denote a KZG commitment to $H_j(X)$.
(We are ignoring for now the actual closed-form formula for the $H_j$'s.)

Recalling that
<!--\begin{align}-->
$$\pi_i=g^{Q_i(\tau)}$$
<!--\end{align}-->
denotes a KZG proof for $\omega^i$, observe that:
\begin{align}
    \label{eq:pi-dft-like}
    \pi_i = \prod_{j=0}^{m-1} \left(h_{j+1}\right)^{(\omega^i)^j}, \forall i\in[0,n)
\end{align}

Finally, taking a close look at Equation \ref{eq:pi-dft-like} above, note that it is actually a **Discrete Fourier Transform (DFT)** on the $h_j$'s!
Specifically, we can rewrite it as:
\begin{align}
    [ \pi_0, \pi_1, \dots, \pi_{n-1} ] = \mathsf{DFT}(h_1, h_2, \dots, h_m, h_{m+1},\dots, h_n)
\end{align}
Here, the extra $h_{m+1},\dots,h_n$ (if any) are just commitments to the zero polynomials: i.e., they are the identity element in $\Gr$.

{: .info}
**Time complexity:** Ignoring the time to compute the $h_j$ commitments, which we have not discussed, note that the DFT above would only take $O(n\log{n})$ time!

This summarizes the **Feist-Khovratovich (FK)** technique!

The key idea was that KZG quotient polynomial commitments are actually related, when the evaluation points are roots of unity (see Equation \ref{eq:pi-dft-like}).
In particular, these commitments are the output of a single DFT, which can be computed in quasilinear time!

However, **one key challenge remains**, which we address next: computing the $h_j$ commitments.

## Computing the $h_j = g^{H_j(\tau)}$ commitments 

<!--
where:
\begin{align}
    H_j(X) \bydef \sum_{k=j}^m f_{k} X^{k-j}, \forall j\in[1,m]
\end{align}
-->
<!--
    Sanity check:
    H_1(X) = f_1 X^{1-1} + f_2 X^{2-1} + f_3 X^{3-1} + \dots + f_m X^{m-1}
    H_2(X) = f_2 X^{2-2} + f_3 X^{3-2} + f_4 X^{4-2} + \dots + f_m X^{m-2}
    \vdots
    H_j(X) = \prod_{k = j}^m f_k X^{k-j}
    \vdots
    H_{m-1}(X) = f_{m-1} X^{(m-1) - (m-1)} f_m X^{m-(m-1)} = f_{m-1} + f_m X
    H_m(X) = f_m X^{m-m} = f_m
-->

<!--We can regard the equation above as an **inner product**:
\begin{align}
    Q_i(X) \bydef [ H_1(X),\dots, H_m(X) ] \cdot [ (\omega^i)^0, \dots, (\omega^i)^{m-1} ]^\top
\end{align}-->

<!--
\begin{align}
    \pi_i &= \left(\left(g^{\tau^{m-1}}\right)^{f_m} \left(g^{\tau^{m-2}}\right)^{f_{m-1}}  + \dots + f_1\right) (\omega^i)^0 + {}\\\\\
          &+ \left(f_m X^{m-2} + f_{m-1} X^{m-3} + \dots + f_2\right) (\omega^i)^1 + {}\\\\\
          &+ \left(f_m X^{m-3} + f_{m-1} X^{m-4} + \dots + f_3\right) (\omega^i)^2 + {}\\\\\
          &+ \dots + {}\\\\\
          &+ \left(f_m X + f_{m-1}\right) (\omega^i)^{m-2} + {}\\\\\
          &+ \left(f_m \right) (\omega^i)^{m-1}
\end{align}
-->


{: .error}
**TODO:** Continue.

---

{% include refs.md %}

[poly-division]: https://en.wikipedia.org/wiki/Polynomial_long_division#Pseudocode
