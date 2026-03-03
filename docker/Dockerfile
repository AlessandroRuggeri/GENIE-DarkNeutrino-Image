FROM ubuntu:22.04

# Use bash for all RUN commands - makes source work reliably
SHELL ["/bin/bash", "-c"]

# DEPENDENCIES
RUN apt-get -y update &&\
    apt-get -y upgrade &&\
    apt-get -y install git &&\
    apt-get -y install dpkg-dev &&\
    apt-get -y install cmake &&\
    apt-get -y install g++ &&\
    apt-get -y install gcc &&\
    apt-get -y install binutils &&\
    apt-get -y install libx11-dev &&\
    apt-get -y install libxpm-dev &&\
    apt-get -y install libxft-dev &&\
    apt-get -y install libxext-dev &&\
    apt-get -y install python3 &&\
    apt-get -y install libssl-dev &&\
    apt-get -y install gfortran &&\
    apt-get -y install libpcre3-dev &&\
    apt-get -y install xlibmesa-glu-dev &&\
    apt-get -y install libglew-dev &&\
    apt-get -y install libftgl-dev &&\
    apt-get -y install libmysqlclient-dev &&\
    apt-get -y install libfftw3-dev &&\
    apt-get -y install libcfitsio-dev &&\
    apt-get -y install graphviz-dev &&\
    apt-get -y install libavahi-compat-libdnssd-dev &&\
    apt-get -y install libldap2-dev &&\
    apt-get -y install python3-dev &&\
    apt-get -y install libxml2-dev &&\
    apt-get -y install libxml2 &&\
    apt-get -y install libkrb5-dev &&\
    apt-get -y install libgsl0-dev &&\
    apt-get -y install python2-dev &&\
    apt-get -y install python2 &&\
    apt-get -y install python-dev-is-python3 &&\
    apt-get -y install wget &&\
    apt-get -y install libtbb-dev &&\
    apt-get -y install libglu1-mesa-dev &&\
    apt-get -y install python3-numpy &&\
    apt-get -y install libgsl-dev &&\
    apt-get -y install nlohmann-json3-dev &&\
    apt-get -y install build-essential &&\
    apt-get -y install liblog4cpp5-dev

# LHAPDF
RUN mkdir /HOME &&\
    wget "https://lhapdf.hepforge.org/downloads/?f=LHAPDF-6.5.4.tar.gz" -O /HOME/LHAPDF-6.5.4.tar.gz &&\
    tar xf /HOME/LHAPDF-6.5.4.tar.gz -C /HOME &&\
    cd /HOME/LHAPDF-6.5.4 &&\
    mkdir install &&\
    ./configure --prefix=/HOME/LHAPDF-6.5.4/install &&\
    make -j4 &&\
    make install

# LOG4CPP
RUN git clone https://github.com/orocos-toolchain/log4cpp.git /HOME/log4cpp &&\
    mkdir /HOME/log4cpp/build &&\
    cd /HOME/log4cpp/build &&\
    cmake .. &&\
    make &&\
    make install

# GENIE SOURCE
RUN git clone https://github.com/GENIE-MC/Generator.git --branch R-3_06_02 /HOME/Generator

# PYTHIA6
RUN cd /HOME && bash /HOME/Generator/src/scripts/build/ext/build_pythia6.sh

RUN cd /HOME && bash /HOME/Generator/src/scripts/build/ext/build_pythia6.sh && \
    echo "---- CHECK PYTHIA6 ----" && \
    ls -R /HOME/v6_428

# ROOT
RUN git clone --branch v6-30-00-patches --depth=1 https://github.com/root-project/root.git /HOME/root && \
    mkdir -p /HOME/root/install && \
    cd /HOME/root/build && \
    cmake ../ \
        -Dpythia6=ON \
        -Dmathmore=ON \
        -DPYTHIA6_DIR=/HOME/v6_428 \
        -DPYTHIA6_LIBRARY=/HOME/v6_428/lib/libPythia6.so \
        -DCMAKE_EXE_LINKER_FLAGS="-lgfortran" \
        -DCMAKE_SHARED_LINKER_FLAGS="-lgfortran" \
        -DCMAKE_INSTALL_PREFIX=/HOME/root/install && \
    make -j8 && \
    make install

# GENIE BUILD
RUN source /HOME/root/install/bin/thisroot.sh &&\
    export GENIE=/HOME/Generator &&\
    export LHAPDF=/HOME/LHAPDF-6.5.4/install &&\
    export PATH=$LHAPDF/bin:$PATH &&\
    export LD_LIBRARY_PATH=$LHAPDF/lib:$LD_LIBRARY_PATH &&\
    export LHAPDF_DATA_PATH=$LHAPDF/share/LHAPDF &&\
    export LD_LIBRARY_PATH=/HOME/v6_428/lib:$LD_LIBRARY_PATH &&\
    export LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH &&\
    export GENIE_INSTALL_DIR=/HOME/Generator/installation &&\
    export LD_LIBRARY_PATH=$GENIE_INSTALL_DIR/lib:$LD_LIBRARY_PATH &&\
    cd /HOME/Generator &&\
    ./configure \
    --prefix=/HOME/Generator/installation \
    --disable-profiler \
    --disable-validation-tools \
    --disable-cernlib \
    --disable-lhapdf5 \
    --enable-lhapdf6 \
    --enable-flux-drivers \
    --enable-geom-drivers \
    --disable-doxygen \
    --enable-test \
    --enable-mueloss \
    --enable-dylibversion \
    --enable-t2k \
    --enable-fnal \
    --enable-atmo \
    --enable-nucleon-decay \
    --enable-dark-neutrino \
    --disable-masterclass \
    --disable-debug \
    --with-optimiz-level=O2 \
    --with-pythia6-lib=/HOME/v6_428/lib \
    --with-lhapdf6-inc=/HOME/LHAPDF-6.5.4/install/include \
    --with-lhapdf6-lib=/HOME/LHAPDF-6.5.4/install/lib \
    --with-libxml2-inc=/usr/include/libxml2 \
    --with-libxml2-lib=/usr/lib \
    --with-log4cpp-inc=/usr/local/include/log4cpp \
    --with-log4cpp-lib=/usr/local/lib &&\
    make -j2 &&\
    make install

RUN echo "source /HOME/root/install/bin/thisroot.sh" >> ~/.bashrc

WORKDIR /HOME