#!/bin/bash
echo "==> Установка пакетов для окружения i3-wm"
PKGS=(
# --- i3-wm

 'i3-wm' # i3wm с отступами (gaps)
 'polybar' # Статус бар
 'dmenu' # Меню приложений
 'rofi' # Меню приложений
 'rofi-emoji'# Плагин Rofi для выбора смайликов
 'maim' # Очень минималистичный скриншотер (хорошо сочетается с xclip)
 'scrot'# Необходим для maim
 'lxqt-policykit' # Супер минималистичный polkit аутентификатор
 'nitrogen' # Менеджер обоев рабочего стола X Window System
 'dunst' # Демон уведомлений
 'pcmanfm-gtk3' # Графический файловый менеджер (версия GTK3)
 'ffmpegthumbnailer' # Для отображения миниатюр в pcmanfm
 'galculator' # GNOME калькулятор
 'file-roller' # Gnome менеджер архивов
 'nsxiv' # Простой и удобный просмоторщик картинок
 'feh' # Минималистичный просмотрорщик изображений
 'udiskie' # Автоматическое монторование USB флешек с треем
 'pasystray' # System tray volume control
 'lxappearance' # GTK оформления (GTK+ 2 версия)
 'qt5ct' # QT оформления
 'screenkey' # Показывать набранные клавиши
 'xclip' # System Clipboard (необходимо для neovim)
 'xsel' # Для копирования текста из neovim
 'redshift' # Беречь глаза при работе за ПК
 'blueman' # Bluetooth менеджер

# --- THEMES

 'breeze' # Для доступа к тёмной теме kdenlive
 'gtk-engine-murrine' # Для работоспособности темы Materia Theme
 'materia-gtk-theme' # Desktop Theme
 'capitaine-cursors' # Cursor Icons
 'papirus-icon-theme' # Desktop Icons

# --- Другое

 'zathura-pdf-mupdf' # Удобный PDF Reader
 'zathura-djvu' # Для поддержки формата .djvu
 'zathura-cb' # Для поддержки формата .cbz (аниме манга)
 'alacritty' # Терминал
 'lf' # Удобный TUI файлоый менеджер
 'ueberzug' # Необходим для предпросмотра картинок в LF
 'pulsemixer' # TUI PulseAudio volume control
 'pavucontrol' # GTK PulseAudio volume control
 'network-manager-applet' # Аплет NetworkManager
)
sudo pacman -S "${PKGS[@]}" --noconfirm --needed

echo "==> Установка AUR пакетов для окружения i3-wm"
PKGS=(
 'picom-git' # Прозрачность окон + blur dual_kawase
 'rofi-greenclip' # Rofi/Dmenu Менеджер буфера обмена с поддержкой картинок
 'rofi-power-menu' # Меню выключения
 'autotiling' # Script for sway and i3 to automatically switch the horizontal / vertical window split orientation
 'giph' # Gif рекордер (для maim)
# 'betterlockscreen' # A simple, minimal lockscreen
)
yay -S "${PKGS[@]}" --noconfirm --needed

# Вытягиваю мои конфиги для i3-wm
cd dotfiles/i3wm
stow -vt ~ x alacritty dunst rofi feh greenclip i3 polybar picom sxhkd lf libfm nitrogen nsxiv zathura qt5ct redshift

echo "==> Настройка Xorg для AMDGPU"
sudo bash -c 'cat <<EOF > /etc/X11/xorg.conf.d/20-amdgpu.conf
Section "Device"
     Identifier "AMD"
     Driver "amdgpu"
     Option "TearFree" "false"
     Option "EnablePageFlip" "off"
     Option "VariableRefresh" "true"
EndSection
EOF'

sudo mkinitcpio -P

# Настройка раскладки
if grep -q ruwin_alt_sh-UTF-8 "/etc/vconsole.conf"; then
    # Переключение раскладки по Alt+Shift
    sudo localectl set-x11-keymap --no-convert us,ru pc105 "" grp:alt_shift_toggle
elif
    grep -q ruwin_cplk-UTF-8 "/etc/vconsole.conf"; then
	# Переключение раскладки CapsLock (Чтобы набирать капсом Shift+CapsLock)
    sudo localectl set-x11-keymap --no-convert us,ru pc105 "" grp:caps_toggle,grp_led:caps,grp:switch
fi


echo "==> Отключаю акселерацию мышки"
sudo bash -c 'cat <<EOF > /etc/X11/xorg.conf.d/50-mouse-acceleration.conf
Section "InputClass"
     Identifier "Logitech G102 Prodigy"
     Driver "libinput"
     MatchIsPointer "yes"
     Option "AccelProfile" "Flat"
     Option "AccelSpeed" "0"
EndSection
EOF'
