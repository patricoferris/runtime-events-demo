FROM ocaml/opam:debian-11-ocaml-5.0@sha256:8ef27313193b5e003fce1c79624f1b5796508c672abdc6c2d24b4698ad92f398
WORKDIR /src
RUN opam switch create 5.0.0~alpha1
RUN opam repo add alpha git+https://github.com/kit-ty-kate/opam-alpha-repository 
RUN cd ~/opam-repository && (git cat-file -e b02bf3d0b030b22153b9d9f2832d3770feae8105 || git fetch origin master) && git reset -q --hard b02bf3d0b030b22153b9d9f2832d3770feae8105 && git log --no-decorate -n1 --oneline && opam update -u
COPY --chown=opam ./runtime-events-workshop.opam ./runtime-events-workshop.opam.locked .
RUN sudo ln -f /usr/bin/opam-2.1 /usr/bin/opam
RUN opam install -y ocamlformat.0.24.1 ocaml-lsp-server.1.13.2~5.0preview
RUN opam install . --locked --deps-only --with-test
