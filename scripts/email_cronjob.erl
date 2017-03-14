-module(email_cronjob).

-compile(export_all).

% What should this look like?
% It will call the surfline API (this should be a process)
% That call can be synchronous
% When we get a reply from the surfline API, we read everybody in the DB, and send emails to them

