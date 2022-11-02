-:
	$(MAKE) recurse

install-script:
	install build.sh recursive
	install build.sh non-recursive
	
recurse:
	pushd recursive && ./build.sh && popd
non-recurse:
	pushd non-recursive && ./build.sh && popd

all: install-script
	$(MAKE) recurse
	$(MAKE) non-recurse
