/*
 * A test for mckernel bug#284
 *   "Copy-on-write: host misses anonymous page is converted writable page"
 */

#include <fcntl.h>
#include <inttypes.h>
#include <string.h>
#include <unistd.h>
#include <sys/mman.h>

#include "test.h"
#include "usctest.h"
#include "safe_macros.h"

char *TCID = "bug284";
int TST_TOTAL = 1;

static size_t pgsize = 0;
static int workfd = -1;
static int zerofd = -1;
static uint8_t *zeroed_page = NULL;
static uint8_t *pa = MAP_FAILED;
static size_t pasize = 0;

static void cleanup(void)
{
	if (pa != MAP_FAILED) {
		munmap(pa, pasize);
	}
	free(zeroed_page);
	if (zerofd >= 0) {
		close(zerofd);
	}
	if (workfd >= 0) {
		close(workfd);
	}
	tst_rmdir();
	return;
}

static void setup(void)
{
	TEST_PAUSE;
	tst_tmpdir();
	pgsize = SAFE_SYSCONF(cleanup, _SC_PAGESIZE);
	workfd = SAFE_OPEN(cleanup, "test_file", O_CREAT|O_WRONLY, 0666);
	zerofd = SAFE_OPEN(cleanup, "/dev/zero", O_RDONLY, 0);
	zeroed_page = SAFE_MALLOC(cleanup, pgsize);
	memset(zeroed_page, 0, pgsize);
	return;
}

static void test(void)
{
	void *saved_pa;

	/* (1) create a copy-on-write page */
	pasize = pgsize;
	pa = SAFE_MMAP(cleanup, NULL, pasize, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1, 0);

	/* (2) populate the a.out's PTE of the page */
	*(volatile uint8_t *)pa;

	/* (3) populate the mcexec's PTE of the page */
	SAFE_WRITE(cleanup, pgsize, workfd, pa, pgsize);

	/* (4) make sure that the copying of the page has done */
	memset(pa, 0xE5, pgsize);

	/* (5) check if the mcexec's PTE maps the latest physical page of the page */
	SAFE_READ(cleanup, pgsize, zerofd, pa, pgsize);
	if (memcmp(pa, zeroed_page, pgsize)) {
		int i;

		tst_resm(TFAIL, "remote page fault at a populated copy-on-write page");
		for (i = 0; i < (long)pgsize; ++i) {
			if (pa[i] != zeroed_page[i]) {
				tst_resm(TINFO, "pa[%#x]: %x. %x expected.", i, pa[i] , zeroed_page[i]);
				break;
			}
		}
	}
	else {
		tst_resm(TPASS, "remote page fault at a populated copy-on-write page");
	}

	saved_pa = pa;
	pa = MAP_FAILED;
	SAFE_MUNMAP(cleanup, saved_pa, pasize);
	return;
}

int main(int argc, char *argv[])
{
	int lc;

	tst_parse_opts(argc, argv, NULL, NULL);
	setup();

	for (lc = 0; TEST_LOOPING(lc); ++lc) {
		tst_count = 0;
		test();
	}

	cleanup();
	tst_exit();
	return 1;
}
