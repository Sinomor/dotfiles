local awful = require("awful")
local user = require("user")

local user_file = "~/.config/awesome/user.lua"
local xsettingsd_file = "~/.config/xsettingsd/xsettingsd.conf"
local alacritty_file = "~/.config/alacritty/alacritty.yml"
local gtk3_file = "~/.config/gtk-3.0/settings.ini"
local vencord_file = "~/.config/Vencord/themes/theme.css"
local nvim_file = "~/.config/nvim/lua/core/configs.lua"
local telegram_file = "~/.config/awesome/other/current_tg_theme.tdesktop-theme"
local flameshot_file = "~/.config/flameshot/flameshot.ini"
local firefox_file = "~/.librewolf/28peazch.default-default/chrome/userChrome.css"
local xresourses_file = "~/.Xresources"
local zathura_file = "~/.config/zathura/zathurarc"

function apply_theme(entry)
	local color = require("theme.colors."..entry)
	awful.spawn.easy_async_with_shell([[
		sed -i -e "s/user.color =.*/user.color = ']] ..entry.. [['/g" ]] ..user_file.. [[ &&
		sed -i -e "s/gtk-theme-name=.*/gtk-theme-name=]] ..entry.. [[/g" ]] ..gtk3_file.. [[ &&
		sed -i -e "s/Net\/ThemeName .*/Net\/ThemeName \"]] ..entry.. [[\"/g" \
		-e "s/Gtk\/CursorThemeName .*/Gtk\/CursorThemeName \"]] ..entry.. [[\"/g" ]] ..xsettingsd_file.. [[ &&
		sed -i -e "s/- ~\/.config\/awesome.*/- ~\/.config\/awesome\/other\/alacritty\/]] ..entry.. [[.yml/g" ]] ..alacritty_file.. [[ &&
		sed -i -e "s|@import url.*|@import url(']] ..color.discord.. [[')|g" ]] ..vencord_file.. [[ && 
		cp ]] ..user.awm_config.. [[other/telegram/]] ..entry.. [[.tdesktop-theme ]] ..telegram_file.. [[ &&
		sed -i -e "s/vim.cmd.colorscheme.*/vim.cmd.colorscheme{']] ..entry.. [['}/g" ]] ..nvim_file.. [[ &&
		sed -i -e "s/drawColor=.*/drawColor=]] ..color.accent.. [[/g" \
		-e "s/uiColor=.*/uiColor=]] ..color.fg_alt.. [[;/g" ]] ..flameshot_file.. [[ &&
		sed -i -e "s/--background:.*/--background: ]] ..color.bg.. [[;/g" \
		-e "s/--background_alt:.*/--background_alt: ]] ..color.bg_alt.. [[;/g" \
		-e "s/--foreground:.*/--foreground: ]] ..color.fg.. [[;/g" \
		-e "s/--border:.*/--border: ]] ..color.bg_alt.. [[;/g" ]] ..firefox_file.. [[ &&
		sed -i -e "s/Xcursor.theme.*/Xcursor.theme: ]] ..entry.. [[/g" ]] ..xresourses_file.. [[ &&
		xrdb ]] ..xresourses_file.. [[ &&
		sed -i -e "s/set default-bg.*/set default-bg ']] ..color.bg.. [['/g" \
		-e "s/set default-fg.*/set default-fg ']] ..color.fg.. [['/g" \
		-e "s/set recolor-darkcolor.*/set recolor-darkcolor ']] ..color.fg.. [['/g" \
		-e "s/set recolor-lightcolor.*/set recolor-lightcolor ']] ..color.bg.. [['/g" \
		-e "s/set highlight-color.*/set highlight-color ']] ..color.fg.. [['/g" \
		-e "s/set highlight-active-color.*/set highlight-active-color ']] ..color.accent.. [['/g" \
		-e "s/set inputbar-bg.*/set inputbar-bg ']] ..color.bg.. [['/g" \
		-e "s/set inputbar-fg.*/set inputbar-fg ']] ..color.fg.. [['/g" ]] ..zathura_file.. [[ &&
		awesome-client 'reload_nvim("]] ..entry.. [[")' && 
		awesome-client 'awesome.restart()'
	]])
end
