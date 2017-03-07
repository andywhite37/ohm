
build:
	haxe build.hxml

copy-client-assets:
	mkdir -p bin/public
	cp -r src/ohm/client/public bin

run: build copy-client-assets
	node bin/server.js
