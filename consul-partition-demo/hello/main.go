package main

import (
    "fmt"
    "net/http"
)

func main() {
    http.HandleFunc("/health", HealthServer)
    http.HandleFunc("/", HelloServer)
    http.ListenAndServe(":9003", nil)
}

func HelloServer(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello, %s!\n", r.URL.Path[1:])
}
func HealthServer(w http.ResponseWriter, r *http.Request) {
    fmt.Fprintf(w, "Hello is healthy!!!!")
}
