-module(gen_server_external).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2]).

-behaviour(gen_server).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init(A) -> genServerExternal@ps:init(A).
handle_call(R,F,S) -> genServerExternal@ps:handle_call(R,F,S).
handle_cast(R,S) -> genServerExternal@ps:handle_cast(R,S).