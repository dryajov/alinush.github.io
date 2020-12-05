---
tags: polynomials polycommit
title: How to write C++ without paying for it later
date: 2020-06-01 22:38:00
published: false
---

## Let the compiler save you

Enable all warnings with `-Wall` and `-Wextra`.
Turn all warnings into errors with `-Werror`.
(e.g., see the flags in [this CMakeLists.txt](https://github.com/alinush/libpolycrypto/blob/master/CMakeLists.txt#L90))

## If you must "narrow", do it right

See [here][narrowing].

## Use `span<T>` rather than `T*` for arrays

### References

[narrowing]: https://www.modernescpp.com/index.php/c-core-guidelines-rules-for-conversions-and-casts
