#define FUSE_USE_VERSION 31

#include <fuse.h>
#include <stdio.h>
#include <string.h>
#include <errno.h>
#include <fcntl.h>
#include <stddef.h>
#include <assert.h>

static struct options {
	const char *filename;
	const char *contents;
	int show_help;
} options;

#define OPTION(t, p) \
{ t, offsetof(struct options, p), 1 }

static const struct fuse_opt option_spec[] = {
	OPTION("-h", show_help),
	OPTION("--help", show_help),
	FUSE_OPT_END
};

static void *main_init(struct fuse_conn_info *conn, struct fuse_config *cfg)
{
	(void) conn;
	cfg ->kernel_cache = 1;

	fuse_set_feature_flag(conn, FUSE_CAP_ASYNC_READ);
	fuse_unset_feature_flag(conn, FUSE_CAP_ASYNC_READ);

	return NULL;
}

static void show_help(const char *progname) { 
	printf("usage: %s [options] <mountpoint>\n\n", progname); 
	printf("filesystem specific options:\n" 
			"	--name=<s>	Name of the \"hello\" file\n" 
			"				(default: \"hello\")\n" 
			"	--contents=<s>	Contents \"hello\" file\n" 
			"				(default: \"Hello, world\\n\")\n" "\n"); 
}

static const struct fuse_operations main_oper = {
	.init = main_init,
};

int main(int argc, char *argv[])
{
	int ret;
	struct fuse_args args = FUSE_ARGS_INIT(argc, argv);

	// set default values
	options.filename = strdup("hello");
	options.contents = strdup("Hello world\n");

	if (fuse_opt_parse(&args, &options, option_spec, NULL) == -1)
		return 1;

	if (options.show_help) {
		show_help(argv[0]);
		assert(fuse_opt_add_arg(&args, "--help") == 0);
		args.argv[0][0] = '\0';
	}

	ret = fuse_main(args.argc, args.argv, &main_oper, NULL);
	fuse_opt_free_args(&args);
	return ret;
}


