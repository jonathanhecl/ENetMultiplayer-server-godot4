package main

// Open UDP port 7070 for ENet traffic in golang

import (
	"fmt"
	"net"
)

func main() {
	fmt.Println("ENet server starting up...")

	// Open UDP port 7070 for ENet traffic
	fmt.Println("Opening UDP port 7070 for ENet traffic...")
	udpAddr, err := net.ResolveUDPAddr("udp", ":7070")
	if err != nil {
		fmt.Println("Error: ", err)
		return
	}

	// Listen for incoming ENet traffic
	fmt.Println("Listening for incoming ENet traffic...")
	conn, err := net.ListenUDP("udp", udpAddr)
	if err != nil {
		fmt.Println("Error: ", err)
		return
	}

	// Close the connection when the application closes
	defer conn.Close()

	for {
		// Read incoming ENet traffic
		fmt.Println("Reading incoming ENet traffic...")
		buffer := make([]byte, 1024)
		n, addr, err := conn.ReadFromUDP(buffer)
		if err != nil {
			fmt.Println("Error: ", err)
			return
		}

		// Print the ENet traffic
		fmt.Println("Received ", string(buffer[0:n]), " from ", addr)
		// show the bytes received in hex
		fmt.Printf("% x\n", buffer[0:n])

		// last 4 bytes are the ID in a uint32, so convert to int32
		id := int32(buffer[n-4])<<24 | int32(buffer[n-3])<<16 | int32(buffer[n-2])<<8 | int32(buffer[n-1])
		fmt.Println("ID: ", id)

		// Send ENet traffic back to the client
		fmt.Println("Sending ENet traffic back to the client...")
		_, err = conn.WriteToUDP(buffer[0:n], addr)
		if err != nil {
			fmt.Println("Error: ", err)
			return
		}
	}
}
