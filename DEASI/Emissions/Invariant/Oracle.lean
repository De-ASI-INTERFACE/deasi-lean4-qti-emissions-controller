import DEASI.Emissions.Rules

namespace DEASI.Emissions.Invariant
open DEASI.Emissions
open Classical

lemma oracle_freshness (cfg : Config) (s : State) (h : validOracle cfg s) :
    s.oracle.updateAge ≤ cfg.staleLimit := h.2.1

lemma oracle_source_approved (cfg : Config) (s : State) (h : validOracle cfg s) :
    s.oracle.sourceApproved = true := h.1

lemma oracle_deviation_bounded (cfg : Config) (s : State) (h : validOracle cfg s) :
    s.oracle.deviation ≤ cfg.deviationLimit := h.2.2

end DEASI.Emissions.Invariant
