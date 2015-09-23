#include <stdio.h>
#include <stdbool.h>
#include <mpd/client.h>
#include <sys/select.h>

static void handle(void);
static int init(char const *host);
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
	if (mpd_connection_get_error(con) != MPD_ERROR_SUCCESS) {
		fprintf(stderr, "could not receive wakeup: %s\n",
		        mpd_connection_get_error_message(con));
		running = false;
	}
	query();
}

static int
init(char const *host)
{
	int unsigned port = 0; /* default */

	con = mpd_connection_new(host, port, 0);
	if (mpd_connection_get_error(con) != MPD_ERROR_SUCCESS) {
		fprintf(stderr, "could not connect to %s: %s\n",
		        host, mpd_connection_get_error_message(con));
		return -1;
	}
	fd = mpd_connection_get_fd(con);
	if (fd <= 0) {
		fprintf(stderr, "could not get file descriptor: %s\n",
		        mpd_connection_get_error_message(con));
		return -1;
	}
	return 0;
}

static void
query(void)
{
	struct mpd_status *status;

	mpd_send_status(con);
	status = mpd_recv_status(con);
	if (status == NULL) {
		fprintf(stderr, "could not get status: %s\n",
		        mpd_connection_get_error_message(con));
		running = false;
		return;
	}
	if (!mpd_status_get_consume(status)) {
		if (!mpd_run_consume(con, true)) {
			fprintf(stderr, "could not run consume mode: %s\n",
			        mpd_connection_get_error_message(con));
			running = false;
			return;
		}
	}
	if (!mpd_send_idle_mask(con, MPD_IDLE_OPTIONS)) {
		fprintf(stderr, "could not send idle mask: %s\n",
		        mpd_connection_get_error_message(con));
	}
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
}

int
main(int argc, char **argv)
{
	if (argc != 2) {
		fprintf(stderr, "Usage: %s HOST\n", argv[0]);
		return 2;
	}
	if (init(argv[1]) < 0)
		return 1;
	run();
	term();
	return 0;
}
