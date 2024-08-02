package main

import (
	"log"
	"log/slog"
	"net"

	"github.com/nskforward/prox/internal/server"
)

func main() {
	l, err := net.Listen("tcp", ":443")
	if err != nil {
		log.Fatal(err)
	}
	slog.Info("listening :443")
	for {
		conn, err := l.Accept()
		if err != nil {
			log.Print(err)
			continue
		}
		slog.Info("connected", "client", conn.RemoteAddr())
		go server.HandleConnection(conn)
	}
}
