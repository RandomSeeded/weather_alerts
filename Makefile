PROJECT = surf_alert
PROJECT_DESCRIPTION = Surfs up
PROJECT_VERSION = 0.1.0

DEPS = cowboy mongodb
dep_cowboy_commit = master

dep_mongodb = git https://github.com/comtihon/mongodb-erlang.git v3.0.1

DEP_PLUGINS = cowboy

include erlang.mk
