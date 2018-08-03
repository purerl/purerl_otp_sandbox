-module(otp_genServerF@foreign).
% FFI exports
-export([start/3, start_/2, startLink/3, startLink_/2]).
% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2]).
-behaviour(gen_server).

% Stash the spec in the args initially, and post-init in the state

start(ServerName, Spec, Args) -> fun () -> gen_server:start({local, ServerName}, ?MODULE, {Spec, Args}, []) end.
start_(Spec, Args) -> fun () -> gen_server:start(?MODULE, {Spec, Args}, []) end.
startLink(ServerName, Spec, Args) -> fun () -> gen_server:start_link({local, ServerName}, ?MODULE, {Spec, Args}, []) end.
startLink_(Spec, Args) -> fun () -> gen_server:start_link(?MODULE, {Spec, Args}, []) end.

init({ Spec=#{ init := Init }, Args} ) ->
    {ok, State} = (Init(Args))(),
    {ok, {Spec, State}}.

handle_call(Call, _From, {Spec = #{ handleCall := HandleCall }, State}) -> 
    {reply, Reply, State2} = ((HandleCall(Call))(State))(),
    {reply, Reply, {Spec, State2}}.

handle_cast(Cast, {Spec = #{ handleCast := HandleCast }, State}) -> 
    {noreply, State2} = ((HandleCast(Cast))(State))(),
    {noreply, {Spec, State2}}.
