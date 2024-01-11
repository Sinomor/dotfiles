local awful = require("awful")
local gears = require("gears")
local user = require("user")
local helpers = require("helpers")
local beautiful = require("beautiful")

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

function T:change_var(name)
	os.execute([[sed -i -e "s/user.color =.*/user.color = ']] ..name.. [['/g" ]] ..self.user_file)
end

function T:change_gtk3(name)
	os.execute([[sed -i -e "s/gtk-theme-name=.*/gtk-theme-name=]] ..name.. [[/g" ]] ..self.gtk3_file)
end

function T:change_xsettingsd(name)
	os.execute([[sed -i -e "s/Net\/ThemeName .*/Net\/ThemeName \"]] ..name.. [[\"/g" \
	-e "s/Gtk\/CursorThemeName .*/Gtk\/CursorThemeName \"]] ..name.. [[\"/g" ]] ..self.xsettingsd_file)
end

function T:change_alacritty(name)
	os.execute([[sed -i -e "s/- ~\/.config\/awesome.*/- ~\/.config\/awesome\/other\/alacritty\/]]
	..name.. [[.yml/g" ]] ..self.alacritty_file)
end

function T:change_vencord(name)
	os.execute([[sed -i -e "s|@import url.*|@import url(]] ..name.discord.. [[)|g" ]] ..self.vencord_file)
end

function T:change_telegram(name)
	os.execute([[cp ]] ..user.awm_config.. [[other/telegram/]]
	..name.. [[.tdesktop-theme ]] ..self.telegram_file)
end

function T:change_nvim(name)
	os.execute([[sed -i -e "s/vim.cmd.colorscheme.*/vim.cmd.colorscheme{']]
	..name.. [['}/g" ]] ..self.nvim_file)
end

function T:change_flameshot(name)
	os.execute([[sed -i -e "s/drawColor=.*/drawColor=]] ..name.accent.. [[/g" \
	-e "s/uiColor=.*/uiColor=]] ..name.fg_alt.. [[;/g" ]] ..self.flameshot_file)
end

function T:change_firefox(name)
	os.execute([[sed -i -e "s/--background:.*/--background: ]] ..name.bg.. [[;/g" \
	-e "s/--background_alt:.*/--background_alt: ]] ..name.bg_alt.. [[;/g" \
	-e "s/--foreground:.*/--foreground: ]] ..name.fg.. [[;/g" \
	-e "s/--border:.*/--border: ]] ..name.bg_alt.. [[;/g" ]] ..self.firefox_file)
end

function T:change_xressourses(name)
	os.execute([[sed -i -e "s/Xcursor.theme.*/Xcursor.theme: ]] ..name.. [[/g" ]] ..self.xresourses_file.. [[ &&
	xrdb ]] ..self.xresourses_file)
end

function T:change_zathura(name)
	os.execute([[sed -i -e "s/set default-bg.*/set default-bg ']] ..name.bg.. [['/g" \
	-e "s/set default-fg.*/set default-fg ']] ..name.fg.. [['/g" \
	-e "s/set recolor-darkcolor.*/set recolor-darkcolor ']] ..name.fg.. [['/g" \
	-e "s/set recolor-lightcolor.*/set recolor-lightcolor ']] ..name.bg.. [['/g" \
	-e "s/set highlight-color.*/set highlight-color ']] ..name.fg.. [['/g" \
	-e "s/set highlight-active-color.*/set highlight-active-color ']] ..name.accent.. [['/g" \
	-e "s/set inputbar-bg.*/set inputbar-bg ']] ..name.bg.. [['/g" \
	-e "s/set inputbar-fg.*/set inputbar-fg ']] ..name.fg.. [['/g" ]] ..self.zathura_file)
end

function T:apply_theme(name)
	local color = require("theme.colors."..name)
	self:change_nvim(name)
	self:change_var(name)
	self:change_gtk3(name)
	self:change_xressourses(name)
	self:change_firefox(color)
	helpers.ui.recolor_image(beautiful.notification_icon, color.fg)
	helpers.ui.recolor_image(beautiful.layout_floating, color.fg)
	helpers.ui.recolor_image(beautiful.layout_tile, color.fg)
	helpers.ui.recolor_image(beautiful.notification_icon_error, color.red)
	helpers.ui.recolor_image(beautiful.notification_icon_screenshot, color.fg)
	self:change_vencord(color)
	self:change_telegram(name)
	self:change_zathura(color)
	self:change_alacritty(name)
	self:change_flameshot(color)
	self:change_xsettingsd(name)
	awesome.restart()
end

return T