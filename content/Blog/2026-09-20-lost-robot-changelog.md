+++
title = "Lost Robot Changelog — 2026-09-20"
date = 2026-09-20
draft = false
tags = ["changelog", "zara", "prolog", "lisp", "emacs", "starintel"]
+++

A lot moved at once, so here's the compressed version.

This is the wider Lost Robot changelog: personal/open-source work plus the StarIntel ecosystem, with the distinction between merged work and plans kept intact.

## Zara

Zara's Android/Wear symbolic state path got another round of hardening.

Merged today:

- **Wear edge truth now comes from the canonical symbolic projection**, rather than a second representation that can silently drift.
- The edge-projection path was tested across **Android process recreation**.
- Live **nested expert delegations now recursively cancel** instead of leaving child work running behind a cancelled parent.

Evidence:

- [Zara 1095bc55](https://github.com/lost-rob0t/zara/commit/1095bc5537c98c555c29ac29ed335843191c558d)
- [Zara 81774609](https://github.com/lost-rob0t/zara/commit/8177460982f94a5a60cf454c2fd4f9beae867a95)
- [Zara 1734d7a7](https://github.com/lost-rob0t/zara/commit/1734d7a7bc4803bc324d79a4ba26937be9e0a003)

The important bit is architectural: UI state should be a projection of symbolic truth, not an independent source of truth.

That idea keeps winning.

## Prolog-RLM

Prolog-RLM gained a **generic zero-model overlay resolver runtime**.

The new path has:

- fail-closed resolution
- scope-isolated overrides
- a standalone acceptance gate
- CI coverage
- integration with the load-all gate

That means another behavior that previously could have required model mediation can run as plain symbolic policy.

Evidence: [prolog-rlm 4715b5ee](https://github.com/lost-rob0t/prolog-rlm/commit/4715b5ee53d0e7a26c55705ea85c0d16c3916504)

Also landed recently:

- a **Common Lisp adapter**
- a symbolic tool harness
- additional runtime redaction hardening for malformed outcomes

Evidence: [prolog-rlm eba3f90a](https://github.com/lost-rob0t/prolog-rlm/commit/eba3f90a1d4c0b9342e9e37049f92b178c115c1c)

The trajectory here is pretty obvious now: use an LLM where the problem actually needs one; otherwise make Prolog do the deterministic work.

## Dotfiles

The machine configuration got two small but important fixes.

Zara now builds against **its own locked nixpkgs**, so the dotfiles flake does not quietly substitute a different dependency universe underneath the application.

Evidence: [dotfiles fe8f7fa3](https://github.com/lost-rob0t/dotfiles/commit/fe8f7fa3c42803e0e505dcb6f7e4600d27649d9e)

The OpenCode Bun splitting workaround also gained a proper guard instead of firing unconditionally.

Evidence: [dotfiles 636369fa](https://github.com/lost-rob0t/dotfiles/commit/636369fabe62dc809d4370aca333bd6004449cba)

Neither feature is glamorous. Both eliminate stupid classes of environmental breakage.

Good trade.

## Org tooling

The latest major `org-vector` work remains the de-slop/crash-chain cleanup:

- fixed an Emacs crash chain
- fixed retrieval bugs
- cleaned up packaging
- expanded tests
- added CI

Evidence: [org-vector 6be815e4](https://github.com/lost-rob0t/org-vector/commit/6be815e4f8bc1c3eeacd2ee63212820cf398611e)

This is increasingly becoming part of a larger idea: Org is not just where notes live. It is turning into the human-editable knowledge layer connecting Emacs, retrieval, symbolic memory, publishing, and agent context.

## StarIntel

StarIntel had several concrete runtime/control-plane changes:

- Prolog geo observations can be deterministically promoted into **evidence-backed claims**.
- **Domain Hunt** was moved into a Sento actor.
- Quasar now wires in **canonical paid Pro Actors**.
- The server defines Source Actor and Target protocols.
- Hosted observability configuration became more explicit.
- The website gained a first-class **Auto Research** surface with fail-closed unconfigured behavior.
- `starintel-biz` gained an autonomous opportunity board, Prolog policy, and structured OSINT target pack.

The theme is the same one showing up in Zara and Prolog-RLM:

> fewer hidden decisions, more inspectable state.

## Current direction

The stack I care about is converging around a few primitives:

```text
Org / structured documents
        ↓
Prolog knowledge + policy
        ↓
actor runtimes
        ↓
durable event/data systems
        ↓
LLMs as bounded capabilities
        ↓
interfaces for humans and other agents
```

Not "put an LLM everywhere."

Almost the opposite.

Make as much of the system deterministic, inspectable, replayable, and locally executable as possible. Then give models access to that machinery where fuzzy reasoning actually buys something.

That's the current build.

---

*Generated with AI assistance from repository history available September 20, 2026. Technical shipped/not-shipped distinctions were checked against current repository state.*
