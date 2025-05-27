FROM alpine:3.21.3 AS builder

#compile yosys
# Install required packages
RUN apk --no-cache add ca-certificates
RUN apk update && apk upgrade
RUN apk add bash make pkgconfig tcl-dev readline-dev libffi-dev git g++ python3 bison
RUN mkdir yosys
WORKDIR /yosys
RUN wget https://github.com/YosysHQ/yosys/releases/download/v0.53/yosys.tar.gz
RUN tar xzf yosys.tar.gz
RUN make config-gcc
RUN make -j$(nproc)
RUN make install PREFIX=/yosys-install
