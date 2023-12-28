local awful = require("awful")
local gears = require("gears")
local user = require("user")
local helpers = require("helpers")

local NV = require("scripts.awesome.reload_nvim")
local T = {}

T.user_file = "~/.config/awesome/user.lua"
T.xsettingsd_file = "~/.config/xsettingsd/xsettingsd.conf"
T.alacritty_file = "~/.config/alacritty/alacritty.yml"
T.gtk3_file = "~/.config/gtk-3.0/settings.ini"
T.vencord_file = "~/.config/Vencord/themes/theme.css"
T.nvim_file = "~/.config/nvim/lua/core/configs.lua"
T.telegram_file = "~/.config/awesome/other/current_tg_theme.tdesktop-theme"
T.flameshot_file = "~/.config/flameshot/flameshot.ini"
T.firefox_file = "~/.librewolf/28peazch.default-default/chrome/userChrome.css"
T.xresourses_file = "~/.Xresources"
T.zathura_file = "~/.config/zathura/zathurarc"

T.restart = gears.timer {
	timeout = 1,
	callback = awesome.restart,
	single_shot = true
}

function T:apply_theme(entry)
	local color = require("theme.colors."..entry)
	awful.spawn.easy_async_with_shell([[
		sed -i -e "s/user.color =.*/user.color = ']] ..entry.. [['/g" ]] ..self.user_file.. [[ &&
		sed -i -e "s/gtk-theme-name=.*/gtk-theme-name=]] ..entry.. [[/g" ]] ..self.gtk3_file.. [[ &&
		sed -i -e "s/Net\/ThemeName .*/Net\/ThemeName \"]] ..entry.. [[\"/g" \
		-e "s/Gtk\/CursorThemeName .*/Gtk\/CursorThemeName \"]] ..entry.. [[\"/g" ]] ..self.xsettingsd_file.. [[ &&
		sed -i -e "s/- ~\/.config\/awesome.*/- ~\/.config\/awesome\/other\/alacritty\/]] ..entry.. [[.yml/g" ]] ..self.alacritty_file.. [[ &&
		sed -i -e "s|@import url.*|@import url(']] ..color.discord.. [[')|g" ]] ..self.vencord_file.. [[ && 
		cp ]] ..user.awm_config.. [[other/telegram/]] ..entry.. [[.tdesktop-theme ]] ..self.telegram_file.. [[ &&
		sed -i -e "s/vim.cmd.colorscheme.*/vim.cmd.colorscheme{']] ..entry.. [['}/g" ]] ..self.nvim_file.. [[ &&
		sed -i -e "s/drawColor=.*/drawColor=]] ..color.accent.. [[/g" \
		-e "s/uiColor=.*/uiColor=]] ..color.fg_alt.. [[;/g" ]] ..self.flameshot_file.. [[ &&
		sed -i -e "s/--background:.*/--background: ]] ..color.bg.. [[;/g" \
		-e "s/--background_alt:.*/--background_alt: ]] ..color.bg_alt.. [[;/g" \
		-e "s/--foreground:.*/--foreground: ]] ..color.fg.. [[;/g" \
		-e "s/--border:.*/--border: ]] ..color.bg_alt.. [[;/g" ]] ..self.firefox_file.. [[ &&
		sed -i -e "s/Xcursor.theme.*/Xcursor.theme: ]] ..entry.. [[/g" ]] ..self.xresourses_file.. [[ &&
		xrdb ]] ..self.xresourses_file.. [[ &&
		sed -i -e "s/set default-bg.*/set default-bg ']] ..color.bg.. [['/g" \
		-e "s/set default-fg.*/set default-fg ']] ..color.fg.. [['/g" \
		-e "s/set recolor-darkcolor.*/set recolor-darkcolor ']] ..color.fg.. [['/g" \
		-e "s/set recolor-lightcolor.*/set recolor-lightcolor ']] ..color.bg.. [['/g" \
		-e "s/set highlight-color.*/set highlight-color ']] ..color.fg.. [['/g" \
		-e "s/set highlight-active-color.*/set highlight-active-color ']] ..color.accent.. [['/g" \
		-e "s/set inputbar-bg.*/set inputbar-bg ']] ..color.bg.. [['/g" \
		-e "s/set inputbar-fg.*/set inputbar-fg ']] ..color.fg.. [['/g" ]] ..self.zathura_file.. [[
	]])
	helpers.ui.recolor_image(user.awm_config .. "theme/icons/layouts/floatingw.png", color.fg)
	helpers.ui.recolor_image(user.awm_config .. "theme/icons/layouts/tilew.png", color.fg)
	NV:reload_nvim(entry)
	self.restart:start()
end

return T
