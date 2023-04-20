## lekovr.github.io
## Static site powered by hugo
#:
SHELL      = /bin/sh
CFG       ?= .env
CFGSAMPLE ?= $(CFG).sample
DOT       := .
DASH      := -

APP_SITE        ?= lekovr.dev.lan
APP_TAG         ?= $(subst $(DOT),$(DASH),$(APP_SITE))
USE_TLS         ?= false
APP_ROOT        ?= $(PWD)
DCAPE_TAG       ?= dcape
DCAPE_NET       ?= dcape

IMAGE                ?= peaceiris/hugo
IMAGE_VER            ?= 0.110.0
DC_IMAGE             ?= dcape-compose
DC_VER               ?= latest

define CONFIG_DEF
# ------------------------------------------------------------------------------
# lekovr.github.io settings

# website host
APP_SITE=$(APP_SITE)

# Unique traefik router name
# Container name prefix
# Value is optional, derived from APP_SITE if empty
# APP_TAG=$(APP_TAG)

# Enable tls in traefik
# Values: [false]|true
USE_TLS=$(USE_TLS)

# hugo image name
IMAGE=$(IMAGE)

# hugo image version
IMAGE_VER=$(IMAGE_VER)

endef
export CONFIG_DEF

-include $(CFG)
export

.PHONY: all cfg  start start-hook stop update up reup down dc help

all: help

# ------------------------------------------------------------------------------
## docker commands
#:

## start containers
up:
up: CMD=up -d www
up: dc

## restart and recreate containers
reup:
reup: CMD=up --force-recreate -d www
reup: dc

## stop & remove container(s)
down:
down: CMD=rm -f -s
down: dc

# $$PWD usage allows host directory mounts in child containers
# Thish works if path is the same for host, docker, docker-compose and child container
## run $(CMD) via docker-compose
dc: docker-compose.yml
	@docker run --rm  -i \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $$PWD:$$PWD -w $$PWD \
  -e DCAPE_TAG -e DCAPE_NET -e APP_ROOT -e APP_TAG \
  $(DC_IMAGE):$$DC_VER \
  -p $(APP_TAG) --env-file $(CFG) \
  $(CMD)

# ------------------------------------------------------------------------------
## hugo commands
#:

## init new hugo site
init: CMD=run app hugo new site .
init: dc

## generate site
gen: CMD=run app
gen: dc

## run hugo server
run: CMD=up -d dev
run: dc
run: log-and-down

# see https://stackoverflow.com/a/32788564
log-and-down:
	@bash -c "trap 'trap - SIGINT SIGTERM ERR; $(MAKE) -s down' SIGINT SIGTERM ERR; docker logs -f $(APP_TAG)_dev_1"

# ------------------------------------------------------------------------------
## Application setup
#:

## generate config file
## (if not exists)
init:
	@[ -f $(CFG) ] && { echo "$(CFG) already exists. Skipping" ; exit 0 ; } || true
	@echo "$$CONFIG_DEF" > $(CFG)

## generate config sample
## (if .env exists, its values will be used)
config: $(CFGSAMPLE)

$(CFGSAMPLE):
	@echo "$$CONFIG_DEF" > $(CFGSAMPLE)


# ------------------------------------------------------------------------------
## Other
#:

# This code handles group header and target comment with one or two lines only
## list Makefile targets
## (this is defailt target)
help:
	@grep -A 1 -h "^## " $(MAKEFILE_LIST) \
  | sed -E 's/^--$$// ; /./{H;$$!d} ; x ; s/^\n## ([^\n]+)\n(## (.+)\n)*(.+):(.*)$$/"    " "\4" "\1" "\3"/' \
  | sed -E 's/^"    " "#" "(.+)" "(.*)"$$/"" "" "" ""\n"\1 \2" "" "" ""/' \
  | xargs printf "%s\033[36m%-15s\033[0m %s %s\n"
