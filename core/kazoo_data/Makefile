ROOT = ../..
PROJECT = kazoo_data

SOURCES = src/kz_data.erl src/*.erl

ERLC_OPTS += +'{lager_extra_sinks, [data]}'

all: compile

-include $(ROOT)/make/kz.mk
