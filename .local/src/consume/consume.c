#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <time.h>
#include <mpd/client.h>
#include <sys/select.h>

#define REASON mpd_connection_get_error_message(con)
#define FATAL(...) (void) fprintf(stderr, __VA_ARGS__); exit(2)

static void handle(void);
static void init(char const *host);
static void query(void);
static void run(void);
static void term(void);

static struct mpd_connection *con;
static int fd;
static bool running;

static void
handle(void)
{
	mpd_recv_idle(con, true);
	if (mpd_connection_get_error(con) != MPD_ERROR_SUCCESS)
		FATAL("could not receive wakeup: %s\n", REASON);
	query();
}

static void
init(char const *host)
{
	int unsigned port = 0; /* default */

	con = mpd_connection_new(host, port, 0);
	if (mpd_connection_get_error(con) != MPD_ERROR_SUCCESS)
		FATAL("could not connect to %s: %s\n", host, REASON);
	fd = mpd_connection_get_fd(con);
	if (fd <= 0)
		FATAL("could not get file descriptor: %s\n", REASON);
}

static void
query(void)
{
	struct mpd_status *status;
	time_t rawtime;
	struct tm *date;

	mpd_send_status(con);
	status = mpd_recv_status(con);
	if (status == NULL)
		FATAL("could not get status: %s\n", REASON);
	if (!mpd_status_get_consume(status)) {
		rawtime = time(NULL);
		date = localtime(&rawtime);
		(void) printf("%04d-%02d-%02dT%02d:%02d:%02d trigger!\n",
		               date->tm_year + 1900, date->tm_mon + 1,
		               date->tm_mday, date->tm_hour, date->tm_min,
		               date->tm_sec);
		if (!mpd_run_consume(con, true))
			FATAL("could not get consume state: %s\n", REASON);
	}
	if (!mpd_send_idle_mask(con, MPD_IDLE_OPTIONS))
		FATAL("could not set idle mask: %s\n", REASON);
}

static void
run(void)
{
	fd_set fds;
	int s;

	query();
	running = true;
	while (running) {
		FD_ZERO(&fds);
		FD_SET(fd, &fds);
		s = select(FD_SETSIZE, &fds, NULL, NULL, NULL);
		if (s <= 0)
			break;
		handle();
	}
}

static void
term(void)
{
	mpd_connection_free(con);
}

int
main(int argc, char **argv)
{
	if (argc != 2) {
		fprintf(stderr, "Usage: %s HOST\n", argv[0]);
		return 1;
	}
	init(argv[1]);
	run();
	term();
	return 0;
}
