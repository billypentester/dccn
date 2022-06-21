#Creating Simulator
set ns [new Simulator]
set nf [open out.nam w]
$ns namtrace-all $nf
$ns rtproto DV

#Creating files for xgraph
#set f0 [open out0.tr w]
#set f1 [open out1.tr w]

#Creating Nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

#Creating Links
$ns duplex-link $n0 $n1 20Mb 10ms DropTail
$ns duplex-link $n1 $n2 20Mb 10ms DropTail
$ns duplex-link $n2 $n3 20Mb 10ms DropTail

$ns duplex-link $n3 $n4 20Mb 10ms DropTail
$ns duplex-link $n4 $n5 20Mb 10ms DropTail
$ns duplex-link $n5 $n6 20Mb 10ms DropTail
$ns duplex-link $n6 $n0 20Mb 10ms DropTail

#Creation of Protocols
set null1 [new Agent/Null]
$ns attach-agent $n3 $null1

set udp1 [new Agent/UDP]
$ns attach-agent $n0 $udp1

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
#$cbr1 set packet_size 10000

$ns connect $udp1 $null1



#Finsih Procdeure
proc finish {} {
	global ns nf
	$ns flush-trace
	close $nf
	exec nam out.nam &
	exec xgraph out0.tr out1.tr -geometry 700x400 &
	exit 0
}

$ns trmodel-at 2.0 down $n1 $n2

$ns trmodel-at 6.0 up $n1 $n2

#$ns at 0.0 "traffic"
#$ns at 0.1 "$ftp start"
#$ns at 19.0 "$ftp stop"

$ns at 0.1 "$cbr1 start"
$ns at 19.0 "$cbr1 stop"
$ns at 20.0 "finish"
$ns run
