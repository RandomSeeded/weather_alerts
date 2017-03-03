#!/bin/bash

erlc *.erl
erl -noshell -run email_sender start
