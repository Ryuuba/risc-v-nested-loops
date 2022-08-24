# s1 <-> i, s2 <-> accum, s3 <-> j

        addi s1, zero, 0
        addi s2, zero, 0
        j    wh1                # outer while loop
L2:     addi s3, zero, 0
        j    wh2                # inner while loop
L1:     add  t0, s1, s3
        add  s2, s2, t0
        addi s3, s3, 1
wh2:    addi t0, zero, 10       # loop condition (inner)
        blt  s3, t0, L1
        addi s1, s1, 1
wh1:    addi t0, zero, 10       # loop ocndition (outer)
        blt  s1, t0, L2
        nop