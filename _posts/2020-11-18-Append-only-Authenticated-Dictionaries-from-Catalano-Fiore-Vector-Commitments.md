---
tags:
title: "Append-only Authenticated Dictionaries from Catalano-Fiore Vector Commitments"
published: false
---

<!-- TODO: Write an intro paragraph here -->

<!--more-->

## Our append-only AD for transparency logging

Our second contribution is an **append-only authenticated dictionary (AAD)**[^TBPplus19] from Catalano-Fiore VCs.
In an AAD scheme, the server can prove an append-only property holds between any two versions of the dictionary via an **append-only proof**.
Specifically, a client who has an old digest $d$ and a new digest $d'$ can be convinced that the new dictionary with digest $d'$ was obtained by only adding new key-value pairs to the dictionary with digest $d$.
In other words, the client is convinced that no keys were removed and no values were changed as the dictionary was updated.
This is very useful for building transparency logs for public-key distribution such as Google's Certificate Transparency (CT)[^ct] which is at the core of HTTPS security.
It is also useful for distributing software binaries securely[^FDPplus14].

Besides append-only proofs, our AAD must have a stronger security notion than our UAD and must support proving non-membership of keys that have no value in the dictionary.
We explain below how we change our UAD construction into an AAD.
Importantly, while these changes are not compatible with cross-incremental proof (dis)aggregation in our AAD, they do maintain _one hop_ proof aggregation.

### Security notions for ADs

As we mentioned initially, an interesting line of work on authenticated dictionaries from non-Merkle techniques already exists (see Table 1 in our paper[^TXN20e]).
However, all recent AD constructions were specifically designed for stateless validation[^BBF18]$^,$[^LGGplus20]$^,$[^AR20]$^,$[^Feis20Multi].
As a result, these constructions only satisfy a weaker security notion called **weak key binding**, which is sufficient for stateless validation, but not for transparency logs[^obs3].
We explain why _weak key binding_ does not suffice for transparency logs below and how a stronger notion called **strong key binding** suffices.

{: .warning}
**Word of caution:** Such security notions can be very subtle and probably warrant their own a blog post.
However, the discussion below should at least help you understand why transparency logs need a stronger notion.

#### Weak key binding

Roughly speaking, _weak key binding_ guarantees that an adversary cannot output a dictionary $D$ with digest $d$ and two _inconsistent_ proofs $\pi$ and $\pi'$ for key $k$ w.r.t. digest $d$ having two different values $v\ne v'$.
This closely models all successful adversaries in the stateless validation setting.
This is because, in this setting, the digest $d$ is always computed from a dictionary $D$ determined from an agreed-upon history of transactions!
In other words, in this setting we never have to worry about adversaries who output just an adversarially-generated digest $d$ together with the inconsistent proofs, but without the underlying dictionary $D$.
Indeed, such adversaries do not break the system because they cannot convince other validators to accept their digest $d$ without a valid sequence of transactions (i.e., without the dictionary $D$).

#### Strong key binding

But why is _weak key binding_ not sufficient in the transparency log setting?
Unlike the stateless validation setting, in transparency logs, clients are simply given a digest $d$ and they have no way to learn how it was produced since the log server is malicious and might hide details about the underlying dictionary $D$.
This is fundamentally different than the stateless setting where a digest $d$ is either known to be correctly produced from a dictionary $D$ (via consensus decree) or has been updated from a previous (correct) digest via a sequence of transactions.
As a result, in transparency logs, successful adversaries are less restricted: they need only output a digest $d$ and two inconsistent proofs, without having to output a dictionary that has that digest.
Roughly speaking, **strong key binding** guarantees that such adversaries cannot succeed.

At this point, an example of an AD that has _weak key binding_ but does not have _strong key binding_ should help clarify things.
My favorite example is a _sorted Merkle tree_, where each leaf stores a key-value pair and all leaves are sorted by the key.
(This is not a binary search tree, nor a prefix tree!)
Here's an example of such a Merkle tree for a dictionary with four keys $$\{b,d,e,p\}$$:

<div align="center"><img style="width:40%" src="/pictures/sorted-mht-correct.png" /></div>

To prove, say, that key $d$ has value $v_d$, a Merkle sibling path to $d$'s leaf is revealed.
To prove, say, that key $g$ is not in the tree, Merkle paths to the two adjacent leaves for $e$ and $p$ are revealed.
This way, the client is convinced that $g$ is not in the tree because it should have fallen in between $e$ and $p$'s leaves, which are adjacent.
(Some extra care has to be taken here to handle non-membership proofs for keys that would fall in the left-most leaf and right-most leaf in the tree.)

One can show this sorted Merkle tree **is** secure under _weak key binding_ assuming the hash function is collision resistant.
However, one can also show this scheme **is not** secure under _strong key binding_.
This is because an adversary can generate a malicious digest of an incorrectly sorted tree as follows:

<div align="center"><img style="width:40%" src="/pictures/sorted-mht-incorrect.png" /></div>

As a result, this adversary can prove that key $d$ is in the dictionary by showing a Merkle path to $d$'s leaf.
Importantly, this adversary can also prove that $d$ is **not** in the dictionary by showing Merkle paths to the two adjacent leaves for $b$ and $e$ in between which $d$ is supposed to be.
In other words, the adversary was able to craft a malicious digest $d$ that does not correspond to any valid dictionary and break security.

{: .info}
**Moral of the story:**
Some AD schemes[^BBF18]$^,$[^LGGplus20]$^,$[^AR20]$^,$[^Feis20Multi] are secure enough for stateless validation but not for transparency logs (and other applications as well).
This is because the stateless setting inherently restricts the adversary to **correctly** compute the digest $d$.
Hence, the attack above is not applicable in that setting, since the validators would never end up with such a maliciously-crafted digest.
\
\
However, in the transparency log setting, clients are just given arbitrary digests with no guarantees about how they were computed[^obs4] (since such guarantees would be computationally or communicationally expensive to provide).
As a result, attacks like the one above are possible and must be prevented by the AD scheme in this setting!
Fortunately, these are exactly the kinds of attacks that _strong key binding_ promises to prevent!

### From weak key binding UAD to strong key binding AAD

This is a great opportunity to explain (somewhat informally) how security proofs work for ADs.
When we try to prove our UAD secure under weak key binding, we start from the assumption that an adversary $\adv$ breaks the scheme and we show how we can use it to solve a difficult computational problem such as the Strong RSA problem.

### Non-membership proofs

### Append-only proofs

[^AR20]: **KVaC: Key-Value Commitments for Blockchains and Beyond**, by Shashank Agrawal and Srinivasan Raghuraman, *in Cryptology ePrint Archive, Report 2020/1161*, 2020, [[URL]](https://eprint.iacr.org/2020/1161)
[^BBF18]: **Batching Techniques for Accumulators with Applications to IOPs and Stateless Blockchains**, by Dan Boneh and Benedikt Bünz and Ben Fisch, *in Cryptology ePrint Archive, Report 2018/1188*, 2018, [[URL]](https://eprint.iacr.org/2018/1188)
[^BCPR14]: **On the Existence of Extractable One-way Functions**, by Bitansky, Nir and Canetti, Ran and Paneth, Omer and Rosen, Alon, *in Proceedings of the Forty-sixth Annual ACM Symposium on Theory of Computing*, 2014, [[URL]](http://doi.acm.org/10.1145/2591796.2591859)
[^Bd93]: **One-Way Accumulators: A Decentralized Alternative to Digital Signatures**, by Benaloh, Josh and de Mare, Michael, *in EUROCRYPT '93*, 1994
[^LLX07]: **Universal Accumulators with Efficient Nonmembership Proofs**, by Li, Jiangtao and Li, Ninghui and Xue, Rui, *in Applied Cryptography and Network Security*, 2007
[^ct]: **Certificate Transparency**, by Google, [[URL]](https://www.certificate-transparency.org/)
[^CF13e]: **Vector Commitments and their Applications**, by Dario Catalano and Dario Fiore, *in Cryptology ePrint Archive, Report 2011/495*, 2011, [[URL]](https://eprint.iacr.org/2011/495)
[^CFGplus20e]: **Vector Commitment Techniques and Applications to Verifiable Decentralized Storage**, by Matteo Campanelli and  Dario Fiore and Nicola Greco and  Dimitris Kolonelos and  Luca Nizzardo, 2020, [[URL]](https://eprint.iacr.org/2020/149)
[^Feis20Multi]: **Multi-layer hashmaps for state storage**, by Dankrad Feist, 2020, [[URL]](https://ethresear.ch/t/multi-layer-hashmaps-for-state-storage/7211/print)
[^FDPplus14]: **Hey, NSA: Stay Away from My Market! Future Proofing App Markets against Powerful Attackers**, by Fahl, Sascha and Dechand, Sergej and Perl, Henning and Fischer, Felix and Smrcek, Jaromir and Smith, Matthew, *in Proceedings of the 2014 ACM SIGSAC Conference on Computer and Communications Security*, 2014, [[URL]](https://doi.org/10.1145/2660267.2660311)
[^GRWZ20e]: **Pointproofs: Aggregating Proofs for Multiple Vector Commitments**, by Sergey Gorbunov and Leonid Reyzin and Hoeteck Wee and Zhenfei Zhang, 2020, [[URL]](https://eprint.iacr.org/2020/419)
[^LGGplus20]: **Aardvark: A Concurrent Authenticated Dictionary with Short Proofs**, by Derek Leung and Yossi Gilad and Sergey Gorbunov and Leonid Reyzin and Nickolai Zeldovich, *in Cryptology ePrint Archive, Report 2020/975*, 2020, [[URL]](https://eprint.iacr.org/2020/975)
[^LK15]: **Revocation Transparency**, by Ben Laurie and Emilia Kasper, 2015, [[URL]](https://www.links.org/files/RevocationTransparency.pdf)
[^LM18]: **Subvector Commitments with Application to Succinct Arguments**, by Russell W.F. Lai and Giulio Malavolta, *in Cryptology ePrint Archive, Report 2018/705*, 2018, [[URL]](https://eprint.iacr.org/2018/705)
[^obs1]: We were not the first to make this observation; see the work by Agrawal and Raghuraman[^AR20]
[^obs2]: See Section 3.1 in our full paper[^TXN20e]
[^obs3]: With the exception of the first KVC of Boneh et al.[^BBF18], which actually satisfies strong key binding, while their second construction is faster but only satisfies weak key binding.
[^obs4]: Technically, they are given an _append-only_ guarantee for the new digest w.r.t. the previous digest. However, the append-only guarantee still does not promise anything about the correctness of the digest. See our original AAD paper for how append-only guarantees are formalized[^TBPplus19].
[^TBPplus19]: **Transparency Logs via Append-Only Authenticated Dictionaries**, by Tomescu, Alin and Bhupatiraju, Vivek and Papadopoulos, Dimitrios and Papamanthou, Charalampos and Triandopoulos, Nikos and Devadas, Srinivas, *in ACM CCS'19*, 2019, [[URL]](https://doi.org/10.1145/3319535.3345652)
[^TXN20e]: **Authenticated Dictionaries with Cross-Incremental Proof (Dis)aggregation**, by Alin Tomescu and Yu Xia and Zachary Newman, *in Cryptology ePrint Archive, Report 2020/1239*, 2020, [[URL]](https://eprint.iacr.org/2020/1239)
