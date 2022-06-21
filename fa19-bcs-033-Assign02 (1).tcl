# creating Simulator
set ns [new Simulator]
set nf [open o.nam w]
$ns namtrace-all $nf

# Creating nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]

# Creating links between nodes
$ns duplex-link $n0 $n2 20Mb 10ms DropTail
$ns duplex-link $n1 $n2 20Mb 10ms DropTail
$ns duplex-link $n2 $n3 20Mb 10ms DropTail
$ns duplex-link $n2 $n4 20Mb 10ms DropTail

# Creating Protocols
set tcp [new Agent/TCP]
$ns attach-agent $n0 $tcp 
set tcp2 [new Agent/TCP]
$ns attach-agent $n1 $tcp2

set udp [new Agent/UDP]
$ns attach-agent $n3 $udp
set udp2 [new Agent/UDP]
$ns attach-agent $n4 $udp2

# Generating Traffic
set cbr [new Application/Traffic/CBR]
$cbr attach-agent $tcp
$cbr set packet_size_ 1000
set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $tcp2
$cbr2 set packet_size_ 1000

set cbr3 [new Application/Traffic/CBR]
$cbr3 attach-agent $udp
$cbr3 set packet_size_ 1000
set cbr4 [new Application/Traffic/CBR]
$cbr4 attach-agent $udp2
$cbr4 set packet_size_ 1000


# Creating sink for destination
set null1 [new Agent/TCPSink]
$ns attach-agent $n2 $null1

set null2 [new Agent/TCPSink]
$ns attach-agent $n2 $null2

set null3 [new Agent/LossMonitor]
$ns attach-agent $n2 $null3

set null4 [new Agent/LossMonitor]
$ns attach-agent $n2 $null4


# Connect source to destination
$ns connect $tcp $null1
$ns connect $tcp2 $null2
$ns connect $udp $null3
$ns connect $udp2 $null4


# Finish Procedure
proc finish {} {
	global ns nf 
	$ns flush-trace 
	close $nf
	exec nam o.nam &
	exit 0
}

$ns at 0.3 "$cbr start"
$ns at 5.5 "$cbr stop"
$ns at 0.3 "$cbr2 start"
$ns at 5.5 "$cbr2 stop"
$ns at 0.3 "$cbr3 start"
$ns at 5.5 "$cbr3 stop"
$ns at 0.3 "$cbr4 start"
$ns at 5.5 "$cbr4 stop"



$ns at 20.0 "finish"
$ns run

