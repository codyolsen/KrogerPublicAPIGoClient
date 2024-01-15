.PHONY: generate-client download-repo clean

clean:
	rm -rf build/*

# Download GitHub repository to build folder
download-repo:
	if [ ! -f build/kroger-public-openapi/kroger_public_openAPIv3.yml ]; then \
		git clone https://github.com/codyolsen/kroger-public-openapi.git ./build/kroger-public-openapi; \
	else \
		echo "OpenAPI Schema found"; \
	fi

# Generates the client via oapi-generator
generate-client:
	@which oapi-codegen > /dev/null || \
	(echo "\n oapi-codegen command not found. You'll need to install it with:\n \`go install github.com/deepmap/oapi-codegen/v2/cmd/oapi-codegen@latest\`\n" && exit 1)

	oapi-codegen -package kroger \
	-generate client,types \
	build/kroger-public-openapi/kroger_public_openAPIv3.yml > kroger.go

# Build the client.
build-client: download-repo generate-client
