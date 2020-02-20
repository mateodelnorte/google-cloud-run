REGION=us-central1
PROJECT_ID=entrepreneurishment
SERVICE_NAME=google-cloud-run-example

build-container:
	docker build . --tag gcr.io/$(PROJECT_ID)/$(SERVICE_NAME)

build-and-push-container: gcloud-ensure-project
	gcloud builds submit --tag gcr.io/$(PROJECT_ID)/$(SERVICE_NAME)

gcloud-auth:
	gcloud auth login

gcloud-project-select:
	gcloud config set project $(PROJECT_ID)

gcloud-ensure-project:
	@if [ "`gcloud config get-value project`" != "`echo $(PROJECT_ID)`" ]; then \
			echo "Warning: gcloud project not set to $(PROJECT_ID). Run 'make gcloud-project-select'"; \
			exit 1; \
	fi

gcloud-deploy-image: gcloud-ensure-project
	gcloud run deploy $(SERVICE_NAME) --image gcr.io/$(PROJECT_ID)/$(SERVICE_NAME) --platform managed --region $(REGION) --allow-unauthenticated

gcloud-get-deployed-url:
	gcloud run services describe $(SERVICE_NAME) --platform=managed --region=$(REGION) | grep https://