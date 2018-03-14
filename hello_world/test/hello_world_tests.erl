-module(hello_world_tests).
-include_lib("eunit/include/eunit.hrl").

%% Integration test
%%   Uses inets httpc to call the Elli app over the network.
%%
%%   In your application you may prefer to use a third party HTTP
%%   client such as Hackney.
hello_world_test() ->
    inets:start(),
    hello_world_sup:start_link(),

    {ok, Response1} = httpc:request("http://localhost:3000/hello/world"),
    ?assertEqual(200, status(Response1)),
    ?assertEqual("Hello World!", body(Response1)),
    ?assertEqual([{"connection","Keep-Alive"},{"content-length","12"}],
                 headers(Response1)),

    {ok, Response2} = httpc:request("http://localhost:3000/hello/mum"),
    ?assertEqual(404, status(Response2)),
    ?assertEqual("Not Found", body(Response2)),
    ?assertEqual([{"connection","Keep-Alive"},{"content-length","9"}],
                 headers(Response2)).

status({{_, Status, _}, _, _}) -> Status.
body({_, _, Body})             -> Body.
headers({_, Headers, _})       -> lists:sort(Headers).
