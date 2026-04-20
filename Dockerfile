# deklaracja wersji rozszerzonego frontendu dla Buildkit
# syntax=docker/dockerfile:1.3
# ETAP 1 budowniczy
FROM scratch AS dev_stage

# Zmienna do przekazania w trakcie builda
ARG VERSION

# Wgranie systemu bazowego
ADD alpine-minirootfs-3.23.3-x86_64.tar /

# Uaktualnienie systemu oraz instalacja 
# niezbednych komponentow, czyli openssh-client i git
RUN apk update && \
    apk upgrade && \
    apk add --no-cache nodejs npm openssh-client git && \
    rm -rf /etc/apk/cache

# Tworzenie aplikacji react w kontenerze
RUN npx create-react-app apkalab5

# Dodanie Github do zaufanych hostow
RUN mkdir -p -m 0600 ~/.ssh && ssh-keyscan github.com >> ~/.ssh/known_hosts

# Utworzenie katalogu docelowego
RUN mkdir -p /repo6

# Kopiowanie aplikacji z repo Githuba z podmianą App.js
RUN --mount=type=ssh,id=s56git git clone git@github.com:kanterete/pawcho6.git repo6 && \ 
mv /repo6/App.js /apkalab5/src/App.js

# Ustawienie domyślnego katalogu 
WORKDIR /apkalab5

# Przypisanie
ENV REACT_APP_VERSION=${VERSION}

# Instalacja dependencies
RUN npm install
RUN npm run build

# ETAP 2 produkcyjny
FROM nginx:alpine AS production

# Instalacja curl do healthchecka
RUN apk add --update --no-cache curl && \
    rm -rf /etc/apk/cache

ARG VERSION

# Dodanie metadanych o aktualnej wersji obrazu i autora
LABEL org.opencontainers.image.authors="kacper"
LABEL org.opencontainers.image.version="$VERSION"

# Wskazanie źródła obrazu
LABEL org.opencontainers.image.source="https://github.com/kanterete/pawcho6"

# Kopiowanie zbudowanej aplikacji z pierwszego etapu
COPY --from=dev_stage /apkalab5/build/. /var/www/html/

# Kopiowanie konfiguracji serwera HTTP dla srodowiska produkcyjnego
COPY default.conf /etc/nginx/conf.d/default.conf

# Deklaracja portu aplikacji w kontenerze
EXPOSE 80

# Monitorowanie dostepnosci serwera
HEALTHCHECK --interval=10s --timeout=1s \
    CMD curl -f http://localhost:80/ || exit 1

# Deklaracja sposobu uruchomienia serwera
ENTRYPOINT ["nginx","-g", "daemon off;"]