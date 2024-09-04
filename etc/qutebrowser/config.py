# Configuration file for qutebrowser >=1.0
# See http://qutebrowser.org/doc/help/settings.html for all available settings.
# Written by ayekat on a sunny saturday afternoon in october 2017

# OS ===========================================================================

import os
HOME = os.environ['HOME']
XDG_LIB_HOME = os.environ.get('XDG_LIB_HOME', '%s/.local/lib' % HOME)
XDG_RUNTIME_DIR = os.environ['XDG_RUNTIME_DIR']

# SESSION ======================================================================

datadir = str(config.datadir)
session = None
import re
m = re.findall('^%s/qutebrowser/([^/]+)/[^/]+$' % XDG_RUNTIME_DIR, datadir)
if m and len(m) == 1:
    session = m[0]

# GENERAL ======================================================================

# Do not load autoconfig (configuration set at runtime):
config.load_autoconfig(False)

# Storage:
c.auto_save.session = True
c.completion.web_history.max_items = 10000
import os
c.downloads.location.directory = HOME

# Content:
c.url.default_page = 'about:blank'
c.url.start_pages = 'about:blank'
c.content.default_encoding = 'utf-8'
c.content.tls.certificate_errors = 'ask-block-thirdparty'

# Focus:
c.new_instance_open_target = 'tab-silent'

# CONTROL ======================================================================

# Browser:
config.unbind('<Ctrl-q>', mode='normal')

# Windows:
config.unbind('<Ctrl-Shift-n>', mode='normal')
config.unbind('<Ctrl-n>', mode='normal')

# Tabs:
c.tabs.select_on_remove = 'prev'
config.unbind('gJ', mode='normal')
config.unbind('gK', mode='normal')
config.bind('gj', 'tab-move +', mode='normal')
config.bind('gk', 'tab-move -', mode='normal')
config.unbind('<Ctrl-w>', mode='normal')
config.unbind('<Ctrl-p>', mode='normal')

# Navigation:
c.hints.mode = 'letter'
c.hints.chars = 'fjdkslaghnv'
config.unbind('<Ctrl-h>', mode='normal')
config.bind('0', 'scroll-to-perc --horizontal 0', mode='normal')
config.bind('$', 'scroll-to-perc --horizontal 100', mode='normal')
c.input.forward_unbound_keys = 'none'

# Content:
config.bind('m', 'spawn mpv --x11-netwm=yes {url}', mode='normal')
config.bind('M', 'hint links spawn mpv {hint-url}', mode='normal')
c.zoom.default = '85%'

# Editing:
c.editor.command = ['xvim', '{}']
c.input.insert_mode.auto_load = True
config.unbind('<Ctrl-v>', mode='normal')
config.bind('I', 'mode-enter passthrough', mode='normal')

# Search:
c.url.auto_search = 'dns'
c.url.searchengines = {
    'DEFAULT': 'https://www.google.com/search?q={}',

    'ddg':     'https://duckduckgo.com/?q={}',
    'sx':      'https://searx.me/?q={}',
    'google':  'https://www.google.com/search?q={}',
    'img':     'https://www.google.com/search?tbm=isch&q={}',
    'news':    'https://www.google.com/search?tbm=nws&q={}',
    'map':     'http://search.epfl.ch/process_web2010?lang=en&as_site_search=&q={}&engine=place',
    'osm':     'http://www.openstreetmap.org/search?query={}',
    'meteo':   'http://meteo.search.ch/?plz_ort={}',
    'yt':      'http://www.youtube.com/results?search_query={}',
    'bc':      'http://bandcamp.com/search?q={}',
    'xkcd':    'http://www.google.com/cse?cx=012652707207066138651:zudjtuwe28q&ie=UTF-8&q={}&siteurl=xkcd.com/',
    'people':  'https://search.epfl.ch/psearch.action?request_locale=en&q={}',

    'wp':      'http://www.wikipedia.org/search-redirect.php?family=wikipedia&search={}&language=en&go=Go',
    'wpfr':    'https://fr.wikipedia.org/w/index.php?title=Spécial:Recherche&profile=default&fulltext=Search&search={}',
    'wpde':    'https://de.wikipedia.org/w/index.php?search={}&title=Spezial:Suche',
    'wt':      'https://en.wiktionary.org/w/index.php?search={}&title=Special:Search',
    'wb':      'http://en.wikibooks.org/w/index.php?search={}&title=Special:Search',
    'libgen':  'http://libgen.org/search.php?req={}&open=0&view=simple&column=def',

    'duden':   'http://www.duden.de/suchen/dudenonline/{}',
    'jisho':   'http://beta.jisho.org/search?utf8=✓&keyword={}',
    'dict':    'http://www.dict.cc/?s={}',
    'leo':     'http://dict.leo.org/franz%C3%B6sisch-deutsch/{}',
    'wr':      'http://wordreference.com/enfr/{}',

    'aw':      'https://wiki.archlinux.org/index.php?title=Special:Search&search={}',
    'dw':      'https://wiki.debian.org/FrontPage?action=fullsearch&context=180&value={}',
    'ap':      'https://www.archlinux.org/packages/?sort=&q={}&maintainer=&flagged=',
    'ag':      'https://www.archlinux.org/groups/x86_64/{}',
    'ab':      'https://bugs.archlinux.org/index.php?project=0&string={}',
    'dp':      'https://packages.debian.org/search?keywords={}&searchon=names&section=all',
    'up':      'https://packages.ubuntu.com/search?keywords={}',
    'salsa':   'https://salsa.debian.org/search?utf8=✓&search={}',
    'up':      'https://packages.ubuntu.com/search?keywords={}',
    'aur':     'https://aur.archlinux.org/packages/?O=0&K={}',
    'aurp':    'https://aur.archlinux.org/packages/{}',
    'ghub':    'https://github.com/search?utf8=✓&q={}',
    'hayoo':   'http://holumbus.fh-wedel.de/hayoo/hayoo.html?query={}',
    'hulbee':  'https://hulbee.com/?query={}&region=browser&uiLanguage=browser',
    'gw':      'https://gnugeneration.epfl.ch/accueil?do=search&id={}',

    'man':     'https://man.archlinux.org/search?q={}',
    'debman':  'https://dyn.manpages.debian.org/jump?q={}',
    'sc':      'https://github.com/koalaman/shellcheck/wiki/SC{}',
    'posix':   'http://pubs.opengroup.org/onlinepubs/9699919799/utilities/{}.html',
    'ansibled':'https://docs.ansible.com/ansible/latest/modules/{}_module.html',

    'wa':      'http://www.wolframalpha.com/input/?i={}&dataset=',
    'seq':     'http://oeis.org/search?q={}&language=english',

    'mtg':     'http://gatherer.wizards.com/Pages/Search/Default.aspx?name=+["{}"]',
    'sf':      'https://scryfall.com/search?q={}',
    'mw':      'http://mtgsalvation.gamepedia.com/index.php?search={}&title=Special:Search',
    'mm':      'https://magicmonk.ch/de/jolisearch?s={}',
    'mko':     'http://magickarten.ch/findologic.php?keywords={}',
    'mt':      'http://magictrade.ch/Shop/de/search?page=search&page_action=query&desc=on&sdesc=on&keywords={}',
    'mkm':     'https://www.cardmarket.com/en/Magic/Products/Search?searchString={}',
    'wow':     'https://wowpedia.fandom.com/wiki/Special:Search?query={}',
}

# LOOK =========================================================================

# Tab bar:
c.tabs.indicator.width = 0
c.tabs.title.format = '{perc}{audio}{current_title}'
c.tabs.padding = {'top': 1, 'bottom': 1, 'left': 2, 'right': 2}
c.fonts.tabs.selected = '8pt monospace'
c.fonts.tabs.unselected = '8pt monospace'
c.colors.tabs.even.bg = '#222222'
c.colors.tabs.odd.bg = '#222222'
c.colors.tabs.even.fg = '#aaaaaa'
c.colors.tabs.odd.fg = '#aaaaaa'
c.colors.tabs.selected.even.bg = '#afd700'
c.colors.tabs.selected.odd.bg = '#afd700'
c.colors.tabs.selected.even.fg = '#000000'
c.colors.tabs.selected.odd.fg = '#000000'

# Content:
c.hints.border = '1px solid #ffff00'
c.fonts.hints = 'bold 8pt monospace'
c.colors.hints.bg = '#000000'
c.colors.hints.fg = '#ffff00'
c.colors.hints.match.fg = '#00ff00'
c.fonts.contextmenu = '8pt sans'

# Completion menu:
c.fonts.completion.category = 'bold 8pt monospace'
c.fonts.completion.entry = '8pt monospace'
c.colors.completion.even.bg = '#222222'
c.colors.completion.odd.bg = '#222222'
c.colors.completion.fg = '#aaaaaa'
c.colors.completion.category.bg = '#000000'
c.colors.completion.category.fg = '#eeeeee'
c.colors.completion.item.selected.bg = '#444444'
c.colors.completion.item.selected.fg = '#ffffff'
c.colors.completion.item.selected.border.top = '#444444'
c.colors.completion.item.selected.border.bottom = '#444444'
c.colors.completion.match.fg = '#afd700'
c.completion.scrollbar.padding = 0
c.completion.scrollbar.width = 15
c.colors.completion.scrollbar.bg = '#222222'
c.colors.completion.scrollbar.fg = '#afd700'

# Prompt:
c.prompt.radius = 0
c.fonts.prompts = '8pt sans'

# Messages bar:
c.fonts.messages.error = '8pt monospace'
c.fonts.messages.info = '8pt monospace'
c.fonts.messages.warning = '8pt monospace'
c.colors.messages.warning.fg = '#000000'

# Download menu:
c.downloads.position = 'bottom'
c.fonts.downloads = '8pt monospace'
c.colors.downloads.bar.bg = '#222222'
c.colors.downloads.start.bg = '#0000aa'
c.colors.downloads.start.fg = '#eeeeee'
c.colors.downloads.stop.bg = '#00aa00'
c.colors.downloads.stop.fg = '#ffffff'

# Status bar:
c.fonts.statusbar = '8pt monospace'
c.colors.statusbar.normal.bg = '#222222'
c.colors.statusbar.normal.fg = '#aaaaaa'
c.colors.statusbar.insert.bg = '#005f5f'
c.colors.statusbar.insert.fg = '#ffffff'
c.colors.statusbar.passthrough.bg = '#663388'
c.colors.statusbar.passthrough.fg = '#ffffff'
c.colors.statusbar.url.success.http.fg = '#eeaa00'
c.colors.statusbar.url.success.https.fg = '#66ee22'
c.colors.statusbar.url.warn.fg = '#ff0000'
c.statusbar.widgets = [
    'keypress',
    'search_match',
    'progress',
    'url',
    'scroll',
    'history',
    f'text:{session}',
    'tabs',
]

# PRIVATE ======================================================================

private_dir = '%s/private/qutebrowser' % XDG_LIB_HOME
private_config = '%s/config.py' % private_dir

# Load generic and session-specific configuration not meant to be public:
if os.path.isfile(private_config):
    config.source(private_config)

if session:
    session_config = '%s/sessions/%s/config.py' % (private_dir, session)
    if session_config and os.path.isfile(session_config):
        config.source(session_config)
