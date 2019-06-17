## AWS - S3
CONFIG								= s3://$(INFRA_BUCKET)/config/container/aptitus/dev4c/solr4

## RESULT_VARS ##
IMAGE_DEPLOY			?= $(PROJECT_NAME):$(BUILD_TIMESTAMP).$(BUILD_NUMBER)
DEPLOY_REGISTRY			?= $(ACCOUNT_ID).dkr.ecr.$(DEPLOY_REGION).amazonaws.com/$(IMAGE_DEPLOY)

upload-database-config-aws-solr: ####@aws subir config de base de datos a s3: make upload-database-config-aws
	aws s3 cp core/aptitud/conf/data-config.xml $(CONFIG)/aptitud/conf/ 
	aws s3 cp core/aviso/conf/data-config.xml $(CONFIG)/aviso/conf/
	aws s3 cp core/carrera/conf/data-config.xml $(CONFIG)/carrera/conf/
	aws s3 cp core/hobbie/conf/data-config.xml $(CONFIG)/hobbie/conf/
	aws s3 cp core/post_adquirido/conf/data-config.xml $(CONFIG)/post_adquirido/conf/
	aws s3 cp core/postulante/conf/data-config.xml $(CONFIG)/postulante/conf/
	aws s3 cp core/postulante_1/conf/data-config.xml $(CONFIG)/postulante_1/conf/
	aws s3 cp core/programas/conf/data-config.xml $(CONFIG)/programas/conf/
	aws s3 cp core/puesto/conf/data-config.xml $(CONFIG)/puesto/conf/
	aws s3 cp core/ubigeo/conf/data-config.xml $(CONFIG)/ubigeo/conf/

download-database-config-aws-solr:
	aws s3 cp $(CONFIG)/aptitud/conf/data-config.xml  core/aptitud/conf/data-config.xml 
	aws s3 cp $(CONFIG)/aviso/conf/data-config.xml core/aviso/conf/data-config.xml
	aws s3 cp $(CONFIG)/carrera/conf/data-config.xml core/carrera/conf/data-config.xml
	aws s3 cp $(CONFIG)/hobbie/conf/data-config.xml core/hobbie/conf/data-config.xml
	aws s3 cp $(CONFIG)/post_adquirido/conf/data-config.xml core/post_adquirido/conf/data-config.xml
	aws s3 cp $(CONFIG)/postulante/conf/data-config.xml core/postulante/conf/data-config.xml
	aws s3 cp $(CONFIG)/postulante_1/conf/data-config.xml core/postulante_1/conf/data-config.xml
	aws s3 cp $(CONFIG)/programas/conf/data-config.xml core/programas/conf/data-config.xml 
	aws s3 cp $(CONFIG)/puesto/conf/data-config.xml core/puesto/conf/data-config.xml 
	aws s3 cp $(CONFIG)/ubigeo/conf/data-config.xml core/ubigeo/conf/data-config.xml 

create-registry-solr: ####@all Create registry in aws ECR service: make create-registry
	aws cloudformation deploy \
	--template-file ./cloudformation/registry.yml \
	--stack-name $(PROJECT_NAME)-registry \
	--parameter-overrides \
		ProjectName=$(PROJECT_NAME) \
	--region $(DEPLOY_REGION) \
	--capabilities CAPABILITY_IAM

publish-solr: ## Push image to aws ECR: make publish
	docker tag $(IMAGE_DEPLOY) $(DEPLOY_REGISTRY)
	aws --region $(DEPLOY_REGION) ecr get-login --no-include-email | sh
	docker push $(DEPLOY_REGISTRY)

deploy-solr:
	sh $(PWD)/script/solr_sync.sh