import DEASI.Emissions.Rules

namespace DEASI.Emissions.Invariant
open DEASI.Emissions
open Classical

lemma cooldown_persists (cfg : Config) (s : State) (h : s.cooldown > 0) :
    nextFriction cfg s = true := by
  simp [nextFriction, h, if_pos]

lemma hysteresis_no_flip (cfg : Config) (s : State)
    (hfr : s.friction = true) (hcool : ¬ s.cooldown > 0) (hpos : s.posNorm > 8) :
    nextFriction cfg s = true := by
  simp [nextFriction, hcool, hfr, hpos]

lemma hysteresis_exit_allowed (cfg : Config) (s : State)
    (hfr : s.friction = true) (hcool : ¬ s.cooldown > 0) (hpos : ¬ s.posNorm > 8) :
    nextFriction cfg s = false := by
  simp [nextFriction, hcool, hfr, hpos]

end DEASI.Emissions.Invariant
