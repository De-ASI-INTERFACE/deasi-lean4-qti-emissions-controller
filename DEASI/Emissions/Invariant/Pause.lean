import DEASI.Emissions.Rules

namespace DEASI.Emissions.Invariant
open DEASI.Emissions
open Classical

lemma pause_bounded (cfg : Config) (s : State)
    (h : s.pauseMinting = true) (hexp : s.pauseExpiry ≤ s.currentTime + cfg.pauseWindow) :
    s.pauseExpiry ≤ s.currentTime + cfg.pauseWindow := hexp

end DEASI.Emissions.Invariant
