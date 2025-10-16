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

static int main_getattr(const char *path, struct stat *stbuf, struct fuse_file_info *fi)
{
	(void) fi;
	int res = 0;

	memset(stbuf, 0, sizeof(struct stat));
	if (strcmp(path, "/") == 0) {
		stbuf->st_mode = S_IFDIR | 0755;
		stbuf->st_nlink = 2;
	} else if (strcmp(path+1, options.filename) == 0) {
			stbuf->st_mode = S_IFREG | 0444;
			stbuf->st_nlink = 1;
			stbuf->st_size = strlen(options.contents);
	  } else
	  		res = -ENOENT;

	return res;
}

static int main_readdir(const char *path, void *buf, fuse_fill_dir_t filler,
			off_t offset, struct fuse_file_info *fi, enum fuse_readdir_flags flags)
{
	(void) offset;
	(void) fi;
	(void) flags;

	if (strcmp(path, "/") != 0)
		return -ENOENT;
	
	filler(buf, ".", NULL, 0, FUSE_FILL_DIR_DEFAULTS);
	filler(buf, "..", NULL, 0, FUSE_FILL_DIR_DEFAULTS);
	filler(buf, options.filename, NULL, 0, FUSE_FILL_DIR_DEFAULTS);

	return 0;
}

static int main_open(const char *path, struct fuse_file_info *fi)
{
	if(strcmp(path+1, options.filename) != 0)
		return -ENOENT;

	if ((fi->flags & O_ACCMODE) != O_RDONLY)
		return -EACCES;

	return 0;
}

static int main_read(const char *path, char *buf, size_t size, off_t offset,
		struct fuse_file_info *fi)
{
	size_t len;
	(void) fi;
	if(strcmp(path+1, options.filename) != 0)
		return -ENOENT;

	len = strlen(options.contents);
	if(offset < len) {
		if(offset + size > len)
			size = len - offset;
		memcpy(buf, options.contents + offset, size);
	} else
		size = 0;

	return size;
}

static int main_mkdir(const char *path, mode_t mode) 
{
	if(strcmp(path, "/") == 0)
		return -EEXIST;

	// For now only allow directory under root
	if(path[0] != '/' || strchr(path + 1, '/') != NULL)
			return -ENOENT;

	return 0;
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
	.getattr = main_getattr,
	.readdir = main_readdir,
	.open = main_open,
	.read = main_read,
	.mkdir = main_mkdir,
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


