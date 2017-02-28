{application, 'hello_erlang', [
	{description, ""},
	{vsn, "rolling"},
	{modules, ['hello_erlang_app','hello_erlang_sup','hello_handler']},
	{registered, [hello_erlang_sup]},
	{applications, [kernel,stdlib,cowboy]},
	{mod, {hello_erlang_app, []}},
	{env, []}
]}.