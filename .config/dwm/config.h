//#include "lstack.c"       // additional layout to put stack on the left
//#include "grid.c"           //     "        "    "  arrange as Grid
//#include "column_master.c"  //     "        "    "  split master in columns
#include "bstack.c"         //     "        "    "  split screen vertically
#include "fibonacci.c"      //     "        "    "  arrange as Fibonacci
#include "push.c"           // move clients around in stack/master

/* See LICENSE file for copyright and license details. */

/* appearance */
static const char font[]            = "Fixed Medium Semi-Condensed 10";
//static const char font[]            = "-misc-fixed-medium-r-semicondensed--13-100-100-100-c-60-iso8859-1";
/* // orange
static const char normbordercolor[] = "#222222";
static const char selbordercolor[]  = "#E04613";
static const char normbgcolor[]     = "#222222";
static const char normfgcolor[]     = "#AAAAAA";
static const char selbgcolor[]      = "#E04613";
static const char selfgcolor[]      = "#FFFFFF";
*/
// blue
static const char normbordercolor[] = "#222222";
static const char selbordercolor[]  = "#4499CC";
static const char normbgcolor[]     = "#222222";
static const char normfgcolor[]     = "#999999";
static const char selbgcolor[]      = "#4499CC";
static const char selfgcolor[]      = "#FFFFFF";

static const unsigned int borderpx  = 3;        /* border pixel of windows */
static const unsigned int snap      = 20;       /* snap pixel */
static const Bool showbar           = True;     /* False means no bar */
static const Bool topbar            = True;     /* False means bottom bar */

/* tagging */
static const char *tags[] = { "1", "2", "3", "", "", "∫", "", "", "" };
#include "shiftview.c" // cycle through tags

static const Rule rules[] = {
	/* class            instance title         tags mask isfloating monitor */
	{ "Eog",            NULL,    NULL,         0,        True,      -1 },
	{ "Gimp",           NULL,    NULL,         0,        True,      -1 },
	{ "MPlayer",        NULL,    NULL,         0,        True,      -1 },
	{ "Nitrogen",       NULL,    NULL,         0,        True,      -1 },
	{ "Firefox",        NULL,    "Downloads",  0,        True,      -1 },
	{ "Xfce4-terminal", NULL,    "Scratchpad", 0,        True,      -1 },
	{ "Lxappearance",   NULL,    NULL,         0,        True,      -1 },
};

/* layout(s) */
static const float mfact      = 0.5; /* factor of master area size [0.05..0.95] */
static const int nmaster      = 1;    /* number of clients in master area */
static const Bool resizehints = False; /* True means respect size hints in tiled resizals */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "",      tile },    /* first entry is default */
	{ "",      bstack },
	{ "[M]",      monocle },
	{ "",      dwindle },
//	{ "",      ltile },
//	{ "###",      grid },
//	{ "",      col },
	{ .symbol = NULL,   .arrange = NULL    }, /* for cycling (see below) */
};

/* cycling through layouts (provided by bob127) here:
 * https://bbs.archlinux.org/viewtopic.php?pid=817499#p817499
 */
void nextlayout(const Arg *arg)
{
	Layout *l;
	for (l=(Layout *)layouts;l != selmon->lt[selmon->sellt];l++);
	if (l->symbol && (l + 1)->symbol)
		setlayout(&((Arg) { .v = (l + 1) }));
	else
		setlayout(&((Arg) { .v = layouts }));
}
void prevlayout(const Arg *arg)
{
	Layout *l;
	for (l=(Layout *)layouts;l != selmon->lt[selmon->sellt];l++);
	if (l != layouts && (l - 1)->symbol)
		setlayout(&((Arg) { .v = (l - 1) }));
	else
		setlayout(&((Arg) { .v = &layouts[LENGTH(layouts) - 2] }));
}

/* move and follow window to next tag */
void movefollowtag(const Arg *arg)
{
	Arg shifted;

	if (arg->i > 0) // move and follow to the right:
		shifted.ui = (selmon->tagset[selmon->seltags] << arg->i)
				| (selmon->tagset[selmon->seltags] >> (LENGTH(tags) - arg->i));
	else // move and follow to the left:
		shifted.ui = (selmon->tagset[selmon->seltags] >> (-arg->i))
				| (selmon->tagset[selmon->seltags] << (LENGTH(tags) + arg->i));
	
	// move and follow:
	tag(&shifted);
	view(&shifted);
}

/* move and follow window to next monitor */
void movefollowmon(const Arg *arg)
{
	tagmon(arg);
	focusmon(arg);
}

/* key definitions */
#define MODKEY Mod1Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *dmenucmd[] = { "dmenu_run", "-l", "10", "-b", "-fn", font,
		"-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbordercolor, "-sf",
		selfgcolor, "-p", "<>", NULL };
static const char *termcmd[]  = { "xfce4-terminal", NULL };
static const char *quitcmd[] = { "killall", "dwmloop", NULL };
static const char *lockcmd[] = { "slock", NULL };
static const char *volraisecmd[] = { "amixer", "set", "Master", "3+", "unmute", NULL };
static const char *vollowercmd[] = { "amixer", "set", "Master", "3-", "unmute", NULL };
static const char *volmutecmd[] = { "amixer", "set", "Master", "toggle", NULL };
static const char *prtscrcmd[] = { "scrot", "/home/ayekat/img/screenshots/%Y-%m-%d_%H%M%S.png", NULL };
static const char *dzenconkycmd[] = { "dzenconky", "restart", NULL };
static const char *redshiftcmd[] = { "redshifttoggle", NULL };
static const char *scratchpadcmd[] = { "xfce4-terminal", "--title", "Scratchpad", "--geometry", "175x52+150+50", NULL };

static Key keys[] = {
	/* modifier           key        function        argument */
	{ MODKEY,             XK_p,      spawn,          {.v = dmenucmd } },
	{ MODKEY|ControlMask, XK_j,      spawn,          {.v = termcmd } },
	{ MODKEY,             XK_Tab,    spawn,          {.v = scratchpadcmd } },
	{ 0,                  XK_Print,  spawn,          {.v = prtscrcmd } },
	{ MODKEY,             XK_b,      spawn,          {.v = dzenconkycmd } },
	{ MODKEY,             XK_r,      spawn,          {.v = redshiftcmd } },
	{ MODKEY|ShiftMask,   XK_c,      killclient,     {0} },

	// volume keys:
	{ 0,                  0x1008FF11,spawn,          {.v = vollowercmd } },
	{ MODKEY|ControlMask, XK_Down,   spawn,          {.v = vollowercmd } },
	{ 0,                  0x1008FF12,spawn,          {.v = volmutecmd } },
	{ 0,                  0x1008FF13,spawn,          {.v = volraisecmd } },
	{ MODKEY|ControlMask, XK_Up,     spawn,          {.v = volraisecmd } },

	// clients:
	{ MODKEY,             XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,             XK_k,      focusstack,     {.i = -1 } },
	{ MODKEY|ShiftMask,   XK_j,      pushdown,       {0} },
	{ MODKEY|ShiftMask,   XK_k,      pushup,         {0} },
	{ MODKEY,             XK_h,      setmfact,       {.f = -0.02} },
	{ MODKEY,             XK_l,      setmfact,       {.f = +0.02} },
	{ MODKEY,             XK_Return, zoom,           {0} },
	{ Mod5Mask,           XK_Return, zoom,           {0} },

	// layouts:
	{ MODKEY,             XK_comma,  incnmaster,     {.i = +1 } },
	{ MODKEY,             XK_period, incnmaster,     {.i = -1 } },
	{ MODKEY,             XK_space,  nextlayout,     {0} },
	{ MODKEY|ShiftMask,   XK_space,  prevlayout,     {0} },
	{ MODKEY,             XK_t,      togglefloating, {0} },

	// tags:
	{ MODKEY|ControlMask, XK_l,      shiftview,      {.i = +1 } },
	{ MODKEY|ControlMask, XK_h,      shiftview,      {.i = -1 } },
	{ MODKEY|ControlMask|ShiftMask,XK_l,movefollowtag,{.i = +1 } },
	{ MODKEY|ControlMask|ShiftMask,XK_h,movefollowtag,{.i = -1 } },
	{ MODKEY,             XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,   XK_0,      tag,            {.ui = ~0 } },

	// monitors:
	{ MODKEY,                       XK_m,      focusmon,      {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_m,      tagmon,        {.i = +1 } },
	{ MODKEY|ControlMask|ShiftMask, XK_m,      movefollowmon, {.i = +1 } },

	// tag keys (arranged in a square):
	TAGKEYS( XK_1, 0)
	TAGKEYS( XK_2, 1)
	TAGKEYS( XK_3, 2)
	TAGKEYS( XK_q, 3)
	TAGKEYS( XK_w, 4)
	TAGKEYS( XK_e, 5)
	TAGKEYS( XK_a, 6)
	TAGKEYS( XK_s, 7)
	TAGKEYS( XK_d, 8)

	// session commands:
	{ MODKEY,                       XK_z, spawn, {.v = lockcmd } },
	{ MODKEY|ShiftMask,             XK_z, quit,  {0} },
	{ MODKEY|ControlMask|ShiftMask, XK_z, spawn, {.v = quitcmd } },
};

/* button definitions */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkRootWin,           MODKEY,         Button1,        spawn,          {.v = termcmd } },

	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },

	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	/* Possible clicks:
	 * - ClkRootWin:    desktop
	 * - ClkClientWin:  client/window
	 * - ClkLtSymbol:   layout symbol
	 * - ClkWinTitle:   window title in bar
	 * - ClkStatusText: upper right status text
	 * - ClkTagBar:     tag list
	 */
};

