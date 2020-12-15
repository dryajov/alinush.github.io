---
layout: article
titles:
  # @start locale config
  en      : &EN       About
  en-GB   : *EN
  en-US   : *EN
  en-CA   : *EN
  en-AU   : *EN
  zh-Hans : &ZH_HANS  关于
  zh      : *ZH_HANS
  zh-CN   : *ZH_HANS
  zh-SG   : *ZH_HANS
  zh-Hant : &ZH_HANT  關於
  zh-TW   : *ZH_HANT
  zh-HK   : *ZH_HANT
  ko      : &KO       소개
  ko-KR   : *KO
  fr      : &FR       À propos
  fr-BE   : *FR
  fr-CA   : *FR
  fr-CH   : *FR
  fr-FR   : *FR
  fr-LU   : *FR
  # @end locale config
key: page-about
#article_header:
#  type: cover
#  image:
#    src: /pictures/pitesti.jpg
article_header:
  type: cover
  image:
    src: /pictures/tbow-header.jpg
---

<style>
  .swiper-demo {
    height: 600px;
  }
  .swiper-demo .swiper__slide {
    display: flex;
    align-items: center;
    justify-content: center;
    font-size: 3rem;
    color: #fff;
  }
</style>

<!-- See notes here about HTML blocks: https://kramdown.gettalong.org/syntax.html#html-blocks -->

### The official statement

<!-- ![](/pictures/tbow-th.jpg){: .align-right} -->

I was born and raised in [Pitești](https://en.wikipedia.org/wiki/Pitesti), a small city in Romania, and moved to the US in 2008.
I was always fascinated with computers: playing on them, fixing them & programming them.
I like to read, write and talk about _ideas_.
You can see some of my writing on [this website](/archive.html) and on [Decentralized Thoughts](https://decentralizedthoughts.github.io/about-alin).

I am currently a _Postdoctoral Researcher_ at [VMware Research](https://research.vmware.com).
My broad [research interests](/papers.html) are in cryptography and its practical applications. 
I am very interested in authenticated data structures, especially if based on more exotic primitives, such as [constant-sized polynomial commitments](/2020/05/06/kzg-polynomial-commitments.html). 
In the past, I’ve worked on transparency logs, threshold cryptography, anonymous cryptocurrencies, scalable Byzantine Fault Tolerance (BFT) protocols, append-only logs on top of Bitcoin, and oblivious file systems.

### The truth

Alin is a prolific slav-squatter. 
In his free time, he likes to play piano, <strike>sit in coffee shops,</strike> ride motorcycles, and lift things up and put them back down again.
Slowly.
He also enjoys travelling, but only to destinations with total solar eclipses.
Naturally, he dislikes clouds.
(Please join him in Antarctica, in 2021.)

<strike><b>Alin might buy a motorcycle and risk the few, still-functioning limbs in his body.
Someone should convince him not to do this.</b></strike>

### The motorcycle

Alin recently purchased a 2017 Honda Rebel 500.
He has never been more happy and terrified at the same time.
Even after taking basic and intermediate riding courses, he remains terrified.
This is probably for the best.
Wish him luck.

<!--
To deal with his predisposition towards death, Alin has been doing several things:

 1. Taking motorcycle courses:
    * In June 2020, he passed the Motorcycle Safety Foundation's Basic Rider Course
    - In Novemeber 2020, he passed Total Control Training's Intermediate Riding Clinic
 2. Practicing deliberately, carefully increasing his area of competence.
 2. Watching [after-crash reviews by "Dan Dan The Fireman"](https://www.youtube.com/watch?v=YkRV5Q4sb8c&ab_channel=DanDanTheFireman), to learn from others' mistakes.
    - **WARNING:** Watching such videos before you take a motorcycle safety course can be terrifying and will likely prevent you from ever getting on a motorcycle. 
    - Most of the accidents in the video are caused by the motorcyclist's inability to **take responsibility** for their own safety.
    - That personal responsibility is taught in rider courses (such as the ones above) and by other motorcyclists.
    - At the same time, one must recognize that no amount of personal responsibility will make motorcycles (or cars) completely safe.
-->

<div class="swiper swiper-demo">
 <div class="swiper__wrapper">
  <div class="swiper__slide"><a href="/pictures/rebel-500.jpg"><img src="/pictures/rebel-500.jpg" /></a></div>
  <div class="swiper__slide"><a href="/pictures/rebel-500.jpg"><img src="/pictures/rebel-500-wet.jpg" /></a></div>
  <div class="swiper__slide"><a href="/pictures/rebel-500.jpg"><img src="/pictures/rebel-500-vista-point.jpg" /></a></div>
 </div>
 <div class="swiper__button swiper__button--prev fas fa-chevron-left"></div>
 <div class="swiper__button swiper__button--next fas fa-chevron-right"></div>
</div>

<script>
  {%- include scripts/lib/swiper.js -%}
  var SOURCES = window.TEXT_VARIABLES.sources;
  window.Lazyload.js(SOURCES.jquery, function() {
  $('.swiper-demo').swiper();
  });
</script>
