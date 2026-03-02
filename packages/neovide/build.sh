TERMUX_PKG_HOMEPAGE=https://neovide.dev/
TERMUX_PKG_DESCRIPTION="A refreshingly clean Neovim GUI"
TERMUX_PKG_LICENSE="MIT"
TERMUX_PKG_MAINTAINER="@seu-user"
# Versão estável mais recente
TERMUX_PKG_VERSION=0.13.1
TERMUX_PKG_SRCURL=https://github.com/neovide/neovide/archive/refs/tags/v${TERMUX_PKG_VERSION}.tar.gz
# Usamos SKIP_CHECKSUM para facilitar sua primeira compilação
TERMUX_PKG_SHA256=SKIP_CHECKSUM

# Dependências essenciais do ecossistema X11 do Termux
TERMUX_PKG_DEPENDS="neovim, fontconfig, libx11, libxcursor, libxext, libxrandr, libxi, mesa"
TERMUX_PKG_BUILD_IN_SRC=true

termux_step_pre_configure() {
	# O Neovide precisa de Rust. O ambiente do Termux já fornece o toolchain.
	termux_setup_rust
	
	# Ajuste para garantir que o compilador encontre as bibliotecas gráficas
	export LDFLAGS+=" -lfontconfig -lX11 -lXcursor -lXext -lXrandr -lXi"
}

termux_step_make_install() {
	# Compilação focada no target Android (aarch64)
	# --no-default-features pode ser usado se você quiser remover suporte a Wayland/X11 específico, 
	# mas o padrão geralmente é melhor.
	cargo build --release --target $CARGO_TARGET_NAME

	# Instala o binário no prefixo do Termux (/data/data/com.termux/files/usr/bin)
	install -Dm755 target/$CARGO_TARGET_NAME/release/neovide $TERMUX_PREFIX/bin/neovide
}
