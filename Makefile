
run:
	haxe build.hxml
	mkdir -p bin/public
	cp -r src/ohm/client/public bin
	node bin/server.js
