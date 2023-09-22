FROM zingodevops/ci-build:001

WORKDIR /usr/src
RUN git clone https://github.com/Oscar-Pepper/zingo-regchest.git \
    && cd zingo-regchest \
    && git checkout 374e41466db9a76e58d07e64d248c259f813d454
# RUN git clone https://github.com/zingolabs/zingo-regchest.git \
#     && cd zingo-regchest \
#     && git checkout cd33ff401a8c9d0ec32fe649d1af3f77f2937e26
WORKDIR /usr/src/zingo-regchest/regchest
RUN ln -s /usr/bin/lightwalletd /usr/bin/zcashd /usr/bin/zcash-cli ./regtest/bin/
RUN cargo build --release

ENTRYPOINT ["cargo", "run", "--release"]

