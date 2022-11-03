#PROJECT_NAME defaults to name of the current directory.
ifeq ($(project),)
PROJECT_NAME							:= $(notdir $(PWD))
else
PROJECT_NAME							:= $(project)
endif
export PROJECT_NAME
.PHONY: install-scripts recurse non-recurse non-recurse-google
-: install-scripts
	@git submodule update --init --recursive
install-scripts:
	@install build.sh   recursive
	@install build.sh   non-recursive
	@install build.sh   non-recursive-googletest
	@install autogen.sh recursive
	@install autogen.sh non-recursive
	@install autogen.sh non-recursive-googletest

recurse: install-scripts
	@cd ./recursive && ./autogen.sh && ./configure
	@make -C recursive
	#@make -C recursive/src
	#@make -C recursive/tests
	@lipo -info ./recursive/src/foo
	@lipo -info ./recursive/tests/passing
	@lipo -info ./recursive/tests/failing
non-recurse: install-scripts
	@cd ./non-recursive && ./autogen.sh && ./configure
	@make all -C non-recursive
	@lipo -info ./non-recursive/foo
	@lipo -info ./non-recursive/passing
	@lipo -info ./non-recursive/failing
non-recurse-google: install-scripts
	@cd ./non-recursive-googletest && ./autogen.sh && ./configure
	@make -C ./non-recursive-googletest
	#@make -C ./non-recursive-googletest/tests
	#@make -C ./non-recursive-googletest/google-tests
	@lipo -info ./non-recursive-googletest/foo
	#@lipo -info ./non-recursive-googletest/passing
	#@lipo -info ./non-recursive-googletest/failing
all: install-scripts
	$(MAKE) recurse
	#$(MAKE) -C recursive
	$(MAKE) non-recurse
	#$(MAKE) -C non-recursive
	$(MAKE) non-recurse-google
	#$(MAKE) -C non-recursive-googletest
clean:
	$(MAKE) distclean -C recursive
	$(MAKE) distclean -C non-recursive
	$(MAKE) distclean -C non-recursive-googletest

