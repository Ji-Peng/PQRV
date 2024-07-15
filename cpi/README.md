连续的addi a1, a1, 1的CPI是1，说明有forwarding的哈，不然应该是2

如何测试load执行的时延呢？

如下指令序列的CPI=0.7，10条指令耗时7cc，后面8条指令耗时4cc，因此lh耗时为3cc
```
lh a1, 2*0(a0)
lh a2, 2*1(a0)
addi a1, a1, 1
addi a2, a2, 1
addi a1, a1, 1
addi a2, a2, 1
addi a1, a1, 1
addi a2, a2, 1
addi a1, a1, 1
addi a2, a2, 1
```

如下指令序列的CPI=0.6，共计10条指令耗时6cc。8条addi指令耗时4cc，因此lw耗时为2cc
```
lw a1, 8*0(a0)
lw a2, 8*1(a0)
addi a1, a1, 1
addi a2, a2, 1
addi a1, a1, 1
addi a2, a2, 1
addi a1, a1, 1
addi a2, a2, 1
addi a1, a1, 1
addi a2, a2, 1
```

也就是说其实lh/lw/ld的时延都是3
- 与A55的描述类似：The load-use latency from the data of a load instruction to the ALU of a dependent datapath instruction is two cycles. This means that in a back-to-back LDR-ADD sequence the ADD instruction would stall for one cycle.
- 但上面的描述只适用于lw/ld指令，而lh则需要额外+1 cc，猜测是因为不支持转发8-bit data，这8-bit需要在流水线执行的最后一个阶段扩展为特定的数据类型。

cpi_addi_sw_v0 - cpi_addi_sw_v2，CPI几乎是一样的，奇怪，在sha3里好像隔几条指令对性能影响挺大的捏
