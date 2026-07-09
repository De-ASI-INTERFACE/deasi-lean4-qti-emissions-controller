import Lake
open Lake DSL

-- QTI Emissions Controller — Lean 4 formal specification
-- RP-DEASI-EMISSIONS-2026-0627-001
-- Author: Richard Patterson (@De-ASI-INTERFACE)

package «deasi-lean4-qti-emissions-controller» where
  name := `deasi_lean4_qti_emissions_controller

require mathlib from git
  "https://github.com/leanprover-community/mathlib4" @ "v4.14.0"

@[default_target]
lean_lib «DEASI» where
  roots := #[`DEASI]
  globs := #[
    .submodules `DEASI
  ]
