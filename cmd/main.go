package main

import (
	"context"
	"fmt"
	"log"
	"net/http"
	"os"
	"os/signal"
	"time"

	"github.com/nico151999/skaffold-demo/internal/server"
)

func main() {
	port, ok := os.LookupEnv("PORT")
	if !ok {
		log.Print("port is not in environment variables; falling back to 8080")
		port = "8080"
	}
	serverName, ok := os.LookupEnv("SERVER_NAME")
	if !ok {
		log.Panic("server name is not in environment variables")
	}
	basePath, ok := os.LookupEnv("BASE_PATH")
	if !ok {
		log.Panic("base path is not in environment variables")
	}

	srv := http.Server{
		Addr:    fmt.Sprintf(":%s", port),
		Handler: server.NewHandler(basePath, serverName),
	}

	ctx, cancel := signal.NotifyContext(context.Background(), os.Interrupt)
	defer cancel()
	go func() {
		if err := srv.ListenAndServe(); err != http.ErrServerClosed {
			log.Panic("failed running server", err)
		}
	}()
	<-ctx.Done()

	timeoutCtx, cancelTimeout := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancelTimeout()
	if err := srv.Shutdown(timeoutCtx); err != nil {
		log.Panic("failed shutting down server", err)
	}
}
