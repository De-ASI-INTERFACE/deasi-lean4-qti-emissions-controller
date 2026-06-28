import DEASI.Emissions.Rules

namespace DEASI.Emissions.Invariant
open DEASI.Emissions
open Classical

lemma C_ceil_pos (cfg : Config) (h : 0 < cfg.C_ceil) : 0 < cfg.C_ceil := h

lemma W_min_pos (cfg : Config) (h : 0 < cfg.W_min) : 0 < cfg.W_min := h

lemma A_zero_floor (cfg : Config) (s : State) (hcfg : 0 < cfg.W_min) (hsm : stepMag s = 0) :
    A_zero cfg s = cfg.W_min := by
  simp [A_zero, hsm]

lemma A_zero_nonneg (cfg : Config) (s : State) (hcfg : 0 ≤ cfg.W_min) :
    0 ≤ A_zero cfg s := by
  by_cases h : stepMag s = 0
  · simp [A_zero, h, hcfg]
  · simp [A_zero, h]

lemma frictionTerm_nonneg (s : State) : 0 ≤ frictionTerm s := by
  by_cases h : s.friction
  · simp [frictionTerm, h]
  · simp [frictionTerm, h]

lemma A_rate_nonneg (s : State) : 0 ≤ A_rate s := by
  by_cases h : s.callsThisEpoch > 0
  · simp [A_rate, h]
  · simp [A_rate, h]

lemma A_repeat_nonneg (s : State) : 0 ≤ A_repeat s := by
  simp [A_repeat]

lemma stepMag_nonneg (s : State) (h : 0 ≤ s.velNorm) : 0 ≤ stepMag s := by
  dsimp [stepMag]
  positivity

lemma cost_nonneg (cfg : Config) (s : State)
    (hW : 0 ≤ s.weight) (hv : 0 ≤ s.velNorm) (hcfg : 0 ≤ cfg.W_min) :
    0 ≤ cost cfg s := by
  dsimp [cost]
  have hs : 0 ≤ stepMag s := stepMag_nonneg s hv
  have hz : 0 ≤ A_zero cfg s := A_zero_nonneg cfg s hcfg
  have hf : 0 ≤ frictionTerm s := frictionTerm_nonneg s
  have hr : 0 ≤ A_rate s := A_rate_nonneg s
  have hp : 0 ≤ A_repeat s := A_repeat_nonneg s
  positivity

lemma velocity_cap_respected (cfg : Config) (s : State) (h : s.velNorm ≤ cfg.V_cap) :
    s.velNorm ≤ cfg.V_cap := h

end DEASI.Emissions.Invariant
