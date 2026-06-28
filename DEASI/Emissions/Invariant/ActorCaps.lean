import DEASI.Emissions.Rules

namespace DEASI.Emissions.Invariant
open DEASI.Emissions
open Classical

lemma actor_epoch_cap_sound (cfg : Config) (s : State) :
    boundedEmission cfg s ≤ actorEpochRemaining cfg s ∨ boundedEmission cfg s ≤ systemEpochRemaining cfg s := by
  dsimp [boundedEmission]
  exact Or.inl (Nat.min_le_right _ _)

lemma actor_total_remaining_sound (cfg : Config) (s : State) :
    actorTotalRemaining cfg s = cfg.actorTotalCap - s.actor.totalUsed := by
  rfl

end DEASI.Emissions.Invariant
