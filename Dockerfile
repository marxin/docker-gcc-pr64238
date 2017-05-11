FROM opensuse:tumbleweed

RUN zypper --non-interactive --gpg-auto-import-keys install git wget unzip flex make zip gcc-c++ gcc gcc-32bit gmp-devel mpfr-devel mpc-devel tar bison which  patch

ENV SHELL /bin/bash
WORKDIR /build

RUN wget -q https://github.com/gcc-mirror/gcc/archive/gcc-7_1_0-release.zip
RUN unzip gcc-7_1_0-release.zip
WORKDIR gcc-gcc-7_1_0-release

RUN mkdir objdir 
WORKDIR objdir
RUN ../configure --enable-languages=c,c++,go,lto --enable-checking=assert --disable-multilib --disable-bootstrap --disable-libsanitizer --prefix=/build/bin/gcc &&  make -j$(nproc) && make install

WORKDIR /build
RUN wget -q https://gcc.gnu.org/bugzilla/attachment.cgi?id=34230 -O tc.tgz
RUN tar xvzf tc.tgz

ENV PATH /build/bin/gcc/bin:$PATH
ENV LD_LIBRARY_PATH /build/bin/gcc/bin:$LD_LIBRARY_PATH

RUN gcc -v
RUN gcc bytes_decl.go bytes.go -flto -o a.out ; true
