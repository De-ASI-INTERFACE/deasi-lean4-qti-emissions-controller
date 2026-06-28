import DEASI.Emissions.Rules

namespace DEASI.Emissions.Invariant
open DEASI.Emissions
open Classical

lemma timelock_required (cfg : Config) (s : State) (h : validParamChange cfg s) :
    timelockSatisfied cfg s := h.1

lemma quorum_required (cfg : Config) (s : State) (h : validParamChange cfg s) :
    quorumSatisfied cfg s := h.2

lemma gov_only_weight_update (cfg : Config) (s : State) (h : validParamChange cfg s) :
    timelockSatisfied cfg s ∧ quorumSatisfied cfg s := h

end DEASI.Emissions.Invariant
