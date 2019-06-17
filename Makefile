.DEFAULT_GOAL := help

## GENERAL ##
OWNER 								= aptitus
SERVICE_NAME 					= solr4-6
VERSION         			= v1

## DEV ##
TAG										= 0.1.0
USER_ID  							= $(shell id -u)
GROUP_ID 							= $(shell id -g)

## DEPLOY ##
ENV										= dev
BRANCH								= dev4c
BUILD_NUMBER 					= 000001
BUILD_TIMESTAMP 			= 20181005
DEPLOY_REGION 				= eu-west-1
ACCOUNT_ID						= 929226109038
INFRA_BUCKET 					= infraestructura.$(ENV)

## RESULT_VARS ##
PROJECT_NAME			    = $(OWNER)-$(ENV)-$(SERVICE_NAME)
IMAGE_DEPLOY			    = $(PROJECT_NAME):$(TAG)

## DEFAULT ##
NETWORD					    	= orbis-training-$(PROJECT_NAME)
PATH_CORE							= $(PWD)/core

## CONECCION DB ##
SOLR_HOST							= v1s30b5.orbis.pe
SOLR_PORT							= 3307
SOLR_DATABASE 				= db_aptitus4c_dev
SOLR_DBUSER 					=	usr_aptit4c_dev
SOLR_DBPASSWORD 			=	PvyQo3tZsXJcNgqiYEKa

include cloudformation/Makefile

create-netword:
	docker network create -d bridge $(NETWORD)

build-solr: ##@all Construccion de la imagen
	docker build -f docker/solr/Dockerfile -t $(IMAGE_DEPLOY) docker/solr/;

push-solr:
	docker push $(REPOCITORY)

config-db-solr: 
	sh $(PWD)/script/config_db_solr.sh $(SOLR_HOST):$(SOLR_PORT) $(SOLR_DATABASE) $(SOLR_DBUSER) $(SOLR_DBPASSWORD) 

start-solr: ##@all Inicializamos
	make download-database-config-aws-solr;
	make config-db-solr;
	docker run -d -p 8983:8983 -it --name $(PROJECT_NAME) -v "$(PATH_CORE):/opt/solr/example/multicore" $(IMAGE_DEPLOY) 

stop-solr:
	docker stop $(PROJECT_NAME)

ssh-solr: ## Connect to conainer for ssh protocol
	docker exec -ti $(PROJECT_NAME) bash $(COMMAND)

## Sync
sync-config-deploy: ## Sync jenkins.private.yml from S3 before to push image to registry in aws: make sync-config-deploy
	aws s3 sync s3://${INFRA_BUCKET}/config/deploy/${OWNER}/${ENV}/${SERVICE_NAME}/ deploy/

HELP_FUNC = \
	%help; \
	while(<>) { \
		if(/^([a-z0-9_-]+): .*\#\#(?:@(\w+))? ([a-zA-Z\., ]+)(?: : (.*))?$$/) { \
			push(@{$$help{$$2}}, [$$1, $$3, $$4]); \
		} \
	}; \
	printf ("\033[31m %-30s %-45s %s\033[0m\n", "Target", "Help", "Usage"); \
	printf ("\033[31m %-30s %-45s %s\033[0m\n", "------", "----", "-----"); \
	for ( sort keys %help ) { \
		printf ("\033[33m%s:\033[0m\n", $$_); \
		printf("\033[32m %-20s\033[0m %-45s \033[34m%s\033[0m\n", $$_->[0], $$_->[1], $$_->[2]) for @{$$help{$$_}}; \
		print "\n"; \
	}

help: ##@all Show this help.
	@perl -e '$(HELP_FUNC)' $(MAKEFILE_LIST)

#start: ##@all Inicializamos
#	docker run -d -p 8983:8983  -v "$(PWD)/core:/opt/solr/example/multicore" -w "/opt/solr/example/multicore"  $(IMAGE_DEV) $(PROJECT_NAME)
