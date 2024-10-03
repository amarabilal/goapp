# Étape 1 : Cloner le dépôt depuis Git
FROM alpine:latest AS git

# Installer Git pour cloner le dépôt
RUN apk add --no-cache git

# Cloner le dépôt
RUN git clone https://github.com/amarabilal/goapp /mygoapp

# Étape 2 : Construire l'application Go
FROM golang:1.16-alpine AS builder

# Définir le répertoire de travail
WORKDIR /app

# Copier le code depuis l'étape précédente
COPY --from=git /mygoapp .

# Initialiser le module Go (si ce n'est pas déjà fait dans go.mod)
RUN go mod init mygoapp

# Configurer l'environnement et construire l'application
RUN go env -w CGO_ENABLED=0 GOOS=linux GOARCH=amd64
RUN go build -a -installsuffix cgo -o myapp .

# Étape 3 : Créer l'image finale
FROM scratch

# Copier le binaire de l'application depuis le builder
COPY --from=builder /app/myapp /myapp

# Définir le répertoire de travail
WORKDIR /app

# Exposer le port
EXPOSE 8080

# Commande pour exécuter l'application
CMD ["/myapp"]
