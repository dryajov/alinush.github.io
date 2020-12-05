---
tags:
title: A few notes on consensus algorithms
#date: 2020-11-05 20:45:59
published: false
#sidebar:
#    nav: cryptomat
---

These are my notes on a few consensus concepts explained by the brilliant [Ittai Abraham](https://research.vmware.com/researchers/ittai-abraham) in a [series of talks](https://www.youtube.com/watch?v=QJcBz9OHLuU&list=PL8Vt-7cSFnw1u2tedFU04Z4U-mJUMRtzW&index=11&ab_channel=TheBIUResearchCenteronAppliedCryptographyandCyberSecurity) at the 2020 Bar-Ilan Winter School on Cryptography.
This is not meant to be a tutorial on consensus: it is just an exercise in note-taking while watching video talks.

<!--more-->

## Network model

There are three ways to model the **adversary**'s power over the **network** which **players** use to communicate in distributed computing protocols such as consensus protocols.

All these models only capture the ability of the adversary to _delay_ messages.
**TODO:** adversary is assumed not to to tamper w/ messages.
**TODO:** instead of modelling the network as tampering messages, we model the players as being corrupted and their messages being arbitrarily constructed. a bit arbitrary.
Instead, it is modeled as the [adversary's power over the players](#power-of-adversaries-beyond-the-network) in the protocol: e.g., a [Byzantine adversary](#byzantine-adversary) who controls a player can implicitly tamper with the messages it sends out.
Similarly, secrecy of messages is also modeled as the adversary's power over players rather than the network (see "Visibility" [here](#other-characteristics)).

{: .warning}
**Q:** Network adversary still learns when A sends message to B? If so, when? After or before $B$ receives?

### Asynchrony

**Asynchrony** means the adversary can delay any message by any finite amount it wants (e.g., 20 seconds, 20 years).
However, eventually, every message will be delivered.

This model captures the _worst-case_ behaviour of a network.

{: .info}
Note that asynchrony does not allow the adversary to _drop_ messages.
Instead, this is modeled separately as the [power of the adversary over the players](#power-of-adversaries-beyond-the-network).
For example, an [omission adversary](#omission-adversary) can drop messages sent or received by any player it wants.
This allows us to model a _finite_ amount of message dropping since, for example, the omission adversary typically only controls a minority of players.
In contrast, if we were to allow dropping of messages in the network model itself, this would mean that in the worst-case all messages would be dropped and no useful protocols could ever be built in such a model.
  
### Synchrony

**Synchrony** means the adversary can delay messages by some _known_ bound $\Delta$ (e.g., any message sent arrives in at most $\Delta=3$ seconds).

This model gives the protocol designer much more power than the asynchronous model.
For example, protocols can be simpler and more efficient in the synchronous model.

### Lock step

In the **lock step model**, all messages arrive in $\Delta=1$ time unit and computation takes zero time.

{: .warning}
Ittai points out that ["we \[unconciously\] write protocols in the lock-step model."](https://youtu.be/QJcBz9OHLuU?list=PL8Vt-7cSFnw1u2tedFU04Z4U-mJUMRtzW&t=626) in the sense that protocol designers typically assume too much of the network in their designs. This can be okay, because it is usually easy to turn such protocols into synchronous protocols.
However, such transformations might be leaving some performance on the table. 
For example, we know that, even in the synchronous model, you can sometimes make your protocol as fast as the network speed (via optimistic paths)[^ANRS20].

### Partial synchrony

**Partial synchrony** is a hybrid model lying somewhere between _synchrony_ and _asynchrony_, proposed by _Dwork, Lynch and Stockmeyer_[^DLS88].
Partial synchrony comes in two "flavors," which are _equivalent_: a protocol for one flavor can be turned into a protocol for the other flavor (and vice-versa).
<small>(See Ittai's ["Flavors of partial synchrony"](https://decentralizedthoughts.github.io/2019-09-13-flavours-of-partial-synchrony/) blog post for details.)</small>

Partial synchrony was developed to circumvent the classic _Fischer-Lynch-Paterson (FLP)_ impossibility result[^FLP85]$^,$[^papertrail], which says any consensus algorithm (whether randomized or not) in the asynchronous network model has the possibility of non-termination.
(In practice, actual asynchronous consensus protocols make this probability arbitrarily small.)

<!--
 + FLP says even randomized consensus has some probability of an infinite execution when doing asynchronously, but it's just that the probability is negligible in the security parameter with the right protocols (cryptography)
    + Can you actually construct such an infinite sequence? Yes: you just always find the leader and slow him down using the power of the asynchronous network adversary: there could be a "favorable" sequence of delays in the aysnchr network.
-->

#### "Global Stabilization Time" partial synchrony

Two phases:

 - in the beginning, the network is asynchronous, as defined [before](#asynchrony).
 - at some _unknown_ point in time, defined as **global stabilization time (GST)**, the system becomes _synchronous_, as defined [before](#synchrony), with a _known_ bound $\Delta$ on message delay

{: .warning}
**Q1:** I suppose the difficulty of the protocol designer is to figure out when he is past the GST point?
But [apparently this is not possible](https://decentralizedthoughts.github.io/2019-06-01-2019-5-31-models/).
\
**Q2:** But why is it realistic to assume synchrony past a certain point (i.e., past the GST)? 
Wouldn't real system potentially turn back asynchronous due to unpredictable massive network failures?
[Ittai indeed says the real world doesn't stick to this GST model](https://decentralizedthoughts.github.io/2019-09-13-flavours-of-partial-synchrony/).

**TODO:**
The reason GST partial synchrony makes sense is that one can think of a consensus protocol running indefinitely as a series of individual protocols which initially assume asynchrony (and maintain safety) and eventually get to GST and provide liveness.
Think of agreeing on a log of things and the agreement for each log entry.

Some papers try to define partial synchrony with synchrony periods interleaved among the asynchronous ones.
The problem is that such a model will be very tied to the protocol design itself, since the protocol design will have to inform the length of the synchrony periods in the network model.

#### "Unknown latency" partial synchrony

Again, this model can be shown to be [equivalent to the GST-flavor of partial synchrony](https://decentralizedthoughts.github.io/2019-09-13-flavours-of-partial-synchrony/) from above.

The model work just like [synchrony](#synchrony), except only the adversary knows the message delay bound $\Delta$ while the protocol designer does not.
(Recall that in synchrony, everyone knows $\Delta$!)

_["Partial-synchrony looks arbitrary!"](https://youtu.be/QJcBz9OHLuU?list=PL8Vt-7cSFnw1u2tedFU04Z4U-mJUMRtzW&t=725)_ someone might object!
One answer is that partial synchrony was the only model that stood the test of time!
This is because it was the only network model to allow a consensus protocol (built on top of the model) to be [live]() during synchrony and [safe]() during asynchrony.

**TODO:** add links to safety and liveness definitions of consensus protocols.

{: .warning}
**Q:** Really don't understand how _"live during synchrony and safe during asynchrony"_ is captured by the partial synchrony definition(s), since asynchrony seems to go away past the GST for example and there's no mention of asynchrony in the "unknown latency" flavor of the model.

{: .info}
In order of ease/efficency of designing protocols, we have: lock-step (easiest, most efficient), synchrony, partial synchrony and asynchrony (hardest, least efficient).

## Power of adversaries beyond the network

Beyond delaying messages on the network, the adversary can corrupt players in various ways.
Ittai summarizes this well in his [blog post](https://decentralizedthoughts.github.io/2019-06-07-modeling-the-adversary/) too.

### Passive adversary

A **passive adversary** (a.k.a. semi-honest, or honest-but-curious) runs the protocol correctly but tries to learn additional information that should not be revealed to him in that protocol.

{: .info}
For example, in a multi-party computation protocol, each player $i$ should only learn the output of a function $f(\dot)$ on inputs $x_1, \dots, x_n$ without learning the inputs $x_j$ of other players $j$.

### Crash adversary

A **crash adversary** can decide to **halt** players stopping them from both sending and receiving messages, even in the middle of them sending messages.

{: .info}
Q: Crash is a misnomer, because it does not address actual crashes where the disk data might get corrupted, right? 
\
A: Sometimes better referred to as fail-stop.
\
**Q2:** Is there a notion of _mobility_ for such adversaries?
**A2:** In principle, it's possible. But in practice, no protocols use it.

### Omission adversary

An **omission adversary** can build a bubble around a player, and control which messages it receives and which messages it sends out.

An omission adversary can do everything a crash adversary can, because he can "halt" a player by making sure it never sends/receives any messages past a certain point. 
However, a crash adversary doesn't have fine-grained control over incoming and outcoming messages: he has to stop all of them by halting the player.
So an omission adversary is more powerful.

{: .info}
Omission adversaries are good for modelling security of secure hardware such as trusted platform modules (TPMs), since the adversary cannot break into the hardware but can control what comes in and what goes out.

### Byzantine adversary

A **byzantine adversary** can fully control a player and exhibit _arbitrary_ behavior!

{: .info}
The name "byzantine" is completely arbitrary here and should be interpreted as "fully, arbitrarily malicious."
Its origin is explained by Lamport on his [website](http://lamport.azurewebsites.net/pubs/pubs.html#byz):
\
\
_"There is a problem in distributed computing that is sometimes called the Chinese Generals Problem, in which two generals have to come to a common agreement on whether to attack or retreat, but can communicate only by sending messengers who might never arrive.  I stole the idea of the generals and posed the problem in terms of a group of generals, some of whom may be traitors, who have to reach a common decision.  I wanted to assign the generals a nationality that would not offend any readers.  At the time, Albania was a completely closed society, and I felt it unlikely that there would be any Albanians around to object, so the original title of this paper was The Albanian Generals Problem.  Jack Goldberg was smart enough to realize that there were Albanians in the world outside Albania, and Albania might not always be a black hole, so he suggested that I find another name.  The obviously more appropriate Byzantine generals then occurred to me."_

### Covert adversary

A **covert adversary** is a byzantine adversary that does not want to be detected.

#### $\varepsilon$-covert adversary

An **$\varepsilon$-covert adversary** is a covert adversary that is okay with being detected with probability $\varepsilon$.

{: .info}
In order of ease/efficency of designing protocols, we have: passive (easiest, most efficient), crash, omission, covert and byzantine (hardest, least efficient).

### Other characteristics

Adversaries can also be classified in terms of:

 - **Computational power:**
    - Computationally-unbounded
    - Computationally-bounded
    - Fine-grained computationally-bounded (e.g., like in proof-of-work consensus)
 - **Visibility:**
    + Captures the secrecy of the players' state and the messages they send over the network
    - Full-information (i.e., adversary sees internal state of all players and all messages sent)
    - Private channels (i.e., full-information only w.r.t. corrupted players)
    - Rushing:
        - Only for lock-step model because, by definition, all synchronous network adversaries can rush and make messages arrive quickly
            + i.e., a synchronous network can deliver messages as fast/slow as the adversary wants
        - the adversary can wait to see all round $i$ messages **sent** to players it controls, before deciding what round $i$ messages those players should send.
    - Non-rushing:
        - The adversary must pick the messages for round $i$ sent by players it controls before seeing any messages from non-faulty players. 

{: .warning}
**Q1:** What are round-based protocols? Lock-step protocols?
\
A1: For synchronous model: any time a good guy sends message to bad guy, the adversary makes sure those messages take 0 time.
\
**Q2:** For non-rushing, presumably round $i$ sent messages only depend on round $i-1$ messages! Otherwise, it would be problematic.

## The notion of consensus itself

The notion of consensus was first conceptualized by _Wensley et al._ in 1978 in a paper about reliability of aircraft and spacecraft computers[^WLGplus78].
Later on, _Pease, Shostak and Lamport_[^PSL80] showed that consensus requires $n\ge 3f+1$ players if $f$ players are malicious (in the asynchronous network model).

The **consensus problem**:

 - There are $n$ players
 - Each player has some initial **input**
 - Players can send messages to each other via **point-to-point channels**
    + controlled by the adversary in various ways, as explained [before](#network-model)
 - We want three things to happen:
    - **Termination** or **liveness**: at the end of the protocol, each player must **decide** on a **value**
    - **Safety**: No two non-malicious players decide on different values
        + So far trivial: Can always have everyone decide on the value 0, for example.
    - **Validity** or **non-triviality:** The decision value has to be some function of the input.
        + Again, can always use $f(x) = 0$, so not good enough.
        + **Weak validity:** If everybody has the same input, then this must be the decision value.
            + Not good enough. What if players have different input?
        - **Fair validity:** With constant probability, an input of a non-faulty party is decided upon.

Broadcast vs agreement:
Agreement validity: if all non-faulty players have the same input, then this must be the decision value.
Q: Is this saying that in agreement, the decision value must be one of the inputs of the non-faulty players?

Broadcast: if the *designated sender* is non-faulty with input m then m is the decision value.
Q: Otherwise? The decision value is \bot?

**TODO:** Gilad also said to look at Cachin's paper[^Cach11], but to be mindful of the non-ideal notation.

## Ittai meeting

**TODO:** references for (reliable) broadcast?

 - bracha papers from https://decentralizedthoughts.github.io/2020-09-19-living-with-asynchrony-brachas-reliable-broadcast/
    + a byzantine version of ben-or
 - bracha shows how to solve asynchronous consensus using reliable broadcast
 - https://ecommons.cornell.edu/bitstream/handle/1813/6430/84-590.pdf?sequence=1&isAllowed=y
 - https://core.ac.uk/download/pdf/82523202.pdf

Broadcast referneces:

 - https://allquantor.at/blockchainbib/pdf/cachin2000random.pdf
 - https://eprint.iacr.org/2001/006
 - https://eprint.iacr.org/2006/065.pdf

Reliable broadcast (Bracha broadcast) is weaker than broadcast.
 
 - in broadcast you either have to decide $v$ that the honest sender sent or $\bot$ otherwise
    - only makes sense in the synchronous model
    + asynchrony makes it impossible to tell if sender is bad or network is bad
 - reliable broadcast
    - safety: if an honest player terminates with $v$ then all honest players terminate with $v$
    - validity: if the sender is non-faulty and has input $v$, then an honest player terminates with $v$
    - not necessarily terminate
    - in contrast, broadcast always terminates (in the synchronous model or partially-synchronous model)
 - its analogue in the synchronous model is _gradecast_: 
    - i.e., you terminate always with a value and a _grade_ (a bit)
    - originally by micali and feldman (they cite dolev's paper)
    - but better explanation by katz and koo

Also see post: https://decentralizedthoughts.github.io/2019-10-22-flavours-of-broadcast/

 - all in synchronous model

[^ANRS20]: **On the Optimality of Optimistic Responsiveness**, by Ittai Abraham and Kartik Nayak and Ling Ren and Nibesh Shrestha, *in Cryptology ePrint Archive, Report 2020/458*, 2020, [[URL]](https://eprint.iacr.org/2020/458)
[^Cach11]: **Yet Another Visit to Paxos**, by Christian Cachin, 2011, [[URL]](https://cachin.com/cc/papers/pax.pdf)
[^DLS88]: **Consensus in the presence of partial synchrony**, by Cynthia Dwork and Nancy Lynch and Larry Stockmeyer, *in Journal of the ACM*, 1988, [[URL]](https://doi.org/10.1145%2F42282.42283)
[^FLP85]: **Impossibility of distributed consensus with one faulty process**, by Michael J. Fischer and Nancy A. Lynch and Michael S. Paterson, *in Journal of the ACM*, 1985, [[URL]](https://doi.org/10.1145%2F3149.214121)
[^papertrail]: **A brief tour of FLP impossibility**, [[URL]](https://www.the-paper-trail.org/post/2008-08-13-a-brief-tour-of-flp-impossibility/)
[^PSL80]: **Reaching Agreement in the Presence of Faults**, by M. Pease and R. Shostak and L. Lamport, *in Journal of the ACM*, 1980, [[URL]](https://doi.org/10.1145%2F322186.322188)
[^WLGplus78]: **SIFT: Design and analysis of a fault-tolerant computer for aircraft control**, by J. H. Wensley and L. Lamport and J. Goldberg and M. W. Green and K. N. Levitt and P. M. Melliar-Smith and R. E. Shostak and C. B. Weinstock, *in Proceedings of the IEEE*, 1978
