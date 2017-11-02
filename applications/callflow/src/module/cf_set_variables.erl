%%%-------------------------------------------------------------------
%%% @copyright (C) 2013-2017, 2600Hz INC
%%% @doc
%%%
%%% "data":{
%%%   "custom_channel_vars": {"key": "value", "key": "value"},
%%%   "channel": "both", "self"
%%% }
%%%
%%% @end
%%% @contributors
%%%
%%%-------------------------------------------------------------------
-module(cf_set_variables).

-behaviour(gen_cf_action).

-include("callflow.hrl").

-export([handle/2]).

%%--------------------------------------------------------------------
%% @public
%% @doc
%% Entry point for this module
%% @end
%%--------------------------------------------------------------------
-spec handle(kz_json:object(), kapps_call:call()) -> 'ok'.
handle(Data, Call) ->
    JObj = get_custom_channel_vars(Data),
    Routines = [{fun kapps_call:insert_custom_channel_var/3, Key, Value}
                || {Key, Value} <- kz_json:to_proplist(JObj)
               ],
    _ = maybe_export(get_channel(Data), JObj, cf_exe:update_call(Call, Routines)),
    cf_exe:continue(Call).

-spec get_custom_channel_vars(kz_json:object()) -> kz_json:object().
get_custom_channel_vars(Data) ->
    JObj = kz_json:get_ne_value(<<"custom_channel_vars">>, Data, kz_json:new()),
    kz_json:from_list(kapps_call_util:filter_ccvs(JObj)).

-spec maybe_export(ne_binary(), kz_json:object(), kapps_call:call()) -> 'ok'.
maybe_export(<<"both">>, JObj, Call) ->
    kapps_call_command:set('undefined', JObj, Call);
maybe_export(_, JObj, Call) -> 
    kapps_call_command:set(JObj, 'undefined', Call).
    
-spec get_channel(kz_json:object()) -> ne_binary().
get_channel(Data) ->
    case kz_json:get_ne_binary_value(<<"channel">>, Data) of
        %$ added for backward compatability, should use self or both
        <<"a">> -> <<"self">>; 
        <<"both">> -> <<"both">>;
        _Else -> <<"self">>
    end.
