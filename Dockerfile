FROM golang:1.13-buster

# install some basics

RUN apt-get update && apt-get install -y \
  git \
  curl \ 
  tree \
  wget \
  entr \
  ca-certificates \
  python3 \
  python3 \
  python3-dev \
  python3-pip \
  nmap \
  cmake \
  libncurses5-dev

# get and build vim

RUN cd /tmp && git clone https://github.com/vim/vim.git
RUN cd /tmp/vim && ./configure --with-features=huge --enable-multibyte --enable-python3interp=yes --enable-perlinterp=yes  --enable-cscope --prefix=/usr/local 
RUN cd /tmp/vim && make VIMRUNTIMEDIR=/usr/local/share/vim/vim81 && make install

## config/compile vim plugins

RUN git clone https://github.com/VundleVim/Vundle.vim.git /root/.vim/bundle/Vundle.vim
RUN wget -P /root/ https://raw.githubusercontent.com/tcbtcb/go-image/master/.vimrc
RUN vim +PluginInstall +qall
RUN vim +GoInstallBinaries +qall

# install gcloud sdk
RUN echo "deb http://packages.cloud.google.com/apt cloud-sdk-bionic main" | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
RUN apt-get update && apt-get install -y google-cloud-sdk
