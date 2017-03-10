
build:
	haxe build.hxml

assets:
	mkdir -p bin/public
	cp -r src/ohm/client/public bin

run: build assets
	nodemon bin/server.js
