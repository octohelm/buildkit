VERSION = $(shell cat Dockerfile.version | grep "^FROM " | sed -e "s/FROM.*:v\{0,\}//g" )

dep:
	rm -rf ./buildkit
	git clone --depth 1 https://github.com/moby/buildkit.git ./buildkit

patch.%:
	cd ./buildkit && (curl https://github.com/moby/buildkit/compare/master...morlay:$*.patch | git apply -v)

patch: dep
	$(MAKE) patch.master

build:
	docker buildx build --push \
		--platform=linux/amd64,linux/arm64 \
		--tag=ghcr.io/octohelm/buildkit:main \
		--build-arg BUILDKIT_CONTEXT_KEEP_GIT_DIR=1 \
		./buildkit