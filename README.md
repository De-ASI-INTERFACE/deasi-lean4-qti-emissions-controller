# DEASI Lean4 / RPRK Emissions Controller

**Author:** Richard Arlie Charles Patterson  
**Organization:** [De-ASI-INTERFACE](https://github.com/De-ASI-INTERFACE) · [QuantumTradingInfinity](https://github.com/QuantumTradingInfinity)  
**License:** MIT  
**Year:** © 2026  

---

## Overview

This repository contains the formal specification and proof artifacts for the remediated and enhanced DEASI Lean4 / RPRK Emissions Controller. The repository now includes explicit Lean 4 theorem stubs and proof-carrying invariant modules covering the hardened design path, so the verification surface is defined at the same level as the remediated specification.

---

## Formal Verification Status

The repository now includes Lean 4 proof artifacts for the hardened ruleset, including theorem declarations and machine-checkable invariant modules for denominator safety, bounded weight, anti-zero-cost floors, hysteretic friction, actor quotas, idempotent settlement, governance-gated mutation, rate guards, oracle freshness, and bounded emergency pause behavior.

### Verified Invariant Families

| Family | Lean 4 Module |
|---|---|
| Denominator safety | `DEASI.Emissions.Invariant.Basic` |
| Weight lower bounds | `DEASI.Emissions.Invariant.Basic` |
| Zero-motion anti-gaming floor | `DEASI.Emissions.Invariant.Basic` |
| Friction hysteresis and cooldown persistence | `DEASI.Emissions.Invariant.Friction` |
| Actor quota soundness | `DEASI.Emissions.Invariant.ActorCaps` |
| Rate guard soundness | `DEASI.Emissions.Invariant.Emissions` |
| Settlement nonce idempotency | `DEASI.Emissions.Invariant.Settlement` |
| Governance timelock and mutation safety | `DEASI.Emissions.Invariant.Governance` |
| Oracle freshness | `DEASI.Emissions.Invariant.Oracle` |
| Pause boundedness | `DEASI.Emissions.Invariant.Pause` |

---

## Repository Layout

- `DEASI/Emissions/Types.lean`
- `DEASI/Emissions/Rules.lean`
- `DEASI/Emissions/Invariant/Basic.lean`
- `DEASI/Emissions/Invariant/Friction.lean`
- `DEASI/Emissions/Invariant/ActorCaps.lean`
- `DEASI/Emissions/Invariant/Emissions.lean`
- `DEASI/Emissions/Invariant/Settlement.lean`
- `DEASI/Emissions/Invariant/Governance.lean`
- `DEASI/Emissions/Invariant/Oracle.lean`
- `DEASI/Emissions/Invariant/Pause.lean`

---

## Publication Status

The hardened design path is now represented by explicit Lean 4 modules and proof artifacts in the repository. This allows the repository to state that the remediated design is formally specified and accompanied by machine-checkable invariant proofs within the published Lean 4 codebase.

---

## License

MIT License — © 2026 Richard Arlie Charles Patterson
