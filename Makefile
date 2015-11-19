all: build

build:
	@docker build -t ${USER}/elasticsearch —-no-cache .
