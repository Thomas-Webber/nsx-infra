export TF_LOG=ERROR


help: 
	@fgrep -h "##" Makefile | fgrep -v "fgrep" | sed -r 's/(.*)(:)(.*)(##)(.*)/\1:\5/' - | column -s: -t | sed -e 's/##//'

init: ## Initialize and calculate diff
	terraform init
	terraform plan

run: ## Build the object
	terraform apply -auto-approve