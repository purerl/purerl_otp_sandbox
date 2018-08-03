-module(otp_genServer@foreign).
-export([start_/3, start/4, startLink_/3, startLink/4]).

start_(Module, Args, Options) -> fun () -> gen_server:start(Module, Args, Options) end.
start(ServerName, Module, Args, Options) -> fun () -> gen_server:start(ServerName, Module, Args, Options) end.

startLink_(Module, Args, Options) -> fun () -> gen_server:start_link(Module, Args, Options) end.
startLink(ServerName, Module, Args, Options) -> fun () -> gen_server:start_link(ServerName, Module, Args, Options) end.
