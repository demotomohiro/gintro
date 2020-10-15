# This is additional libnice wrapper code.

# Add `nice_agent_attach_recv` that is not introspectable.
# https://gitlab.freedesktop.org/libnice/libnice/-/issues/37
proc nice_agent_attach_recv(
    self: ptr Agent00;
    streamId: uint32;
    componentId: uint32;
    ctx: ptr glib.MainContext00;
    `func`: AgentRecvFunc;
    data: pointer): gboolean {.
    importc, libprag.}

proc attachRecv*(
    self: Agent;
    streamId: int;
    componentId: int;
    ctx: glib.MainContext;
    `func`: AgentRecvFunc;
    data: pointer): bool =
  toBool(
    nice_agent_attach_recv(
      cast[ptr Agent00](self.impl),
      uint32(streamId),
      uint32(componentId),
      cast[ptr glib.MainContext00](ctx.impl),
      `func`,
      data))

when defined(windows):
  import winlean
else:
  import posix

type
  # See https://gitlab.freedesktop.org/libnice/libnice/-/blob/master/agent/address.h
  NiceAddress* {.union.} = object
    `addr`*: SockAddr
    ip4*: Sockaddr_in
    ip6*: Sockaddr_in6

  # See https://gitlab.freedesktop.org/libnice/libnice/-/blob/master/agent/candidate.h
  NiceCandidate* {.pure.} = object
    `type`*: CandidateType
    transport*: CandidateTransport
    `addr`*: NiceAddress
    baseAddr*: NiceAddress
    priority*: uint32
    streamId*: uint32
    componentId*: uint32
    foundation*: array[0 .. (CANDIDATE_MAX_FOUNDATION.int - 1), char]
    username*: cstring
    password*: cstring

