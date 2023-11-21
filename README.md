![img](extra/asset/awesome.png)

## Information
- OS: [Void](https://voidlinux.org)
- Window Manager: [Awesome](https://github.com/awesomeWM/awesome)
- Terminal: [Alacritty](https://github.com/alacritty/alacritty)
- Font: [JetBrainsMono Nerd](https://www.nerdfonts.com/) 
- Icons Font: [Feather](home/.fonts/)
- Visualizer: [Cava](https://github.com/karlstav/cava)

## Screenshots
![counter](https://i.imgur.com/l7Cm0sZ.png)
![counter](https://i.imgur.com/Jyrqr7G.png)

## Features

* Theme Swither
* Control Center
* Brightness / Volume OSD
* Lockscreen (liblua_pam)
* Custom Launcher (include 5 modes: apps, clipboard, zathura, theme swither, clients)
* Powermenu
* Weather Widget
* Calendar Widget
* Wifi applet

<br>

<details>
<summary><b>Some Previews</b></summary>
<br>

* Theme Swither mode in Launcher
<br>
<img src="https://i.imgur.com/gcJKCho.png" width=500>
<br>

* Control Center (also playerctl and weather widgets)
<br>
<img src="https://i.imgur.com/OhYCnkm.png" width=500>
<br>

* Calendar widget
<br>
<img src="https://i.imgur.com/RSPS5vs.png" width=500>
<br>

* Lockscreen
<br>
<img src="https://i.imgur.com/I0ulYmj.png" width=500>
<br>

* Powermenu
<br>
<img src="https://i.imgur.com/164IK5K.png" width=500>
<br>

* Notifications Center
<br>
<img src="https://i.imgur.com/PE8NEMs.png" width=500>
<br>

* OSD
<br>
<img src="https://i.imgur.com/jbVyqvf.png" width=500>
<br>

</details>

## Setup

<details>
<summary><b>Install Dependencies</b></summary>
<br>

1. Setup the void-packages repo

```bash
git clone --depth=1 https://github.com/void-linux/void-packages
cd void-packages
./xbps-src binary-bootstrap
echo XBPS_ALLOW_RESTRICTED=yes >> etc/conf
```
<br>

2. Build the awesome package

```bash
git clone https://github.com/Sinomor/my-templates
cp -r my-templates/awesome-git srcpkgs/
./xbps-src pkg awesome-git
```
<br>

3. Install the awesome package

```bash
sudo xbps-install xtools
xi awesome-git
```
<br>

4. Also build and install compfy (allusive fork of picom)
```bash
cp -r my-templates/compfy srcpkgs/
./xbps-src pkg compfy
xi compfy
```
<br>

5. Install pipewire, wireplumber using void linux [docs](https://docs.voidlinux.org/config/media/pipewire.html)

<br>

6. Install Other Dependencies

```bash
sudo xbps-install feh xclip gpick xrdb picom polkit-gnome fontconfig \
fontconfig-32bit ImageMagick zbar slop shotgun flameshot \
fish-shell playerctl brightnessctl python3-distro nerd-fonts-symbols-ttf xsettingsd
```

<br>

7*. If your disto is not void linux, you need to [compile liblua pam](https://github.com/RMTT/lua-pam#complile) yourself. After that replace the liblua_pam.so file in awesomewm config folder

<br>

8*. If you need working media slider (player widget) in browser, install the 'plasma-browser-integration' package. Next, install 'plasma integration' extension in your browser

</details>

<br>

<details>
<summary><b>Install Dotfiles</b></summary>
<br>

1. Recommended to backup the configs 

```bash
git clone --depth=1 --recursive https://github.com/Sinomor/dotfiles.git
cd dotfiles
cp -r home/.config/* ~/.config/
cp -r home/.fonts ~/
cp -r home/.icons ~/
cp -r home/.themes ~/
cp -r home/.librewolf ~/
cp home/.xinitrc ~/
cp home/.Xresources ~/
cp home/.gtkrc-2.0 ~/ 
```

2. Write to awesome/user.lua your password and apikey from openweather 
```lua
user.opweath_api = "your_api_key"
user.opweath_passwd = "your_password"
```

</details>

<br>

## References

- [Myagko](https://github.com/Myagko/dotfiles)
- [Stardust-kyun](https://github.com/Stardust-kyun/dotfiles)
- [Saimoom](https://github.com/saimoomedits/dotfiles/tree/main)
- [Chadcat7](https://github.com/chadcat7/crystal)
- [Tsukki](https://github.com/tsukki9696/tsukiyomi)
- [TorchedSammy](https://github.com/TorchedSammy/dotfiles)
