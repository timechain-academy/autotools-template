-: install-scripts
	$(MAKE) recurse

install-scripts:
	install build.sh   recursive
	install build.sh   non-recursive
	install build.sh   non-recursive-googletest
	install autogen.sh recursive
	install autogen.sh non-recursive
	install autogen.sh non-recursive-googletest
	
autotools:
	@autogen.sh
recurse: install-scripts
	@cd recursive
	$(MAKE) autotools
	@build.sh && cd ..
non-recurse: install-scripts
	@cd non-recursive
	$(MAKE) autotools
	@build.sh && cd ..
non-recurse-google: install-scripts
	@cd non-recursive-googletest
	$(MAKE) autotools
	@build.sh && cd ..
all: install-scripts
	# $(MAKE) recurse
	# $(MAKE) non-recurse
	# $(MAKE) non-recurse-google
