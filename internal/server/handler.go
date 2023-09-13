package server

import (
	"fmt"
	"io"
	"log"
	"net/http"
)

var _ http.Handler = (*handler)(nil)

type handler struct {
	name string
}

func NewHandler(basePath, name string) http.Handler {
	mux := http.NewServeMux()
	mux.Handle(basePath, &handler{
		name: name,
	})
	mux.Handle("/alive", http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusOK)
	}))
	return mux
}

func (h *handler) ServeHTTP(rw http.ResponseWriter, req *http.Request) {
	body, err := io.ReadAll(req.Body)
	if err != nil {
		log.Printf("Error reading body: %+v", err)
		http.Error(rw, "can't read body", http.StatusBadRequest)
		return
	}
	rw.Write([]byte(
		fmt.Sprintf("Hello %s, my name is %s", string(body), h.name),
	))
}
