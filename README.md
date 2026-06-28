# DEASI Lean4 / RPRK Emissions Controller

**Author:** Richard Arlie Charles Patterson  
**Organization:** [De-ASI-INTERFACE](https://github.com/De-ASI-INTERFACE) · [QuantumTradingInfinity](https://github.com/QuantumTradingInfinity)  
**License:** MIT  
**Year:** © 2026  

---

## Overview

This repository contains the formal specification, verification report, and vulnerability audit of the DEASI Lean4 / RPRK Emissions Controller — a deterministic, mathematically verified incentive system designed for on-chain deployment (Solana/Anchor). The architecture couples state-transition logic with a cost function and a strictly bounded token emission mechanism.

---

## Verified Logic Report

### 1. State Evolution

The system defines three state variables that evolve across discrete time steps:

- **Position:** `pos' = pos + vel`
- **Velocity:** `vel' = vel` (invariant)
- **Weight:** `W' = W` (invariant)

All transitions are deterministic. There is no acceleration, stochasticity, or hidden state mutation. This design guarantees full auditability and predictable on-chain execution costs.

**Lean 4 Names:** `step_pos`, `step_vel`, `step_weight`

---

### 2. Norms and Magnitudes

| Property | Definition | Lean 4 Name |
|---|---|---|
| L1 Norm | `‖v‖₁ = Σᵢ |vᵢ|` | `llNorm` |
| Step Magnitude | `stepMag(v) = ‖v‖₁ / 2` | `stepMag` |
| L1 Norm Non-negativity | `0 ≤ ‖v‖₁` | `llNorm_nonneg` |
| Step Mag Non-negativity | `0 ≤ stepMag(v)` | `stepMag_nonneg` |
| Zero Velocity Lemma | `(∀i, vᵢ=0) ⟹ stepMag(v)=0` | `stepMag_zero_of_zero` |

All norms are provably non-negative. The zero-velocity lemma eliminates edge cases where zero input could produce nonzero cost.

---

### 3. Geometry: Friction Zone

Friction activates as a binary state when the L1 position norm crosses a boundary:

```
isFrictionZone(p) := 1[‖p‖₁ ≥ 10]
```

The logical equivalence form used in proofs:
```
isFrictionZone(p) = true ↔ ‖p‖₁ ≥ 10
```

**Lean 4 Names:** `isFrictionZone`, `isFrictionZone_iff`

This creates a regime boundary. Inside the zone, a friction penalty `F = 1` is applied. Outside, `F = 0`. The binary nature keeps the cost function linear and avoids discontinuities that could create exploitable edge conditions.

---

### 4. Cost Function

The primary cost equation:

```
C = W · (‖v‖₁ / 2) + F
```

Where:
- `W` = weight multiplier (invariant across steps)
- `‖v‖₁ / 2` = step magnitude (half the L1 velocity norm)
- `F ∈ {0, 1}` = binary friction penalty

**Supporting constraints:**

| Constraint | Lean 4 Name | Meaning |
|---|---|---|
| `F = 1 if friction else 0` | `friction_term` | Binary friction penalty |
| `0 ≤ F` | `friction_nonneg` | Friction never negative |
| `0 ≤ C` | `cost_nonneg` | Cost always nonneg |
| `F ≤ C` | `cost_lower_bound` | Cost ≥ friction penalty |
| `W·(‖v‖₁/2) ≤ C` | `cost_ge_weight_mul_stepMag` | Cost ≥ kinematic term alone |

**Phase tracking:** `phase' = ¬phase` (toggles each step), `nextPhase`  
**Friction tracking:** `friction' = 1[‖pos+vel‖₁ ≥ 10]`, `nextFriction`

---

### 5. Algebraic Reduction

Under parameters `W=2, F=1`:

```
C = ‖v‖₁ + 1
```

This collapses cost to a direct linear function of velocity magnitude, eliminating the weight scaling and simplifying formal verification. The identity:

```
2 · (‖v‖₁ / 2) = ‖v‖₁
```

Cancels exactly over the rationals `ℚ`, confirming no floating-point rounding errors in the algebraic path.

**Lean 4 Names:** `cost_reduction_calc`, `ring_nf`

---

### 6. Canonical Example — v=(2,2), W=3/2, F=0

| Step | Computation | Result |
|---|---|---|
| L1 Norm | `‖(2,2)‖₁ = 4` | 4 |
| Step Magnitude | `4/2 = 2` | 2 |
| Cost | `(3/2)·2 + 0 = 3` | 3 |
| Successor Position | `(2,2) + (2,2) = (4,4)` | (4,4) |

**Lean 4 Names:** `sample_llNorm`, `sample_stepMag`, `sample_cost`, `sample_step_pos`

---

### 7. RPRK Emission Map

Emissions decrease linearly as cost increases:

```
E = ⌊ E_max · (1 − C / C_ceil) ⌋
```

**Boundary conditions:**

| Condition | Result | Lean 4 Name |
|---|---|---|
| `C = 0` | `E = E_max` | `RPRK_boundary_low` |
| `C ≥ C_ceil` | `E = 0` | `RPRK_boundary_high` |

The floor function ensures integer emission values. Emissions are strictly non-negative by construction.

---

### 8. On-Chain Supply Constraints (Solana / Anchor)

Three hard caps govern all emission behavior:

```
1. E_epoch + E ≤ E_max/epoch       (per-epoch cap)
2. T + E ≤ T_cap                   (lifetime total cap)
3. T_cap_new ≥ T_minted            (cap monotonicity)
4. slots ≥ epoch_dur ⟹ E_epoch ← 0  (epoch rollover)
```

**Lean 4 Names:** `EpochCapExceeded`, `TotalCapExceeded`, `CapBelowMinted`, `epoch_rollover`

These constraints guarantee:
- No per-epoch over-issuance
- No lifetime over-issuance
- The supply ceiling cannot be lowered below already-minted supply
- Epoch counters reset cleanly on rollover

---

## Vulnerability Audit

### Audit Scope
All 31 logical assertions in the specification were reviewed for the following vulnerability classes:

1. **Integer overflow / underflow** — All quantities are non-negative by proof. `C ≥ 0`, `F ≥ 0`, `E ≥ 0`. No subtraction is performed without a proven lower bound.

2. **Division by zero** — `C_ceil` appears in the denominator of the emission formula. The specification does not explicitly prove `C_ceil > 0`. **Recommendation:** Add a precondition `C_ceil_pos : C_ceil > 0` to all lemmas involving the emission formula.

3. **Emission inflation via zero-cost gaming** — At `C = 0`, `E = E_max`. An actor who can consistently drive cost to zero maximizes emissions indefinitely. This is partially mitigated by the per-epoch cap and total cap, but the `F = 0` path (outside friction zone, zero weight) deserves explicit invariant protection.

4. **Friction zone boundary straddling** — The friction condition is `‖p‖₁ ≥ 10`. An actor at exactly `‖p‖₁ = 9` can oscillate in and out of the friction zone by choosing velocity directions strategically, toggling `F` between 0 and 1 each step and exploiting the difference in cost to optimize emissions. **Recommendation:** Consider a hysteresis band (e.g., enter zone at 10, exit only at 8) or a smoothed friction function.

5. **Phase toggle manipulation** — `phase' = ¬phase` is a deterministic toggle with no external guard. If phase is used downstream to unlock functionality, an actor can predict and sequence actions to always hit a favorable phase. **Recommendation:** Add entropy or a VRF seed to phase if it gates privileged operations.

6. **Cap monotonicity enforcement** — `T_cap_new ≥ T_minted` prevents the cap from being lowered below minted supply, but does not prevent the cap from being raised without governance approval. If the cap is mutable, ensure cap-increase operations require multi-signature authorization.

7. **Epoch rollover race condition** — The rollover condition `slots ≥ epoch_dur ⟹ E_epoch ← 0` relies on slot-based timing. On Solana, slot timing is not perfectly uniform. Ensure the rollover is checked at instruction entry and cannot be triggered multiple times within the same transaction bundle.

8. **Weight invariance assumption** — `W' = W` is asserted but not enforced by a smart contract access control rule. If `W` is a mutable account field, a privileged authority could update it mid-epoch. **Recommendation:** Add an immutability constraint or require governance-gated weight updates.

---

## Formal Verification Status

| Module | Assertions | Status |
|---|---|---|
| Norms & Magnitudes | 5 | ✅ Verified |
| Geometry | 2 | ✅ Verified |
| Dynamics | 5 | ✅ Verified |
| Cost Function | 6 | ✅ Verified |
| Algebraic Reduction | 2 | ✅ Verified |
| Canonical Example | 4 | ✅ Verified |
| RPRK Emission Map | 3 | ✅ Verified |
| On-Chain Constraints | 4 | ✅ Verified |
| **Total** | **31** | **✅ All Pass** |

---

## Recommended Mitigations

1. Add `C_ceil_pos` precondition to emission lemmas
2. Implement friction hysteresis band to prevent boundary oscillation
3. Protect phase toggle with VRF if used in privileged gating
4. Require governance multi-sig for cap increases
5. Guard epoch rollover against duplicate execution within the same slot bundle
6. Add access control to weight mutation if `W` is a mutable on-chain field

---

## License

MIT License — © 2026 Richard Arlie Charles Patterson

---

*Specification formally verified in Lean 4. On-chain implementation targets Solana/Anchor. All rights reserved.*
