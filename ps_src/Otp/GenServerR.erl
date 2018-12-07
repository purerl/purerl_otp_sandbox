-module(otp_genServerR@foreign).
-export([start_/2, call_/3]).
-export([init/1, handle_call/3, handle_cast/2]).

-behaviour(gen_server).

start_(Spec, Args) ->
    gen_server:start(?MODULE, {Spec, Args}, []).

init({ Spec=#{ init := Init }, Args} ) ->
    {ok, State} = (Init(Args))(),
    {ok, {Spec, State}}.

handle_call({Label, Arg}, _From, {Spec = #{ call := Call }, State}) -> 
    F = maps:get(Label, Call),
    { _, Res, State2 } = ((F(Arg))(State))(),
    {reply, Res, {Spec, State2}}.

handle_cast({Label, Arg}, {Spec = #{ call := Call }, State}) -> 
    F = maps:get(Label, Call),
    { _, _UnitRes, State2 } = ((F(Arg))(State))(),
    {noreply, {Spec, State2}}.

call_(Label, Handle, A) -> gen_server:call(Handle, {Label, A}).