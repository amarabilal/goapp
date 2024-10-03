package main

import (
    "fmt"
    "net/http"
    "os"
)

func handler(w http.ResponseWriter, r *http.Request) {
    hostname, err := os.Hostname()
    if err != nil {
        http.Error(w, "Could not get hostname", http.StatusInternalServerError)
        return
    }
    fmt.Fprintf(w, "Hello, World! Running on container: %s", hostname)
}

func main() {
    http.HandleFunc("/", handler)
    fmt.Println("Starting server on :9090")
    if err := http.ListenAndServe(":9090", nil); err != nil {
        fmt.Println("Error starting server:", err)
    }
}
