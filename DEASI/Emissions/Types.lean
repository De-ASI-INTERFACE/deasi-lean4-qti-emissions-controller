namespace DEASI.Emissions

abbrev ActorId := Nat
abbrev Epoch := Nat
abbrev Nonce := Nat
abbrev Hash := Nat

structure Config where
  C_ceil : Rat
  E_max : Nat
  W_min : Rat
  V_cap : Rat
  cooldownLen : Nat
  actorEpochCap : Nat
  actorTotalCap : Nat
  timelock : Nat
  quorumMin : Nat
  staleLimit : Nat
  deviationLimit : Rat
  pauseWindow : Nat
  deriving Repr

structure ActorState where
  epochUsed : Nat
  totalUsed : Nat
  repeatScore : Nat
  stakeScore : Nat
  deriving Repr

structure GovernanceState where
  quorum : Nat
  eta : Nat
  approved : Bool
  deriving Repr

structure OracleState where
  sourceApproved : Bool
  updateAge : Nat
  deviation : Rat
  deriving Repr

structure State where
  posNorm : Rat
  velNorm : Rat
  weight : Rat
  friction : Bool
  cooldown : Nat
  callsThisEpoch : Nat
  actor : ActorState
  minted : Nat
  epochMinted : Nat
  lastRolloverEpoch : Epoch
  consumedNonces : Nonce → Bool
  pauseMinting : Bool
  pauseExpiry : Nat
  currentTime : Nat
  currentEpoch : Epoch
  prevEmission : Nat
  oracle : OracleState
  gov : GovernanceState
  deriving Repr

end DEASI.Emissions
