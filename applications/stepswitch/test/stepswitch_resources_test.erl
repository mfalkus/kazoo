%%%-------------------------------------------------------------------
%%% @copyright (C) 2017, 2600Hz
%%% @doc
%%% Account document
%%% @end
%%% @contributors
%%% 
%%%-------------------------------------------------------------------
-module(stepswitch_resources_test).

-include_lib("eunit/include/eunit.hrl").
-include("src/stepswitch.hrl").

-define(RESOURCE_1_ID, <<"resource000000000000000000000001">>).

check_fixtures_test_() ->
    {'ok', Schema} = kz_json_schema:fload(<<"resources">>),
    {'ok', Resources} = kz_json:fixture(?APP, <<"fixtures/resources/global.json">>),
    [{"validate resource fixture", ?_assertMatch({'ok', _}, validate(Schema, Resource))}
    || Resource <- Resources
    ].

invite_parameters_test_() ->
   {'ok', Offnet} = kz_json:fixture(?APP, <<"fixtures/offnet_req/global.json">>),
   _ = stepswitch_resources:fetch_global_resources(),
   [].

validate(Schema, Object) ->
    kz_json_schema:validate(Schema
                           ,Object
                           ,[{'schema_loader_fun', fun kz_json_schema:fload/1}]
                           ).
