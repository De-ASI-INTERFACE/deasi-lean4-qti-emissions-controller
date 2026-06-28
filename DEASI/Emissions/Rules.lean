import DEASI.Emissions.Types

namespace DEASI.Emissions

open Classical

noncomputable def stepMag (s : State) : Rat := s.velNorm / 2

noncomputable def A_zero (cfg : Config) (s : State) : Rat :=
  if stepMag s = 0 then cfg.W_min else 0

noncomputable def frictionTerm (s : State) : Rat :=
  if s.friction then 1 else 0

noncomputable def A_rate (s : State) : Rat :=
  if h : s.callsThisEpoch > 0 then s.callsThisEpoch else 0

noncomputable def A_repeat (s : State) : Rat := s.actor.repeatScore

noncomputable def cost (cfg : Config) (s : State) : Rat :=
  s.weight * stepMag s + frictionTerm s + A_zero cfg s + A_rate s + A_repeat s

noncomputable def emissionRaw (cfg : Config) (s : State) : Rat :=
  cfg.E_max * max (1 - cost cfg s / cfg.C_ceil) 0

def emission (cfg : Config) (s : State) : Nat :=
  Int.toNat <| Rat.floor (emissionRaw cfg s)

def actorEpochRemaining (cfg : Config) (s : State) : Nat :=
  cfg.actorEpochCap - s.actor.epochUsed

def actorTotalRemaining (cfg : Config) (s : State) : Nat :=
  cfg.actorTotalCap - s.actor.totalUsed

def systemEpochRemaining (cfg : Config) (s : State) : Nat :=
  cfg.E_max - s.epochMinted

def boundedEmission (cfg : Config) (s : State) : Nat :=
  min (emission cfg s) <| min (actorEpochRemaining cfg s) (systemEpochRemaining cfg s)

def rateGuardHolds (deltaUp : Nat) (s : State) (e : Nat) : Prop :=
  e ≤ s.prevEmission + deltaUp

def nextFriction (cfg : Config) (s : State) : Bool :=
  if s.cooldown > 0 then true
  else if s.friction then s.posNorm > 8
  else s.posNorm ≥ 10

def nextCooldown (cfg : Config) (s : State) : Nat :=
  if (!s.friction) && nextFriction cfg s then cfg.cooldownLen
  else s.cooldown - 1

def validOracle (cfg : Config) (s : State) : Prop :=
  s.oracle.sourceApproved = true ∧
  s.oracle.updateAge ≤ cfg.staleLimit ∧
  s.oracle.deviation ≤ cfg.deviationLimit

def timelockSatisfied (cfg : Config) (s : State) : Prop :=
  s.gov.eta ≤ s.currentTime

def quorumSatisfied (cfg : Config) (s : State) : Prop :=
  s.gov.quorum ≥ cfg.quorumMin ∧ s.gov.approved = true

def validParamChange (cfg : Config) (s : State) : Prop :=
  timelockSatisfied cfg s ∧ quorumSatisfied cfg s

def settlementAccepted (n : Nonce) (s : State) : Prop :=
  s.consumedNonces n = false

end DEASI.Emissions
