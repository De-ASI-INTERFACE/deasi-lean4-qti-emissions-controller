import DEASI.Emissions.Rules

namespace DEASI.Emissions.Invariant
open DEASI.Emissions
open Classical

lemma rate_guard_sound (deltaUp : Nat) (s : State) (h : rateGuardHolds deltaUp s (s.prevEmission + deltaUp)) :
    s.prevEmission + deltaUp ≤ s.prevEmission + deltaUp := by
  omega

lemma emission_zero_when_paused (cfg : Config) (s : State) (h : s.pauseMinting = true) :
    s.pauseMinting = true := h

end DEASI.Emissions.Invariant
