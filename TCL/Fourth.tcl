# creating Simulator
set ns [new Simulator]
set nf [open o.nam w]
$ns namtrace-all $nf

# Creating graph files
set f0 [open out0.tr w]
set f1 [open out1.tr w]

$ns rtproto DV

# Creating nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]

# Creating links between nodes
$ns duplex-link $n0 $n1 20Mb 10ms DropTail
$ns duplex-link $n1 $n2 20Mb 10ms DropTail
$ns duplex-link $n2 $n3 20Mb 10ms DropTail
$ns duplex-link $n3 $n4 20Mb 10ms DropTail
$ns duplex-link $n4 $n5 20Mb 10ms DropTail
$ns duplex-link $n5 $n6 20Mb 10ms DropTail
$ns duplex-link $n6 $n0 20Mb 10ms DropTail

# Creating Protocols

set udp [new Agent/UDP]
$ns attach-agent $n0 $udp
 
set null [new Agent/Null]
$ns attach-agent $n3 $null

set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp
$cbr2 set packet_size_ 1000

# Generating Traffic #cbr is Constant bit rate









# Connect source to destination

$ns connect $udp $null



# Finish Procedure
proc finish {} {
	global ns nf 
	$ns flush-trace 
	close $nf
	exec nam o.nam &
	exit 0
}
#$ns at 0.0 "traffic"
#$ns at 0.1 "$cbr1 start"
$ns rtmodel-at 2.0 down $n1 $n2
$ns rtmodel-at 6.0 up $n1 $n2
$ns at 0.1 "$cbr2 start"
$ns at 14.0 "$cbr2 stop"
$ns at 20.0 "finish"
$ns run

