/* karuiwm configuration */

#define FONTSTR "-misc-fixed-medium-r-semicondensed--13-120-75-75-c-60-iso8859-1"
#define NMASTER 1        /* number of clients in master area */
#define MFACT 0.5        /* size of master area */
#define BORDERWIDTH 1    /* window border width */
#define WSMBOXWIDTH 90   /* WSM box width */
#define WSMBOXHEIGHT 60  /* WSM box height */
#define WSMBORDERWIDTH 2 /* WSM box border width */
#define PADMARGIN 50     /* border gap for scratchpad workspace */
#define SESSIONFILE "/tmp/"APPNAME /* file for saving session when restarting */

/* colours */
#define CBORDERNORM      0x666666   /* normal windows */
#define CBORDERSEL       0xAFD700   /* selected windows */

#define CNORM            0x888888   /* status bar */
#define CBGNORM          0x222222

#define CSEL             0xCCCCCC
#define CBGSEL           0x444444

#define WSMCNORM         CNORM      /* WSM box of normal workspaces */
#define WSMCBGNORM       CBGNORM
#define WSMCBORDERNORM   CBGSEL

#define WSMCSEL          CSEL       /* WSM box of current workspace */
#define WSMCBGSEL        CBGSEL
#define WSMCBORDERSEL    CSEL

#define WSMCTARGET       CBORDERSEL /* WSM box of selected workspace */
#define WSMCBGTARGET     CBGSEL
#define WSMCBORDERTARGET CBORDERSEL

/* dmenu */
static char const *dmenuprompt[DMenuLAST] = {
	[DMenuRename]     = "rename",
	[DMenuSend]       = "send",
	[DMenuSendFollow] = "follow",
	[DMenuSpawn]      = "run",
	[DMenuView]       = "workspace",
	[DMenuClients]    = "client",
};
static char const *dmenuargs[] = { "-l", "10", "-i",
                                   "-nf", "#888888", "-nb", "#282828",
                                   "-sf", "#AFD800", "-sb", "#444444", NULL };

/* commands */
static char const *termcmd[] = { "urxvt", NULL };
static char const *scrotcmd[] = { "prtscr", NULL };
static char const *lockcmd[] = { "scrock", NULL };
static char const *volupcmd[] = { "amixer", "set", "Master", "2+", "unmute", NULL };
static char const *voldowncmd[] = { "amixer", "set", "Master", "2-", "unmute", NULL };
static char const *volmutecmd[] = { "amixer", "set", "Master", "toggle", NULL };
static char const *micmutecmd[] = { "amixer", "set", "Capture", "toggle", NULL };
static char const *musicplaypausecmd[] = { "mpc", "toggle", NULL };
static char const *musicnextcmd[] = { "mpc", "next", NULL };
static char const *musicprevcmd[] = { "mpc", "prev", NULL };
static char const *backlightupcmd[] = { "xbacklight", "+10", NULL };
static char const *backlightdowncmd[] = { "xbacklight", "-10", NULL };
static char const *dpasscmd[] = { "dpass", "-l", "10", "-i",
                                           "-nf", "#888888", "-nb", "#282828",
                                           "-sf", "#E0A0FF", "-sb", "#444444",
                                           "-p", "pass", NULL };

/* custom behaviour */
static void
custom_startup()
{
}

static void
custom_shutdown()
{
}

#define MODKEY Mod4Mask

/* normal keys */
static Key const keys[] = {
	/* applications */
	{ MODKEY,                       XK_n,       spawn,            { .v=termcmd } },
	{ MODKEY,                       XK_p,       dmenu,            { .i=DMenuSpawn } },
	{ MODKEY,                       XK_Print,   spawn,            { .v=scrotcmd } },
	{ MODKEY|ShiftMask,             XK_p,       spawn,            { .v=dpasscmd } },

	/* hardware */
	{ 0,                            0x1008FF11, spawn,            { .v=voldowncmd } },
	{ 0,                            0x1008FF12, spawn,            { .v=volmutecmd } },
	{ 0,                            0x1008FF13, spawn,            { .v=volupcmd } },
	{ 0,                            0x1008FF14, spawn,            { .v=musicplaypausecmd } },
	{ 0,                            0x1008FF16, spawn,            { .v=musicprevcmd } },
	{ 0,                            0x1008FF17, spawn,            { .v=musicnextcmd } },
	{ 0,                            0x1008FFB2, spawn,            { .v=micmutecmd } },
	{ MODKEY,                       XK_F8,      spawn,            { .v=backlightdowncmd } },
	{ MODKEY,                       XK_F9,      spawn,            { .v=backlightupcmd } },

	/* windows */
	{ MODKEY,                       XK_j,       stepfocus,        { .i=+1 } },
	{ MODKEY,                       XK_k,       stepfocus,        { .i=-1 } },
	{ MODKEY,                       XK_l,       setmfact,         { .f=+0.02 } },
	{ MODKEY,                       XK_h,       setmfact,         { .f=-0.02 } },
	{ MODKEY,                       XK_t,       togglefloat,      { 0 } },
	{ MODKEY|ShiftMask,             XK_c,       killclient,       { 0 } },
	{ MODKEY,                       XK_u,       dmenu,            { .i=DMenuClients } },

	/* layout */
	{ MODKEY|ShiftMask,             XK_j,       shiftclient,      { .i=+1 } },
	{ MODKEY|ShiftMask,             XK_k,       shiftclient,      { .i=-1 } },
	{ MODKEY,                       XK_comma,   setnmaster,       { .i=+1 } },
	{ MODKEY,                       XK_period,  setnmaster,       { .i=-1 } },
	{ MODKEY,                       XK_Return,  zoom,             { 0 } },
	{ MODKEY,                       XK_space,   steplayout,       { .i=+1 } },
	{ MODKEY|ShiftMask,             XK_space,   steplayout,       { .i=-1 } },

	/* workspaces */
	{ MODKEY|ControlMask,           XK_h,       stepws,           { .i=Left } },
	{ MODKEY|ControlMask,           XK_l,       stepws,           { .i=Right } },
	{ MODKEY|ControlMask,           XK_j,       stepws,           { .i=Down } },
	{ MODKEY|ControlMask,           XK_k,       stepws,           { .i=Up } },
	{ MODKEY|ControlMask|ShiftMask, XK_h,       sendfollowclient, { .i=Left } },
	{ MODKEY|ControlMask|ShiftMask, XK_l,       sendfollowclient, { .i=Right } },
	{ MODKEY|ControlMask|ShiftMask, XK_j,       sendfollowclient, { .i=Down } },
	{ MODKEY|ControlMask|ShiftMask, XK_k,       sendfollowclient, { .i=Up } },
	{ MODKEY,                       XK_o,       togglewsm,        { 0 } },
	{ MODKEY,                       XK_i,       dmenu,            { .i=DMenuView } },
	{ MODKEY|ShiftMask,             XK_i,       dmenu,            { .i=DMenuSend } },
	{ MODKEY|ShiftMask|ControlMask, XK_i,       dmenu,            { .i=DMenuSendFollow } },
	{ MODKEY,                       XK_r,       dmenu,            { .i=DMenuRename } },

	/* scratchpad */
	{ MODKEY,                       XK_Tab,     togglepad,        { 0 } },
	{ MODKEY|ShiftMask,             XK_Tab,     setpad,           { 0 } },

	/* monitors */
	{ MODKEY,                       XK_m,       stepmon,          { 0 } },

	/* session */
	{ MODKEY,                       XK_z,       spawn,            { .v=lockcmd } },
	{ MODKEY|ShiftMask,             XK_q,       restart,          { 0 } },
	{ MODKEY|ShiftMask|ControlMask, XK_q,       quit,             { 0 } },
};

/* WSM keys */
static Key const wsmkeys[] = {
	/* applications */
	{ MODKEY,                       XK_Print,   spawn,            { .v=scrotcmd } },

	/* hardware */
	{ 0,                            0x1008FF11, spawn,            { .v=voldowncmd } },
	{ 0,                            0x1008FF12, spawn,            { .v=volmutecmd } },
	{ 0,                            0x1008FF13, spawn,            { .v=volupcmd } },
	{ 0,                            0x1008FF14, spawn,            { .v=musicplaypausecmd } },
	{ 0,                            0x1008FF16, spawn,            { .v=musicprevcmd } },
	{ 0,                            0x1008FF17, spawn,            { .v=musicnextcmd } },
	{ 0,                            0x1008FFB2, spawn,            { .v=micmutecmd } },

	/* workspaces */
	{ MODKEY,                       XK_h,       stepwsmbox,       { .i=Left } },
	{ MODKEY,                       XK_l,       stepwsmbox,       { .i=Right } },
	{ MODKEY,                       XK_j,       stepwsmbox,       { .i=Down } },
	{ MODKEY,                       XK_k,       stepwsmbox,       { .i=Up } },
	{ MODKEY|ShiftMask,             XK_h,       shiftws,          { .i=Left } },
	{ MODKEY|ShiftMask,             XK_l,       shiftws,          { .i=Right } },
	{ MODKEY|ShiftMask,             XK_j,       shiftws,          { .i=Down } },
	{ MODKEY|ShiftMask,             XK_k,       shiftws,          { .i=Up } },
	{ 0,                            XK_Escape,  togglewsm,        { 0 } },
	{ 0,                            XK_Return,  viewws,           { 0 } },
};

/* mouse buttons */
static Button const buttons[] = {
	{ MODKEY,                       Button1,    movemouse,        { 0 } },
	{ MODKEY,                       Button3,    resizemouse,      { 0 } },
};

