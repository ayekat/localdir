/* See LICENSE file for copyright and license details. */

#include "bstack.c"         //     "        "    "  split screen vertically
#include "fibonacci.c"      //     "        "    "  arrange as Fibonacci
#include "push.c"           // move clients around in stack/master

/* appearance */
static const char font[]            = "Fixed Medium Semi-Condensed 10";
//static const char font[]            = "-misc-fixed-medium-r-semicondensed--13-100-100-100-c-60-iso8859-1";

/*
// orange
static const char normbordercolor[]      = "#222222";
static const char selbordercolor[]       = "#E04613";
static const char normbgcolor[]          = "#222222";
static const char normfgcolor[]          = "#AAAAAA";
static const char selbgcolor[]           = "#E04613";
static const char selfgcolor[]           = "#FFFFFF";
*/

// green
static const char normbordercolor[]      = "#222222";
static const char selbordercolor[]       = "#AFD700";
static const char normbgcolor[]          = "#222222";
static const char normfgcolor[]          = "#888888";
static const char selbgcolor[]           = "#AFD700";
static const char selfgcolor[]           = "#222222";

/*
// blue
static const char normbordercolor[] = "#222222";
static const char selbordercolor[]  = "#4499CC";
static const char normbgcolor[]     = "#222222";
static const char normfgcolor[]     = "#999999";
static const char selbgcolor[]      = "#4499CC";
static const char selfgcolor[]      = "#FFFFFF";
*/

static const unsigned int borderpx= 1;    /* border pixel of windows */
static const unsigned int snap    = 20;   /* snap pixel */
static const Bool showbar         = True; /* False means no bar */
static const Bool topbar          = True; /* False means bottom bar */
static const float mfact          = 0.5;  /* Default factor of master area size [0.05..0.95] */
static const int nmaster          = 1;    /* Default number of clients in master area */
static const Bool resizehints     = False;/* True means respect size hints in tiled resizals */

/* tagging */
#ifdef HOST_phobia
static const char *tags[] = { "a", "s", "d", " " };
#else
static const char *tags[] = {
	"_",
	"_",
	"_",
	"∫",
	"∫",
	"∫",
	"",
	"",
	"",
	"",
	"",
	"",
	" "
};
#endif

static const Rule rules[] = {
// floating windows:
	/* class       instance   title         tags mask      isfloating  monitor*/
	{ "Eog",            NULL, NULL,         0,                   True, -1 },
	{ "Gimp",           NULL, NULL,         0,                   True, -1 },
	{ "MPlayer",        NULL, NULL,         0,                   True, -1 },
	{ "Nitrogen",       NULL, NULL,         0,                   True, -1 },
	{ "Firefox",        NULL, "Downloads",  0,                   True, -1 },
	{ "Xfce4-terminal", NULL, "Scratchpad", 1<<(LENGTH(tags)-1), True, -1 },
	{ "Lxappearance",   NULL, NULL,         0,                   True, -1 },
};

/* layout(s) */
static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "",        tile },    /* first entry is default */
	{ "",        bstack },
	{ "[M]",      monocle },
	{ "",        dwindle },
	{ .symbol = NULL,   .arrange = NULL    }, /* for cycling (see below) */
};

/* cycling through layouts (provided by bob127) here:
 * https://bbs.archlinux.org/viewtopic.php?pid=817499#p817499
 */
void
nextlayout(const Arg *arg)
{
	Layout *l;
	for (l=(Layout *)layouts;l != selmon->lt[selmon->sellt];l++);
	if (l->symbol && (l + 1)->symbol)
		setlayout(&((Arg) { .v = (l + 1) }));
	else
		setlayout(&((Arg) { .v = layouts }));
}
void
prevlayout(const Arg *arg)
{
	Layout *l;
	for (l=(Layout *)layouts;l != selmon->lt[selmon->sellt];l++);
	if (l != layouts && (l - 1)->symbol)
		setlayout(&((Arg) { .v = (l - 1) }));
	else
		setlayout(&((Arg) { .v = &layouts[LENGTH(layouts) - 2] }));
}

/* Shifts the current view to the left/right.
 * @param: "arg->i" stores the number of tags to shift right (positive value)
 *          or left (negative value)
 */
void
shiftview(const Arg *arg) {
	Arg shifted, scratch;

	// strip scratchpad:
	int sp = (selmon->tagset[selmon->seltags] & (1<<(LENGTH(tags)-1)));
	scratch.ui = (selmon->tagset[selmon->seltags] & ((1<<(LENGTH(tags)-1))-1));
	if (sp > 0 && scratch.ui > 0) {
		view(&scratch);
	}

	// circular shift:
	if (arg->i > 0) // left
		shifted.ui = (selmon->tagset[selmon->seltags] << arg->i)
		   | (selmon->tagset[selmon->seltags] >> (LENGTH(tags) - arg->i));
	else // right
		shifted.ui = selmon->tagset[selmon->seltags] >> (- arg->i)
		   | selmon->tagset[selmon->seltags] << (LENGTH(tags) + arg->i);
	view(&shifted);

	// readd scratchpad:
	if (sp > 0 && scratch.ui > 0) {
		scratch.ui = (selmon->tagset[selmon->seltags] | (1<<(LENGTH(tags)-1)));
		view(&scratch);
	}
}

/* Moves and follows window to the next tag.
 */
void
movefollowtag(const Arg *arg)
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

/* Moves and follows a window to the next monitor.
 */
void
movefollowmon(const Arg *arg)
{
	tagmon(arg);
	focusmon(arg);
}

/* Toggles a tag view and focuses a window on that tag.
 */
void
focusview(const Arg *arg)
{
	Client *c;
	toggleview(arg);
	for(c = selmon->clients; c; c = c->next)
		if (c->tags == arg->ui) {
			focus(c);
			XRaiseWindow(dpy, c->win);
		}
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

/* terminal commands */
static const char *termcmd[]  = { "xfce4-terminal", NULL };
static const char *termcmd_new[]  = { "urxvtc", NULL };
static const char *scratchpadcmd[] = { "scratchpad", NULL };

/* session commands */
static const char *quitcmd[] = { "killall", "dwmloop", NULL };
static const char *lockcmd[] = { "slock", NULL };

/* hardware commands */
static const char *volraisecmd[] = { "amixer", "set", "Master", "3+", "unmute", NULL };
static const char *vollowercmd[] = { "amixer", "set", "Master", "3-", "unmute", NULL };
static const char *volmutecmd[] = { "amixer", "set", "Master", "toggle", NULL };
static const char *lcdupcmd[] = { "sudo", "lcdctl", "increase", NULL };
static const char *lcddowncmd[] = { "sudo", "lcdctl", "decrease", NULL };
static const char *kbdupcmd[] = { "sudo", "lcdctl", "increase", "keyboard", NULL };
static const char *kbddowncmd[] = { "sudo", "lcdctl", "decrease", "keyboard", NULL };

/* miscellaneous commands */
static const char *prtscrcmd[] = { "scrot", "/home/ayekat/img/screenshots/%Y-%m-%d_%H%M%S.png", NULL };
static const char *dzenconkycmd[] = { "dzenconky", "restart", NULL };
static const char *redshiftcmd[] = { "redshifttoggle", NULL };
static const char *dmenucmd[] = { "dmenu_run", "-l", "8", "-b", "-fn", font,
		"-nb", normbgcolor, "-nf", normfgcolor, "-sb", selbgcolor, "-sf",
		selfgcolor, "-p", "$", NULL };

/* key definitions */
static Key keys[] = {
	/* modifier           key         function       argument */
	{ MODKEY,             XK_p,       spawn,         {.v = dmenucmd } },
	{ 0,                  XK_Print,   spawn,         {.v = prtscrcmd } },
	{ MODKEY,             XK_b,       spawn,         {.v = dzenconkycmd } },
	{ MODKEY,             XK_r,       spawn,         {.v = redshiftcmd } },
	{ MODKEY|ShiftMask,   XK_v,       killclient,    {0} },

	// terminal:
	{ MODKEY|ControlMask, XK_j,       spawn,         {.v = termcmd } },
	{ MODKEY|ControlMask, XK_n,       spawn,         {.v = termcmd_new } },

	// scratchpad:
	{ MODKEY,             XK_Tab,     focusview,     {.ui=1<<(LENGTH(tags)-1)}},
	{ MODKEY|ShiftMask,   XK_Tab,     spawn,         {.v = scratchpadcmd } },

	// volume keys:
	{ 0,                  0x1008FF11, spawn,         {.v = vollowercmd } },
	{ MODKEY|ControlMask, XK_Down,    spawn,         {.v = vollowercmd } },
	{ 0,                  0x1008FF12, spawn,         {.v = volmutecmd } },
	{ MODKEY|ControlMask, XK_m,       spawn,         {.v = volmutecmd } },
	{ 0,                  0x1008FF13, spawn,         {.v = volraisecmd } },
	{ MODKEY|ControlMask, XK_Up,      spawn,         {.v = volraisecmd } },

	// brightness keys (only used for MacBookPro):
	{ 0,                  0x1008FF02, spawn,         {.v = lcdupcmd } },
	{ 0,                  0x1008FF03, spawn,         {.v = lcddowncmd } },
	{ 0,                  0x1008FF05, spawn,         {.v = kbdupcmd } },
	{ 0,                  0x1008FF06, spawn,         {.v = kbddowncmd } },

	// clients:
	{ MODKEY,             XK_j,       focusstack,    {.i = +1 } },
	{ MODKEY,             XK_k,       focusstack,    {.i = -1 } },
	{ MODKEY|ShiftMask,   XK_j,       pushdown,      {0} },
	{ MODKEY|ShiftMask,   XK_k,       pushup,        {0} },
	{ MODKEY,             XK_h,       setmfact,      {.f = -0.02} },
	{ MODKEY,             XK_l,       setmfact,      {.f = +0.02} },
	{ MODKEY,             XK_Return,  zoom,          {0} },
	//{ Mod5Mask,           XK_Return,  zoom,          {0} },

	// layouts:
	{ MODKEY,             XK_comma,   incnmaster,    {.i = +1 } },
	{ MODKEY,             XK_period,  incnmaster,    {.i = -1 } },
	{ MODKEY,             XK_space,   nextlayout,    {0} },
	{ MODKEY|ShiftMask,   XK_space,   prevlayout,    {0} },
	{ MODKEY,             XK_t,       togglefloating,{0} },

	// tags:
	{ MODKEY|ControlMask,           XK_l,      shiftview,     {.i = +1 } },
	{ MODKEY|ControlMask,           XK_h,      shiftview,     {.i = -1 } },
	{ MODKEY|ControlMask|ShiftMask, XK_l,      movefollowtag, {.i = +1 } },
	{ MODKEY|ControlMask|ShiftMask, XK_h,      movefollowtag, {.i = -1 } },
	{ MODKEY,                       XK_0,      view,          {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,           {.ui = ~0 } },

	// monitors:
	{ MODKEY,                       XK_m,      focusmon,      {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_m,      tagmon,        {.i = +1 } },
	{ MODKEY|ControlMask|ShiftMask, XK_m,      movefollowmon, {.i = +1 } },

	// tag keys (arranged in a square):
#ifdef HOST_phobia
	TAGKEYS( XK_a,  0)
	TAGKEYS( XK_s,  1)
	TAGKEYS( XK_d,  2)
#else
	TAGKEYS( XK_1,  0)
	TAGKEYS( XK_2,  1)
	TAGKEYS( XK_3,  2)
	TAGKEYS( XK_q,  3)
	TAGKEYS( XK_w,  4)
	TAGKEYS( XK_e,  5)
	TAGKEYS( XK_a,  6)
	TAGKEYS( XK_s,  7)
	TAGKEYS( XK_d,  8)
	TAGKEYS( XK_y,  9)
	TAGKEYS( XK_x, 10)
	TAGKEYS( XK_c, 11)
#endif

	// session commands:
	{ MODKEY,                       XK_z, spawn, {.v = lockcmd } },
	{ MODKEY|ShiftMask,             XK_z, quit,  {0} },
	{ MODKEY|ControlMask|ShiftMask, XK_z, spawn, {.v = quitcmd } },
};

/* button definitions */
static Button buttons[] = {
	/* click         event mask button   function     argument */
	{ ClkClientWin,  MODKEY,    Button1, movemouse,   {0} },
	{ ClkClientWin,  MODKEY,    Button3, resizemouse, {0} },

	{ ClkTagBar,     0,         Button1, view,        {0} },
	{ ClkTagBar,     0,         Button3, toggleview,  {0} },

#ifdef HOST_phobia
	{ ClkRootWin,    0,         Button4, shiftview,   {.i = -1} },
	{ ClkWinTitle,   0,         Button4, shiftview,   {.i = -1} },
	{ ClkStatusText, 0,         Button4, shiftview,   {.i = -1 } },
	{ ClkTagBar,     0,         Button4, shiftview,   {.i = -1 } },

	{ ClkRootWin,    0,         Button5, shiftview,   {.i = +1} },
	{ ClkWinTitle,   0,         Button5, shiftview,   {.i = +1} },
	{ ClkStatusText, 0,         Button5, shiftview,   {.i = +1 } },
	{ ClkTagBar,     0,         Button5, shiftview,   {.i = +1 } },
#endif

	/* Possible clicks:
	 * - ClkRootWin:    desktop
	 * - ClkClientWin:  client/window
	 * - ClkLtSymbol:   layout symbol
	 * - ClkWinTitle:   window title in bar
	 * - ClkStatusText: upper right status text
	 * - ClkTagBar:     tag list
	 */
};
