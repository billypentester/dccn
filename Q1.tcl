#creating simulator
set ns [new Simulator]
set nf [open o.nam w]  
$ns namtrace-all $nf
#creating graph files
set f0 [open out0.tr w]
set f1 [open out1.tr w]

#creating nodes
set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]
set n10 [$ns node]
set n11 [$ns node]
set n12 [$ns node]
set n13 [$ns node]
set n14 [$ns node]

#creating links
$ns duplex-link $n1 $n9 20Mb 10ms DropTail
$ns duplex-link $n2 $n9 20Mb 10ms DropTail
$ns duplex-link $n3 $n9 20Mb 10ms DropTail
$ns duplex-link $n4 $n9 20Mb 10ms DropTail
$ns duplex-link $n5 $n10 20Mb 10ms DropTail
$ns duplex-link $n6 $n10 20Mb 10ms DropTail
$ns duplex-link $n7 $n10 20Mb 10ms DropTail
$ns duplex-link $n8 $n10 20Mb 10ms DropTail
$ns duplex-link $n9 $n11 20Mb 10ms DropTail
$ns duplex-link $n10 $n11 20Mb 10ms DropTail
$ns duplex-link $n11 $n12 20Mb 10ms DropTail
$ns duplex-link $n11 $n13 20Mb 10ms DropTail
$ns duplex-link $n12 $n14 20Mb 10ms DropTail

#Creating protocols
set tcp [new Agent/TCP]
$ns attach-agent $n1 $tcp
$ns attach-agent $n2 $tcp
$ns attach-agent $n3 $tcp
$ns attach-agent $n4 $tcp

set udp [new Agent/UDP]
$ns attach-agent $n5 $udp
$ns attach-agent $n6 $udp
$ns attach-agent $n7 $udp
$ns attach-agent $n8 $udp

#Generating Trafic
set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $tcp
$cbr1 set packet_size_ 1000

set cbr2 [new Application/Traffic/CBR]
$cbr2 attach-agent $udp
$cbr2 set packet_size_ 1000

# Generating Sink
set null1 [new Agent/TCPSink]
$ns attach-agent $n14 $null1

set null2 [new Agent/LossMonitor]
$ns attach-agent $n14 $null2

#Connecting Source
$ns connect $tcp $null1
$ns connect $udp $null2

#creating graph procedure
proc traffic {} {
global null1 null2 f0 f1
set ns [Simulator instance]
set time 0.5
set bw0 [$null1 set bytes_]
set bw1 [$null2 set bytes_]
set now [$ns now]
puts $f0 "$now [expr $bw0/$time*8/1000000]"
puts $f1 "$now [expr $bw1/$time*8/1000000]"
$null1 set bytes_ 0
$null2 set bytes_ 0
$ns at [expr $now+$time] "traffic"

}
proc finish {} {
global ns nf f0 f1
$ns flush-trace
close $nf
close $f0
close $f1
exec nam o.nam &
exec xgraph out0.tr out1.tr -geometry 700x400 &
exit 0
}

$ns at 0.0 "traffic"
$ns at 0.1 "$cbr1 start"
$ns at 19.0 "$cbr1 stop"
$ns at 0.3 "$cbr2 start"
$ns at 19.5 "$cbr2 stop"

$ns at 20.0 "finish"
$ns run