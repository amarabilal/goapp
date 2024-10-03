# Étape 1 : Utiliser l'image de base Go pour la construction
FROM golang:1.20 AS builder

# Définir le répertoire de travail
WORKDIR /app

# Initier le module Go et télécharger les dépendances
RUN go mod init myapp

# Copier le code source
COPY . .

# Construire l'application
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -o myapp .

RUN go build -o myapp .

# Étape 2 : Créer l'image finale
FROM alpine:latest

# Définir le répertoire de travail
WORKDIR /root/

# Copier le binaire de l'application depuis le builder
COPY --from=builder /app/myapp .

# Exposer le port
EXPOSE 9090

# Commande pour exécuter l'application
CMD ["./myapp"]
