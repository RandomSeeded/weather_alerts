-module(static_fileserver).
-compile(export_all).

start() ->
  inets:start(httpd,
    [{server_name,"NAME"},
      {document_root, "."},
      {server_root, "."},
      {port, 8000},
      {mime_types,
        [{"html","text/html"},
          {"htm","text/html"},
          {"js","text/javascript"},
          {"css","text/css"},
          {"gif","image/gif"},
          {"jpg","image/jpeg"},
          {"jpeg","image/jpeg"},
          {"png","image/png"}]}]).

