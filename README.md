# Sprawozdanie 6 - SSH i GitHub Container Registry (GHCR)

Projekt korzysta z silnika BuildKit (`# syntax=docker/dockerfile:1.3`) 

## Instrukcja odtworzenia środowiska

### 1. Budowanie obrazu z SSH
```
docker buildx build --build-arg VERSION=v6.0 --ssh s56git=$HOME/.ssh/gh_lab25 \
--progress=plain -f Dockerfile -t ghcr.io/kanterete/pawcho6:lab6 --load .
```

#### Potwierdzenie klonowania repo
<img width="1023" height="59" alt="Code_SAFz9yiwxh" src="https://github.com/user-attachments/assets/a9194e33-49ef-494b-ab00-ba146edf127f" />


### 2. Publikacja obrazu w rejestrze GHCR
```
docker push ghcr.io/kanterete/pawcho6:lab6
```

### 3. Uruchomienie kontenera lokalnie
```
docker run -d -p 8802:80 --name app_lab6 ghcr.io/kanterete/pawcho6:lab6
```
#### Sprawdzenie działania
<img width="1191" height="53" alt="Code_cagxgJHAQk" src="https://github.com/user-attachments/assets/28e63bbd-8ec1-4347-8bb0-5f5a83d03a73" />
