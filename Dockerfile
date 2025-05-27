FROM alpine:3.21.3 AS builder

#compile yosys
# Install required packages
RUN apk --no-cache add ca-certificates
RUN apk update && apk upgrade
RUN apk add make pkgconfig tcl-dev readline-dev libffi-dev git
WORKDIR /
RUN wget https://github.com/YosysHQ/yosys/releases/download/v0.53/yosys.tar.gz
RUN tar xzf yosys.tar.gz
RUN ls
WORKDIR /yosys-yosys-0.53
RUN make config-gcc
RUN make -j$(nproc)
RUN make install PREFIX=/yosys-install