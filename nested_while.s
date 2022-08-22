# s1 <-> i, s2 <-> accum, s3 <-> j

        addi s1, zero, 0
        addi s2, zero, 0
        j    wh1
L2:     addi s3, zero, 0
        j    wh2
L1:     add  t0, s1, s3
        add  s2, s2, t0
        addi s3, s3, 1
        addi t0, zero, 10
        blt  s3, t0, L1
        addi s1, zero, 1
        addi t0, zero, 10
        blt  s1, t0, L2
        nop