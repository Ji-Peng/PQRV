# PIISM

## SHA3 optimization using PIISM step-by-step

命名规则：`vr0`中的r意味着该版本是功能正确实现，`ve0`中的e意味着该版本是功能错误实现，仅仅为了观察消除数据hazards带来的性能改进。

`fips202_rv64im_vr0.S`是一个未充分优化的keccak实现on RV64IM，我们观察到其中的如下片段存在RAW hazards：

```
.macro XOR5 out, S00, S01, S02, S03, S04
    xor \out, \S00, \S01
    xor \out, \out, \S02
    xor \out, \out, \S03
    xor \out, \out, \S04
.endm
```
我们将其修改为如下序列来消除RAW hazards，因此得到了`fips202_rv64im_ve0.S`，该版本是错误的sha3实现，仅仅为了观察RAW hazards对性能的影响
```
.macro XOR5 out, S00, S01, S02, S03, S04
    xor \out, \S00, \S00
    xor \S01, \S01, \S01
    xor \S02, \S02, \S03
    xor \S04, \S04, \S04
.endm
```

性能测试：
```
./speed_piism_sha3_vr0
KeccakF1600_StatePermute_RV64ASM cycles/insts/CPI=3468/5000/0.69

./speed_piism_sha3_ve0
KeccakF1600_StatePermute_RV64ASM cycles/insts/CPI=3322/5000/0.66
```

消除上述`XOR5`的数据依赖后，我们得到了`fips202_rv64im_vr1.S`，消除数据依赖的方法包括：
- 我们将两个独立的`XOR5`合并，从而形成了`XOR5_x2`
- 我们将`XOR5`与`EachXOR`进行了合并，从而形成了`XOR5_EachXOR`
- 对于一些不方便与其他宏合并的代码区域，我们选择将多个宏展开，并进行交替，从而消除RAW hazards

该版本的性能测试如下：
```
./speed_piism_sha3_vr1
KeccakF1600_StatePermute_RV64ASM cycles/insts/CPI=3319/5000/0.66
```
基于该版本，我们继续消除数据hazards：
我们观察到如下与`ROL`相关的代码片段存在RAW hazards：
```
.macro ROLn out, in, tmp, n
    slli \tmp, \in, \n
    srli \out, \in, 64-\n
    xor  \out, \out, \tmp
.endm

.macro ROL1 out, in, tmp
    ROLn \out, \in, \tmp, 1
.endm

ROL1 \T02, \T01, \T03
xor  \T02, \T02, \T00
```
将上述类似的数据hazards消除后，我们得到了`fips202_rv64im_ve1.S`，其性能如下：
```
./speed_piism_sha3_ve1
KeccakF1600_StatePermute_RV64ASM cycles/insts/CPI=2949/5000/0.59
```

这里咱们尝试下stack如何？
我们将`ROL`附近的宏全部展开，并且进行了交替，从而消除上述RAW hazards，得到了`fips202_rv64im_vr2.S`，其性能如下：
```
./speed_piism_sha3_vr2
KeccakF1600_StatePermute_RV64ASM cycles/insts/CPI=2916/5000/0.58
```

接下来是类似于`xoror,xornotor`的代码片段，其中每个宏中均存在RAW hazards，我们将这些hazards全部消除得到了`fips202_rv64im_ve2.S`，其性能如下：
```
KeccakF1600_StatePermute_RV64ASM cycles/insts/CPI=2826/5000/0.57
```

我们将所有的宏全部展开，并进行了交替，得到了`fips202_rv64im_vr3.S`，其性能如下：
```
KeccakF1600_StatePermute_RV64ASM cycles/insts/CPI=2763/5000/0.55
```

我们尝试将一个寄存器暂时存到栈里，来消除因为没有额外的寄存器来临时使用所导致的不可避免的RAW hazards，即如下2个片段：
```
# Listing 1
xor \S21, \S21, \T02
slli \T02, \T04, 1
xor  \T01, \T01, \T02
srli \T02, \T04, 63
xor  \T01, \T01, \T02
xor \T02, \S03, \S08

# Listing 2
xor \S23, \S23, \T01
slli \T01, \T00, 1
srli \T00, \T00, 63
xor  \T00, \T00, \T01
xor  \T00, \T00, \T02
slli \T01, \T02, 1
```
我们得到了`fips202_rv64im_vr4.S`，其性能如下：
```
KeccakF1600_StatePermute_RV64ASM cycles/insts/CPI=2742/5048/0.54
```
这说明了，为了对流水线进行充分的优化，即使发生了stack spilling即增加了访存指令，程序的性能依旧能有提升。