FROM ocaml/opam:debian-11-ocaml-5.0@sha256:8ef27313193b5e003fce1c79624f1b5796508c672abdc6c2d24b4698ad92f398
WORKDIR /src
COPY --chown=opam ./runtime-events-workshop.opam.locked .
RUN sudo ln -f /usr/bin/opam-2.1 /usr/bin/opam
RUN opam pin . -yn && opam install . --deps-only --with-test
