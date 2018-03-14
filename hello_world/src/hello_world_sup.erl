-module(hello_world_sup).

-behaviour(supervisor).

-export([start_link/0, init/1]).

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

init([]) ->
    ElliOpts = [{callback, my_elli_handler}, {port, 3000}],
    ElliSpec = #{id => my_elli_server,
                 start => {elli, start_link, [ElliOpts]},
                 restart => permanent,
                 shutdown => 5000,
                 type => worker,
                 modules => [elli]},
    SupFlags = #{strategy => one_for_one,
                 intensity => 5,
                 period => 10},
    {ok, {SupFlags, [ElliSpec]}}.
