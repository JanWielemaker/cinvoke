LDSOFLAGS += -Wall -shared -O2 -gdwarf-2 -g3 -L/usr/local/opt/libffi/lib/ ${SWISOLIB}
MAKE=make
PACKSODIR=lib/$(SWIARCH)
FFI4PL=lib/$(SWIARCH)/ffi4pl.$(SOEXT)
LIBS=-lffi
CFLAGS += -shared -fPIC -I/usr/local/Cellar/libffi/3.2.1/lib/libffi-3.2.1/include
TESTS=test_mode test_marshall test_enum test_struct test_union test_funcptr
TESTSO=$(addprefix test/$(SWIARCH)/, $(addsuffix .$(SOEXT), $(TESTS)))

all:	env $(FFI4PL)

ifeq ($(SOEXT),)
env::
	@echo "Please use . buildenv.sh to setup the environment"
	@exit 1
else
env::
endif

$(FFI4PL): c/ffi4pl.c c/cmemory.c Makefile
	mkdir -p $(PACKSODIR)
	$(CC) $(CFLAGS) $(LDSOFLAGS) -o $@ c/ffi4pl.c $(LIBS)

test/$(SWIARCH)/%.$(SOEXT): test/%.c
	mkdir -p test/$(SWIARCH)
	$(CC) $(CFLAGS) -o $@ $<

$(TESTSO): env


tags:
	etags c/*.[ch]

check:	$(TESTSO)
	$(SWIPL) -q -g test_cmem -t halt test/test_cmem.pl
	$(SWIPL) -q -g test_mode -t halt test/test_mode.pl
	$(SWIPL) -q -g test_marshall -t halt test/test_marshall.pl
	$(SWIPL) -q -g test_enum -t halt test/test_enum.pl
	$(SWIPL) -q -g test_struct -t halt test/test_struct.pl
	$(SWIPL) -q -g test_union -t halt test/test_union.pl
	$(SWIPL) -q -g test_funcptr -t halt test/test_funcptr.pl
	$(SWIPL) -q -g test_qsort -t halt test/test_qsort.pl
	$(SWIPL) -q -g test_libc -t halt test/test_libc.pl

install::

clean:
	rm -f *~
	rm -f test/*.$(SOEXT)

distclean: clean
	rm -f $(FFI4PL)

