FROM zingodevops/ci-build:002

WORKDIR /usr/src
RUN git clone https://github.com/zingolabs/zingo-regchest.git \
    && cd zingo-regchest \
    && git checkout 0ed7c7cfb1f90762486fef9524171a9c24569269
WORKDIR /usr/src/zingo-regchest/regchest
RUN ln -s /usr/bin/lightwalletd /usr/bin/zcashd /usr/bin/zcash-cli ./regtest/bin
RUN ln -s /root/.zcash-params /usr/src
RUN cargo build --release

ENTRYPOINT ["cargo", "run", "--release"]
