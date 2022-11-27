# Configuration file for qutebrowser >=1.0
# See http://qutebrowser.org/doc/help/settings.html for all available settings.
# Written by ayekat on a sunny saturday afternoon in october 2017

# Do not load autoconfig (configuration set at runtime):
config.load_autoconfig(False)

# GENERAL ======================================================================

# Storage:
config.set('auto_save.session', True)
config.set('completion.web_history.max_items', 10000)
import os
config.set('downloads.location.directory', os.environ['HOME'])

# Content:
config.set('url.default_page', 'about:blank')
config.set('url.start_pages', 'about:blank')
config.set('content.default_encoding', 'utf-8')

# Focus:
config.set('new_instance_open_target', 'tab-silent')

# CONTROL ======================================================================

# Browser:
config.unbind('<Ctrl-q>', mode='normal')

# Windows:
config.unbind('<Ctrl-Shift-n>', mode='normal')
config.unbind('<Ctrl-n>', mode='normal')

# Tabs:
config.set('tabs.select_on_remove', 'prev')
config.unbind('gJ', mode='normal')
config.unbind('gK', mode='normal')
config.bind('gj', 'tab-move +', mode='normal')
config.bind('gk', 'tab-move -', mode='normal')
config.unbind('<Ctrl-w>', mode='normal')
config.unbind('<Ctrl-p>', mode='normal')

# Navigation:
config.set('hints.mode', 'letter')
config.set('hints.chars', 'fjdkslaghnv')
config.unbind('<Ctrl-h>', mode='normal')
config.bind('0', 'scroll-to-perc --horizontal 0', mode='normal')
config.bind('$', 'scroll-to-perc --horizontal 100', mode='normal')
config.set('input.forward_unbound_keys', 'none')

# Content:
config.bind('m', 'spawn mpv --x11-netwm=yes {url}', mode='normal')
config.bind('M', 'hint links spawn mpv {hint-url}', mode='normal')

# Editing:
config.set('editor.command', ['xvim', '{}'])
config.set('input.insert_mode.auto_load', True)
config.unbind('<Ctrl-v>', mode='normal')
config.bind('I', 'mode-enter passthrough', mode='normal')

# Search:
config.set('url.auto_search', 'dns')
config.set('url.searchengines', {
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
    'salsa':   'https://salsa.debian.org/search?utf8=✓&search={}',
    'up':      'https://packages.ubuntu.com/search?keywords={}',
    'aur':     'https://aur.archlinux.org/packages/?O=0&K={}',
    'aurp':    'https://aur.archlinux.org/packages/{}',
    'ghub':    'https://github.com/search?utf8=✓&q={}',
    'hayoo':   'http://holumbus.fh-wedel.de/hayoo/hayoo.html?query={}',
    'hulbee':  'https://hulbee.com/?query={}&region=browser&uiLanguage=browser',
    'gw':      'https://gnugeneration.epfl.ch/accueil?do=search&id={}',

    'man':     'http://jlk.fjfi.cvut.cz/arch/manpages/search?q={}',
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
})

# LOOK =========================================================================

# Tab bar:
config.set('tabs.indicator.width', 0)
config.set('tabs.title.format', '{perc}{audio}{current_title}')
config.set('tabs.padding', {'top': 1, 'bottom': 1, 'left': 2, 'right': 2})
config.set('fonts.tabs.selected', '8pt monospace')
config.set('fonts.tabs.unselected', '8pt monospace')
config.set('colors.tabs.even.bg', '#222222')
config.set('colors.tabs.odd.bg', '#222222')
config.set('colors.tabs.even.fg', '#aaaaaa')
config.set('colors.tabs.odd.fg', '#aaaaaa')
config.set('colors.tabs.selected.even.bg', '#afd700')
config.set('colors.tabs.selected.odd.bg', '#afd700')
config.set('colors.tabs.selected.even.fg', '#000000')
config.set('colors.tabs.selected.odd.fg', '#000000')

# Content:
config.set('hints.border', '1px solid #ffff00')
config.set('fonts.hints', 'bold 8pt monospace')
config.set('colors.hints.bg', '#000000')
config.set('colors.hints.fg', '#ffff00')
config.set('colors.hints.match.fg', '#00ff00')

# Completion menu:
config.set('fonts.completion.category', 'bold 8pt monospace')
config.set('fonts.completion.entry', '8pt monospace')
config.set('colors.completion.even.bg', '#222222')
config.set('colors.completion.odd.bg', '#222222')
config.set('colors.completion.fg', '#aaaaaa')
config.set('colors.completion.category.bg', '#000000')
config.set('colors.completion.category.fg', '#eeeeee')
config.set('colors.completion.item.selected.bg', '#444444')
config.set('colors.completion.item.selected.fg', '#ffffff')
config.set('colors.completion.item.selected.border.top', '#444444')
config.set('colors.completion.item.selected.border.bottom', '#444444')
config.set('colors.completion.match.fg', '#afd700')
config.set('completion.scrollbar.padding', 0)
config.set('completion.scrollbar.width', 15)
config.set('colors.completion.scrollbar.bg', '#222222')
config.set('colors.completion.scrollbar.fg', '#afd700')

# Prompt:
config.set('prompt.radius', 0)
config.set('fonts.prompts', '8pt sans-serif')

# Messages bar:
config.set('fonts.messages.error', '8pt monospace')
config.set('fonts.messages.info', '8pt monospace')
config.set('fonts.messages.warning', '8pt monospace')
config.set('colors.messages.warning.fg', '#000000')

# Download menu:
config.set('downloads.position', 'bottom')
config.set('fonts.downloads', '8pt monospace')
config.set('colors.downloads.bar.bg', '#222222')
config.set('colors.downloads.start.bg', '#0000aa')
config.set('colors.downloads.start.fg', '#eeeeee')
config.set('colors.downloads.stop.bg', '#00aa00')
config.set('colors.downloads.stop.fg', '#ffffff')

# Status bar:
config.set('fonts.statusbar', '8pt monospace')
config.set('colors.statusbar.normal.bg', '#222222')
config.set('colors.statusbar.normal.fg', '#aaaaaa')
config.set('colors.statusbar.insert.bg', '#005f5f')
config.set('colors.statusbar.insert.fg', '#ffffff')
config.set('colors.statusbar.passthrough.bg', '#663388')
config.set('colors.statusbar.passthrough.fg', '#ffffff')
config.set('colors.statusbar.url.success.http.fg', '#eeaa00')
config.set('colors.statusbar.url.success.https.fg', '#66ee22')
config.set('colors.statusbar.url.warn.fg', '#ff0000')

# PRIVATE ======================================================================

# Load configuration that is not meant to be public:
config.source('%s/private/qutebrowser/config.py' %
              os.environ.get('XDG_LIB_HOME',
                             '%s/.local/lib' % os.environ['HOME']))
