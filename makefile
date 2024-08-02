run:
	go build -ldflags="-w -s" -o ./build/app_local ./cmd/*
	./build/app_local ca

deploy:
	GOOS=linux GOARCH=amd64 CGO_ENABLED=0 go build -ldflags="-w -s" -o ./build/app_linux_amd64 ./cmd/*
	@echo "----------------------------------------------------------------------------------------------------------------"
	@echo "------------------------------------------------- DEPLOYMENT ---------------------------------------------------"
	@echo "----------------------------------------------------------------------------------------------------------------"
	$(eval host := ivan@193.124.190.34)
	ssh $(host) sudo systemctl stop proxy.service
	scp ./build/app_linux_amd64 $(host):/app/app_linux_amd64
	ssh $(host) sudo setcap 'cap_net_bind_service=+ep' /app/app_linux_amd64
	ssh $(host) sudo chmod +wx /app/app_linux_amd64
	ssh $(host) sudo systemctl start proxy.service
	ssh $(host) sudo journalctl -u proxy.service -n 40 -f