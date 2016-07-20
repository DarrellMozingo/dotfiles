git clone https://github.com/VundleVim/Vundle.vim.git ..\.vim\bundle\Vundle.vim
mklink /J ..\.vimrc .vimrc

@powershell -NoProfile -ExecutionPolicy Bypass -Command "iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))" && SET PATH=%PATH%;%ALLUSERSPROFILE%\chocolatey\bin
choco install editorconfig.core

vim +PluginInstall
