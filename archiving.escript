#!/usr/bin/env escript
% Sets all pps stations in debug mode

main(_) ->
        data_cleanup().


data_cleanup() ->
    net_kernel:start([shell, shortnames]),
    erlang:set_cookie(node(), butler_server),
    {ok, Duration}=rpc:call(erlang:list_to_atom("butler_server@localhost"),application, get_env, [butler_server, db_archive_duration]),
        {CurrentDate, Time} =rpc:call(erlang:list_to_atom("butler_server@localhost"),calendar, universal_time, []),
        ArchiveDate = rpc:call(erlang:list_to_atom("butler_server@localhost"),calendar, gregorian_days_to_date, [rpc:call(erlang:list_to_atom("butler_server@localhost"),calendar, date_to_gregorian_days, $
        io:format("ArchiveDate: ~p~n",[ArchiveDate]),
        {A1,Auditarchive} = rpc:call(erlang:list_to_atom("butler_server@localhost"),db_archive, archive, [auditrec, [{status, in, [audit_aborted, audit_completed, audit_resolved, audit_reaudited, audit_c$
        {A2,Auditlinearchive} = rpc:call(erlang:list_to_atom("butler_server@localhost"),db_archive, archive, [auditlinerec1, [{updated_time, lessthan, {ArchiveDate, Time}}, {status, in, [audit_completed,$
        {A3,Orderarchive} = rpc:call(erlang:list_to_atom("butler_server@localhost"),db_archive, archive, [order_node, [{updated_time, lessthan, {ArchiveDate, Time}}, {status, in, [complete, unfulfillable$
        {A4,Putoutputarchive} = rpc:call(erlang:list_to_atom("butler_server@localhost"),db_archive, archive, [put_output1,  [{updated_time, lessthan, {ArchiveDate, Time}}, {status, equal, completed}]]),
        {A5,Putnodearchive} = rpc:call(erlang:list_to_atom("butler_server@localhost"),db_archive, archive, [put_node, [{updated_time, lessthan, {ArchiveDate, Time}}, {state, equal, complete}]]),
        io:format("AuditArchive: ~p~n",[Auditarchive]),
        io:format("AuditlineArchive: ~p~n",[Auditlinearchive]),
        io:format("OrderArchive: ~p~n",[Orderarchive]),
        io:format("PutOutputArchive: ~p~n",[Putoutputarchive]),
        io:format("PutNodeArchive: ~p~n",[Putnodearchive]),
        Result3=rpc:call(erlang:list_to_atom("butler_server@localhost"),pick_instruction, cleanup, []),
        case Result3 of
        ok ->
            io:format("PickInstruction Cleanup completed successfully ,~p~n", [Result3]);
        badrpc ->
            io:format("Error occured in archiving pick_instruction ,~p~n", [Result3]);
        _ ->
            io:format(" Something wrong happen ,~p~n", [Result3]) 
        end.

