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
	
# Generates the client via openapi-generator
generate-client:
	@which openapi-generator > /dev/null || \
	(echo "openapi-generator command not found. You'll need to install it or add it to your path before continuing" && exit 1)

	openapi-generator generate -i build/kroger-public-openapi/kroger_public_openAPIv3.yml -g go -o . \
	--additional-properties=disallowAdditionalPropertiesIfNotPresent=false,packageName=kroger,packageVersion=1.0.0,generateInterfaces=true,modelFileFolder=model,apiFileFolder=apis \
	--git-repo-id go-kroger-public \
	--git-user-id codyolsen

# Build the client.
build-client: download-repo generate-client
