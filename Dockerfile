FROM resin/armv7hf-debian:jessie

# Folow the idea of https://resin.io/blog/building-arm-containers-on-any-x86-machine-even-dockerhub/
ENV QEMU_EXECVE 1
COPY cross-build-start cross-build-end sh-shim /usr/bin/
RUN [ "cross-build-start" ]

RUN apt-get update && apt-get install -yq build-essential m4 ocaml wget sudo patch unzip git emacs24-nox proofgeneral
RUN wget https://raw.github.com/ocaml/opam/master/shell/opam_installer.sh
RUN sh opam_installer.sh /usr/local/bin/; true

RUN echo 'opam ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/opam && \
    chmod 440 /etc/sudoers.d/opam && \
    chown root:root /etc/sudoers.d/opam && \
    adduser --disabled-password --gecos '' opam && \
    passwd -l opam && \
    chown -R opam:opam /home/opam
USER opam
ENV HOME /home/opam
WORKDIR /home/opam

RUN opam init -y
RUN opam switch 4.04.0 -y

ENV CAML_LD_LIBRARY_PATH="/home/opam/.opam/4.04.0/lib/stublibs" \
    MANPATH="/home/opam/.opam/4.04.0/man:" \
    PERL5LIB="/home/opam/.opam/4.04.0/lib/perl5" \
    OCAML_TOPLEVEL_PATH="/home/opam/.opam/4.04.0/lib/toplevel" \
    PATH="/home/opam/.opam/4.04.0/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"

RUN opam install -y camlp5 ocamlfind
RUN opam repo add coq-released https://coq.inria.fr/opam/released
RUN opam install -y coq.8.6 coq-mathcomp-ssreflect.1.6.1 coq-mathcomp-algebra
RUN mkdir /home/opam/.emacs.d
COPY init.el /home/opam/.emacs.d/
RUN sudo chown opam:opam /home/opam/.emacs.d/init.el

RUN [ "cross-build-end" ]






