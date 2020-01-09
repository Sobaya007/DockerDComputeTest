FROM nvidia/cuda:9.2-devel

RUN apt-get update && apt-get install -y curl libxml2 git

RUN curl -fsS https://dlang.org/install.sh | bash -s ldc-1.19.0
ENV PATH /root/dlang/ldc-1.19.0/bin${PATH:+:}${PATH:-}
ENV DMD ldmd2
ENV DC ldc2

ENV LD_LIBRARY_PATH /usr/local/cuda/compat${LD_LIBRARY_PATH:+:}${LD_LIBRARY_PATH:-}
ENV LIBRARY_PATH /usr/local/cuda/compat${LIBRARY_PATH:+:}${LIBRARY_PATH:-}
