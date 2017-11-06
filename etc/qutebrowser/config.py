# Configuration file for qutebrowser >=1.0
# See http://qutebrowser.org/doc/help/settings.html for all available settings.
# Written by ayekat on a sunny saturday afternoon in october 2017

# GENERAL ======================================================================

# Storage:
config.set('auto_save.session', True)
config.set('completion.web_history_max_items', 10000)
import os
config.set('downloads.location.directory', os.environ['HOME'])

# Content:
config.set('url.default_page', 'about:blank')
config.set('url.start_pages', 'about:blank')
config.set('content.default_encoding', 'utf-8')

# Rendering:
import platform
if platform.node() == 'phobia':
    config.set('qt.force_software_rendering', True)

# Focus:
config.set('new_instance_open_target', 'tab-silent')

# CONTROL ======================================================================

# Tabs:
config.set('tabs.background', True)
config.set('tabs.select_on_remove', 'prev')

# Navigation:
config.set('hints.mode', 'letter')
config.set('hints.chars', 'fjdkslaghnv')
config.unbind('<Ctrl-h>', mode='normal')

# Content:
config.bind('m', 'spawn mpv {url}', mode='normal')
config.bind('M', 'hint links spawn mpv {url}', mode='normal')

# Editing:
config.set('editor.command', ['xvim', '{}'])
config.set('input.insert_mode.auto_load', True)
config.unbind('<Ctrl-v>', mode='passthrough')
config.bind('<Escape>', 'leave-mode', mode='passthrough')

# Search:
config.set('url.auto_search', 'dns')
config.set('url.searchengines', {
    'DEFAULT': 'https://duckduckgo.com/?q={}',

    'ddg':     'https://duckduckgo.com/?q={}',
    'google':  'https://www.google.com/search?q={}',
    'img':     'https://www.google.com/search?tbm=isch&q={}',
    'news':    'https://www.google.com/search?tbm=nws&q={}',
    'map':     'http://search.epfl.ch/process_web2010?lang=en&as_site_search=&q={}&engine=place',
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

    'duden':   'http://www.duden.de/suchen/dudenonline?s={}',
    'jisho':   'http://beta.jisho.org/search?utf8=✓&keyword={}',
    'dict':    'http://www.dict.cc/?s={}',
    'leo':     'http://dict.leo.org/franz%C3%B6sisch-deutsch/{}',
    'wr':      'http://wordreference.com/enfr/{}',

    'aw':      'https://wiki.archlinux.org/index.php?title=Special:Search&search={}',
    'dw':      'https://wiki.debian.org/FrontPage?action=fullsearch&context=180&value={}',
    'ap':      'https://www.archlinux.org/packages/?sort=&q={}&maintainer=&flagged=',
    'dp':      'https://tracker.debian.org/search?package_name={}',
    'aur':     'https://aur.archlinux.org/packages/?O=0&K={}',
    'ghub':    'https://github.com/search?utf8=✓&q={}',
    'hayoo':   'http://holumbus.fh-wedel.de/hayoo/hayoo.html?query={}',
    'hulbee':  'https://hulbee.com/?query={}&region=browser&uiLanguage=browser',
    'gw':      'https://gnugeneration.epfl.ch/accueil?do=search&id={}',

    'man':     'http://www.google.com/cse?q={}&ie=ISO-8859-1&cx=partner-pub-5823754184406795:54htp1rtx5u&cof=FORID:9',
    'mankier': 'https://www.mankier.com/?q={}',

    'wa':      'http://www.wolframalpha.com/input/?i={}&dataset=',
    'seq':     'http://oeis.org/search?q={}&language=english',

    'mw':      'http://mtgsalvation.gamepedia.com/index.php?search={}&title=Special:Search',
    'mko':     'http://magickarten.ch/findologic.php?keywords={}',
    'mt':      'http://magictrade.ch/Shop/de/search?page=search&page_action=query&desc=on&sdesc=on&keywords={}',
    'bazar':   'http://www.magicbazar.fr/recherche/index.php?page=11&s={}',
    'mtgprint':'http://magiccards.info/query?q={}&v=card&s=cname',
    'gname':   'http://gatherer.wizards.com/Pages/Search/Default.aspx?name=+[{}]',
    'gtext':   'http://gatherer.wizards.com/Pages/Search/Default.aspx?text=+[{}]',
})

# LOOK =========================================================================

# Tab bar:
config.set('tabs.width.indicator', 0)
config.set('tabs.title.format', '{perc}{title}')
config.set('tabs.padding', {'top': 1, 'bottom': 1, 'left': 2, 'right': 2})
config.set('fonts.tabs', '8pt monospace')
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
