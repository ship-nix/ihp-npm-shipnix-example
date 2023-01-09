ifneq ($(wildcard IHP/.*),)
IHP = IHP/lib/IHP
else
ifneq ($(wildcard build/ihp-lib),)
IHP = build/ihp-lib
else
ifneq ($(shell which RunDevServer),)
IHP = $(shell dirname $$(which RunDevServer))/../lib/IHP
else
IHP = $(error IHP not found! Run the following command to fix this:    nix-shell --run 'make .envrc'    )
endif
endif
endif

CSS_FILES += ${IHP}/static/vendor/bootstrap.min.css
CSS_FILES += ${IHP}/static/vendor/flatpickr.min.css

JS_FILES += ${IHP}/static/vendor/jquery-3.6.0.slim.min.js
JS_FILES += ${IHP}/static/vendor/timeago.js
JS_FILES += ${IHP}/static/vendor/popper.min.js
JS_FILES += ${IHP}/static/vendor/bootstrap.min.js
JS_FILES += ${IHP}/static/vendor/flatpickr.js
JS_FILES += ${IHP}/static/helpers.js
JS_FILES += ${IHP}/static/vendor/morphdom-umd.min.js
JS_FILES += ${IHP}/static/vendor/turbolinks.js
JS_FILES += ${IHP}/static/vendor/turbolinksInstantClick.js
JS_FILES += ${IHP}/static/vendor/turbolinksMorphdom.js

include ${IHP}/Makefile.dist

tailwind-dev:
	npm ci && tailwindcss -c frontend/tailwind.config.js -i frontend/app.css -o static/app.css --watch

js-dev:
	esbuild frontend/app.jsx --bundle --watch --sourcemap --outfile=static/app.js