package server_test

import (
	"io"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/nico151999/skaffold-demo/internal/server"
)

func TestNewHandler(t *testing.T) {
	basePath := "/basePath"
	name := "name"
	request := httptest.NewRequest("POST", basePath, nil)
	responseRecorder := httptest.NewRecorder()
	handler := server.NewHandler(basePath, name)
	handler.ServeHTTP(responseRecorder, request)

	if responseRecorder.Code != http.StatusOK {
		t.Fatal("response code not expected")
	}
	body, err := io.ReadAll(responseRecorder.Body)
	if err != nil {
		t.Fatal(err)
	}
	if !strings.Contains(string(body), name) {
		t.Fatal("name not included in response")
	}
}
