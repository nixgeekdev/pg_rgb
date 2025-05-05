EXTENSION    = $(shell grep -m 1 '"name":' META.json | \
		sed -e 's/[[:space:]]*"name":[[:space:]]*"\([^"]*\)",/\1/')
EXTVERSION   = $(shell grep -m 1 '[[:space:]]\{6\}"version":' META.json | \
		sed -e 's/[[:space:]]*"version":[[:space:]]*"\([^"]*\)",\{0,1\}/\1/')
DISTVERSION  = $(shell grep -m 1 '[[:space:]]\{2\}"version":' META.json | \
		sed -e 's/[[:space:]]*"version":[[:space:]]*"\([^"]*\)",\{0,1\}/\1/')
MODULES      = src/$(EXTENSION)

DATA = $(wildcard sql/*--*.sql)
DOCS = $(wildcard doc/*.md)
TESTS = $(wildcard test/sql/*.sql)
REGRESS = $(patsubst test/sql/%.sql,%,$(TESTS))
REGRESS_OPTS = --inputdir=test
PG_CONFIG ?= pg_config
EXTRA_CLEAN = sql/$(EXTENSION)--$(EXTVERSION).sql
PGVERSION = $(shell $(PG_CONFIG) --version | cut -d. -f1 | cut -d' ' -f2)
ISVALIDPG = $(shell [ $(PGVERSION) -ge '13' ] && echo yes || echo no)

ifeq ($(ISVALIDPG),no)
$(error $(EXTENSION) requires PostgreSQL 13 or higher)
endif

PGXS := $(shell $(PG_CONFIG) --pgxs)
include $(PGXS)

all: sql/$(EXTENSION)--$(EXTVERSION).sql

sql/$(EXTENSION)--$(EXTVERSION).sql: sql/$(EXTENSION).sql
	cp $< $@

.PHONY: results
results:
	rsync -avP --delete results/ test/expected

dist:
	git archive --format zip --prefix=$(EXTENSION)-$(DISTVERSION)/ -o $(EXTENSION)-$(DISTVERSION).zip HEAD

latest-changes.md: Changes
	perl -e 'while (<>) {last if /^(v?\Q${DISTVERSION}\E)/; } print "Changes for v${DISTVERSION}:\n"; while (<>) { last if /^\s*$$/; s/^\s+//; print }' Changes > $@
