import DEASI.Emissions.Rules

namespace DEASI.Emissions.Invariant
open DEASI.Emissions
open Classical

def markConsumed (s : State) (n : Nonce) : State :=
  { s with consumedNonces := fun m => if m = n then true else s.consumedNonces m }

lemma settlement_nonce_idempotent (s : State) (n : Nonce)
    (h : s.consumedNonces n = true) :
    settlementAccepted n s = False := by
  simp [settlementAccepted, h]

lemma markConsumed_sets_true (s : State) (n : Nonce) :
    (markConsumed s n).consumedNonces n = true := by
  simp [markConsumed]

end DEASI.Emissions.Invariant
