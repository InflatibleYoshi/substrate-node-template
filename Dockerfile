FROM arm64v8/rust:1-buster

RUN curl https://getsubstrate.io -sSf | bash -s -- --fast
SHELL ["/bin/bash", "-c", "source ~/.cargo/env"]

SHELL ["/bin/bash", "-c", "wget -c -O gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf.tar.xz 'https://developer.arm.com/-/media/Files/downloads/gnu-a/8.3-2019.03/binrel/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf.tar.xz?revision=e09a1c45-0ed3-4a8e-b06b-db3978fd8d56&la=en&hash=93ED4444B8B3A812B893373B490B90BBB28FD2E3"]
SHELL ["/bin/bash", "-c", "tar xf gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf.tar.xz"]

ENV LIBRARY_PATH=$LIBRARY_PATH:$HOME/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/arm-linux-gnueabihf/libc/lib/
ENV PATH=$PATH:$HOME/gcc-arm-8.3-2019.03-x86_64-arm-linux-gnueabihf/bin/
ENV CXX_armv7_unknown_linux_gnueabihf=arm-linux-gnueabihf-g++
ENV CC_armv7_unknown_linux_gnueabihf=arm-linux-gnueabihf-gcc

SHELL ["/bin/bash", "-c", "sudo apt install libc6-dev-i386"]
SHELL ["/bin/bash", "-c", "export LLVM_CONFIG_PATH=$(which llvm-config-10)"]

SHELL ["/bin/bash", "-c", "rustup target add armv7-unknown-linux-gnueabihf"]

COPY . .

RUN cargo clean
RUN cargo build --target armv7-unknown-linux-gnueabihf --release

CMD ["target/armv7-unknown-linux-gnueabihf/release/node-substrate-template", "--dev"]
EXPOSE 9944
VOLUME /var/www/node-template
