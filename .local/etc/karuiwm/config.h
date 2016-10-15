/* karuiwm configuration */

#define FONTSTR "-misc-fixed-medium-r-semicondensed--13-120-75-75-c-60-iso8859-1"
#define FONTSTR_DMENU "Fixed-10:SemiCondensed:Medium"
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
static char const *dmenuargs[] = { "-l", "10", "-i", "-fn", FONTSTR_DMENU,
                                   "-nf", "#888888", "-nb", "#282828",
                                   "-sf", "#AFD800", "-sb", "#444444", NULL };

/* commands */
#define XRANDRCMD(D) { "xrandr", "--output", "LVDS1", "--rotate", D, NULL }
static char const *xrandrup[] = XRANDRCMD("normal");
static char const *xrandrleft[] = XRANDRCMD("left");
static char const *xrandrright[] = XRANDRCMD("right");
static char const *xrandrdown[] = XRANDRCMD("inverted");
static char const *termcmd[] = { "urxvt", NULL };
static char const *scrotcmd[] = { "prtscr", NULL };
static char const *scrotcmd_sel[] = { "prtscr", "-s", NULL };
static char const *lockcmd[] = { "xtrlock", NULL };
static char const *volupcmd[] = { "amixer", "set", "Master", "2+", "unmute", NULL };
static char const *voldowncmd[] = { "amixer", "set", "Master", "2-", "unmute", NULL };
static char const *volmutecmd[] = { "amixer", "set", "Master", "toggle", NULL };
static char const *micmutecmd[] = { "amixer", "set", "Capture", "toggle", NULL };
static char const *musicplaypausecmd[] = { "mpc", "toggle", NULL };
static char const *musicnextcmd[] = { "mpc", "next", NULL };
static char const *musicprevcmd[] = { "mpc", "prev", NULL };
static char const *karuibarrestartcmd[] = { "pkill", "-USR1", "karuibar", NULL };
static char const *karuibartogglecmd[] = { "pkill", "-USR2", "karuibar", NULL };
static char const *backlightupcmd[] = { "xbacklight", "-steps", "1", "+5", NULL };
static char const *backlightdowncmd[] = { "xbacklight", "-steps", "1", "-5", NULL };
static char const *suspendcmd[] = { "systemctl", "suspend", NULL };
static char const *demotecmd[] = { "demote", "-l", "10", "-i",
                                             "-nf", "#888888", "-nb", "#282828",
                                             "-sf", "#FFE0A0", "-sb", "#444444",
                                             "-p", "emote", "-fn", FONTSTR_DMENU,
                                             NULL };
static char const *dpasscmd[] = { "dpass", "-l", "10", "-i",
                                           "-nf", "#888888", "-nb", "#282828",
                                           "-sf", "#E0A0FF", "-sb", "#444444",
                                           "-p", "pass", "-fn", FONTSTR_DMENU,
                                           NULL };

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
	{ MODKEY|ShiftMask,             XK_Print,   spawn,            { .v=scrotcmd } },
	{ MODKEY,                       XK_Print,   spawn,            { .v=scrotcmd_sel } },
	{ MODKEY|ShiftMask,             XK_p,       spawn,            { .v=dpasscmd } },
	{ MODKEY,                       XK_e,       spawn,            { .v=demotecmd } },
	{ MODKEY,                       XK_b,       spawn,            { .v=karuibartogglecmd } },
	{ MODKEY|ShiftMask,             XK_b,       spawn,            { .v=karuibarrestartcmd } },

	/* hardware */
#ifdef _phobia
	{ MODKEY|ControlMask,           XK_Up,      spawn,            { .v=volupcmd } },
	{ MODKEY|ControlMask,           XK_Down,    spawn,            { .v=voldowncmd } },
#endif
	{ 0,                            0x1008FF11, spawn,            { .v=voldowncmd } },
	{ 0,                            0x1008FF12, spawn,            { .v=volmutecmd } },
	{ 0,                            0x1008FF13, spawn,            { .v=volupcmd } },
	{ 0,                            0x1008FF14, spawn,            { .v=musicplaypausecmd } },
	{ 0,                            0x1008FF16, spawn,            { .v=musicprevcmd } },
	{ 0,                            0x1008FF17, spawn,            { .v=musicnextcmd } },
	{ 0,                            0x1008FFB2, spawn,            { .v=micmutecmd } },
#ifdef ACPI_IS_AN_ABSOLUTE_LOAD_OF_SHIT
	{ MODKEY,                       XK_F8,      spawn,            { .v=backlightdowncmd } },
	{ MODKEY,                       XK_F9,      spawn,            { .v=backlightupcmd } },
	{ MODKEY,                       XK_F4,      spawn,            { .v=suspendcmd } },
#endif

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
	{ MODKEY|ShiftMask,             XK_Up,      spawn,            { .v=xrandrup } },
	{ MODKEY|ShiftMask,             XK_Down,    spawn,            { .v=xrandrdown } },
	{ MODKEY|ShiftMask,             XK_Left,    spawn,            { .v=xrandrleft } },
	{ MODKEY|ShiftMask,             XK_Right,   spawn,            { .v=xrandrright } },

	/* session */
	{ MODKEY,                       XK_z,       spawn,            { .v=lockcmd } },
	{ MODKEY|ShiftMask,             XK_q,       restart,          { 0 } },
	{ MODKEY|ShiftMask|ControlMask, XK_q,       quit,             { 0 } },
};

/* WSM keys */
static Key const wsmkeys[] = {
	/* applications */
	{ MODKEY|ShiftMask,             XK_Print,   spawn,            { .v=scrotcmd } },
	{ MODKEY,                       XK_Print,   spawn,            { .v=scrotcmd_sel } },

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
	{ MODKEY,                       Button4,    spawn,            { .v=volupcmd } },
	{ MODKEY,                       Button5,    spawn,            { .v=voldowncmd } },
};

