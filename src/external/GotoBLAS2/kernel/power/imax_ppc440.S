/*********************************************************************/
/*                                                                   */
/*             Optimized BLAS libraries                              */
/*                     By Kazushige Goto <kgoto@tacc.utexas.edu>     */
/*                                                                   */
/* Copyright (c) The University of Texas, 2009. All rights reserved. */
/* UNIVERSITY EXPRESSLY DISCLAIMS ANY AND ALL WARRANTIES CONCERNING  */
/* THIS SOFTWARE AND DOCUMENTATION, INCLUDING ANY WARRANTIES OF      */
/* MERCHANTABILITY, FITNESS FOR ANY PARTICULAR PURPOSE,              */
/* NON-INFRINGEMENT AND WARRANTIES OF PERFORMANCE, AND ANY WARRANTY  */
/* THAT MIGHT OTHERWISE ARISE FROM COURSE OF DEALING OR USAGE OF     */
/* TRADE. NO WARRANTY IS EITHER EXPRESS OR IMPLIED WITH RESPECT TO   */
/* THE USE OF THE SOFTWARE OR DOCUMENTATION.                         */
/* Under no circumstances shall University be liable for incidental, */
/* special, indirect, direct or consequential damages or loss of     */
/* profits, interruption of business, or related expenses which may  */
/* arise from use of Software or Documentation, including but not    */
/* limited to those resulting from defects in Software and/or        */
/* Documentation, or loss or inaccuracy of data of any kind.         */
/*********************************************************************/

#define ASSEMBLER
#include "common.h"
	
#define RET	r3
#define X	r4
#define INCX	r5	

#define N	r6
#define NN	r7
#define XX	r8
#define PRE	r9

#define FZERO	f1

#define STACKSIZE 160

	PROLOGUE
	PROFCODE

	addi	SP, SP, -STACKSIZE
	li	r0,   0

	stfd	f14,    0(SP)
	stfd	f15,    8(SP)
	stfd	f16,   16(SP)
	stfd	f17,   24(SP)

	stfd	f18,   32(SP)
	stfd	f19,   40(SP)
	stfd	f20,   48(SP)
	stfd	f21,   56(SP)

	stfd	f22,   64(SP)
	stfd	f23,   72(SP)
	stfd	f24,   80(SP)
	stfd	f25,   88(SP)

	stfd	f26,   96(SP)
	stfd	f27,  104(SP)
	stfd	f28,  112(SP)
	stfd	f29,  120(SP)

	stfd	f30,  128(SP)
	stfd	f31,  136(SP)

	stw	r0,   144(SP)
	lfs	FZERO,144(SP)

#ifdef F_INTERFACE
	LDINT	N,    0(r3)
	LDINT	INCX, 0(INCX)
#else
	mr	N, r3
#endif

	li	RET, 0
	li	PRE, 3 * 16 * SIZE

	slwi	INCX, INCX, BASE_SHIFT
	sub	X, X, INCX

	mr	NN, N
	mr	XX, X

	cmpwi	cr0, N, 0
	ble-	LL(9999)
	cmpwi	cr0, INCX, 0
	ble-	LL(9999)

	LFDUX	f1, X, INCX

	fmr	f0, f1
	fmr	f2, f1
	fmr	f3, f1
	fmr	f4, f1
	subi	N, N, 1
	fmr	f5, f1
	srawi.	r0, N, 4
	fmr	f6, f1
	mtspr	CTR,  r0
	fmr	f7, f1
	beq-	LL(150)

	LFDUX	f16,   X, INCX
	LFDUX	f17,   X, INCX
	LFDUX	f18,   X, INCX
	LFDUX	f19,   X, INCX
	LFDUX	f20,   X, INCX
	LFDUX	f21,   X, INCX
	LFDUX	f22,   X, INCX
	LFDUX	f23,   X, INCX

	LFDUX	f24,   X, INCX
	fsub	f8,  f0,  f16
	LFDUX	f25,   X, INCX
	fsub	f9,  f1,  f17
	LFDUX	f26,   X, INCX
	fsub	f10, f2,  f18
	LFDUX	f27,   X, INCX
	fsub	f11, f3,  f19
	LFDUX	f28,   X, INCX
 	fsub	f12, f4,  f20
	LFDUX	f29,   X, INCX
	fsub	f13, f5,  f21
	LFDUX	f30,   X, INCX
	fsub	f14, f6,  f22
	LFDUX	f31,   X, INCX
	fsub	f15, f7,  f23
	bdz	LL(120)
	.align 4

LL(110):
	fsel	f0,  f8,  f0,  f16
	LFDUX	f16,   X, INCX
	fsub	f8,  f0,  f24
#ifdef PPCG4
	dcbt	X, PRE
#endif
	fsel	f1,  f9,  f1,  f17
	LFDUX	f17,   X, INCX
	fsub	f9,  f1,  f25
	fsel	f2,  f10, f2,  f18
	LFDUX	f18,   X, INCX
	fsub	f10, f2,  f26
	fsel	f3,  f11, f3,  f19
	LFDUX	f19,   X, INCX
	fsub	f11, f3,  f27

	fsel	f4,  f12, f4,  f20
	LFDUX	f20,   X, INCX
	fsub	f12, f4,  f28
#if defined(PPCG4) && defined(DOUBLE)
	dcbt	X, PRE
#endif
	fsel	f5,  f13, f5,  f21
	LFDUX	f21,   X, INCX
	fsub	f13, f5,  f29
	fsel	f6,  f14, f6,  f22
	LFDUX	f22,   X, INCX
	fsub	f14, f6,  f30
	fsel	f7,  f15, f7,  f23
	LFDUX	f23,   X, INCX
	fsub	f15, f7,  f31

	fsel	f0,  f8,  f0,  f24
	LFDUX	f24,   X, INCX
	fsub	f8,  f0,  f16
#ifdef PPCG4
	dcbt	X, PRE
#endif
	fsel	f1,  f9,  f1,  f25
	LFDUX	f25,   X, INCX
	fsub	f9,  f1,  f17
	fsel	f2,  f10, f2,  f26
	LFDUX	f26,   X, INCX
	fsub	f10, f2,  f18
	fsel	f3,  f11, f3,  f27
	LFDUX	f27,   X, INCX
	fsub	f11, f3,  f19

	fsel	f4,  f12, f4,  f28
	LFDUX	f28,   X, INCX
	fsub	f12, f4,  f20
#if defined(PPCG4) && defined(DOUBLE)
	dcbt	X, PRE
#endif
	fsel	f5,  f13, f5,  f29
	LFDUX	f29,   X, INCX
	fsub	f13, f5,  f21
	fsel	f6,  f14, f6,  f30
	LFDUX	f30,   X, INCX
	fsub	f14, f6,  f22
	fsel	f7,  f15, f7,  f31
	LFDUX	f31,   X, INCX
	fsub	f15, f7,  f23
	bdnz	LL(110)
	.align 4

LL(120):
	fsel	f0,  f8,  f0,  f16
	fsub	f8,  f0,  f24
	fsel	f1,  f9,  f1,  f17
	fsub	f9,  f1,  f25
	fsel	f2,  f10, f2,  f18
	fsub	f10, f2,  f26
	fsel	f3,  f11, f3,  f19
	fsub	f11, f3,  f27

	fsel	f4,  f12, f4,  f20
	fsub	f12, f4,  f28
	fsel	f5,  f13, f5,  f21
	fsub	f13, f5,  f29
	fsel	f6,  f14, f6,  f22
	fsub	f14, f6,  f30
	fsel	f7,  f15, f7,  f23
	fsub	f15, f7,  f31

	fsel	f0,  f8,  f0,  f24
	fsel	f1,  f9,  f1,  f25
	fsel	f2,  f10, f2,  f26
	fsel	f3,  f11, f3,  f27
	fsel	f4,  f12, f4,  f28
	fsel	f5,  f13, f5,  f29
	fsel	f6,  f14, f6,  f30
	fsel	f7,  f15, f7,  f31
	.align 4

LL(150):
	andi.	r0,  N, 15
	mtspr	CTR, r0
	beq	LL(999)
	.align 4

LL(160):
	LFDUX	f8,    X, INCX
	fsub	f16, f1, f8
	fsel	f1, f16, f1, f8
	bdnz	LL(160)
	.align 4

LL(999):
	fsub	f8,  f0,  f1
	fsub	f9,  f2,  f3
	fsub	f10, f4,  f5
	fsub	f11, f6,  f7

	fsel	f0,  f8,  f0,  f1
	fsel	f2,  f9,  f2,  f3
	fsel	f4,  f10, f4,  f5
	fsel	f6,  f11, f6,  f7

	fsub	f8,  f0,  f2
	fsub	f9,  f4,  f6
	fsel	f0,  f8,  f0,  f2
	fsel	f4,  f9,  f4,  f6

	fsub	f8,  f0,  f4
	fsel	f1,  f8,  f0,  f4
	.align 4

LL(1000):
	srawi.	r0, NN, 3
	mtspr	CTR,  r0
	beq-	LL(1150)

	LFDUX	f8,    XX, INCX
	LFDUX	f9,    XX, INCX
	LFDUX	f10,   XX, INCX
	LFDUX	f11,   XX, INCX
	LFDUX	f12,   XX, INCX
	LFDUX	f13,   XX, INCX
	LFDUX	f14,   XX, INCX
	LFDUX	f15,   XX, INCX
	bdz	LL(1120)
	.align 4

LL(1110):
	addi	RET, RET, 1
	fcmpu	cr0, f1, f8
	LFDUX	f8,   XX, INCX
	beq	cr0, LL(9999)

#ifdef PPCG4
	dcbt	XX, PRE
#endif

	addi	RET, RET, 1
	fcmpu	cr0, f1, f9
	LFDUX	f9,   XX, INCX
	beq	cr0, LL(9999)

	addi	RET, RET, 1
	fcmpu	cr0, f1, f10
	LFDUX	f10,  XX, INCX
	beq	cr0, LL(9999)

#ifdef PPCG4
	dcbt	XX, PRE
#endif

	addi	RET, RET, 1
	fcmpu	cr0, f1, f11
	LFDUX	f11,  XX, INCX
	beq	cr0, LL(9999)

	addi	RET, RET, 1
	fcmpu	cr0, f1, f12
	LFDUX	f12,  XX, INCX
	beq	cr0, LL(9999)

#ifdef PPCG4
	dcbt	XX, PRE
#endif

	addi	RET, RET, 1
	fcmpu	cr0, f1, f13
	LFDUX	f13,  XX, INCX
	beq	cr0, LL(9999)

	addi	RET, RET, 1
	fcmpu	cr0, f1, f14
	LFDUX	f14,  XX, INCX
	beq	cr0, LL(9999)

#ifdef PPCG4
	dcbt	XX, PRE
#endif

	addi	RET, RET, 1
	fcmpu	cr0, f1, f15
	LFDUX	f15,  XX, INCX
	beq	cr0, LL(9999)
	bdnz	LL(1110)
	.align 4

LL(1120):
	addi	RET, RET, 1
	fcmpu	cr0, f1, f8
	beq	cr0, LL(9999)

	addi	RET, RET, 1
	fcmpu	cr0, f1, f9
	beq	cr0, LL(9999)

	addi	RET, RET, 1
	fcmpu	cr0, f1, f10
	beq	cr0, LL(9999)

	addi	RET, RET, 1
	fcmpu	cr0, f1, f11
	beq	cr0, LL(9999)

	addi	RET, RET, 1
	fcmpu	cr0, f1, f12
	beq	cr0, LL(9999)

	addi	RET, RET, 1
	fcmpu	cr0, f1, f13
	beq	cr0, LL(9999)

	addi	RET, RET, 1
	fcmpu	cr0, f1, f14
	beq	cr0, LL(9999)

	addi	RET, RET, 1
	fcmpu	cr0, f1, f15
	beq	cr0, LL(9999)
	.align 4

LL(1150):
	andi.	r0,  NN, 7
	mtspr	CTR, r0
	beq	LL(9999)
	.align 4

LL(1160):
	LFDUX	f8,    XX, INCX
	addi	RET, RET, 1
	fcmpu	cr0, f1, f8
	beq	cr0, LL(9999)
	bdnz	LL(1160)
	.align 4

LL(9999):
	lfd	f14,    0(SP)
	lfd	f15,    8(SP)
	lfd	f16,   16(SP)
	lfd	f17,   24(SP)

	lfd	f18,   32(SP)
	lfd	f19,   40(SP)
	lfd	f20,   48(SP)
	lfd	f21,   56(SP)

	lfd	f22,   64(SP)
	lfd	f23,   72(SP)
	lfd	f24,   80(SP)
	lfd	f25,   88(SP)

	lfd	f26,   96(SP)
	lfd	f27,  104(SP)
	lfd	f28,  112(SP)
	lfd	f29,  120(SP)

	lfd	f30,  128(SP)
	lfd	f31,  136(SP)

	addi	SP, SP, STACKSIZE
	blr

	EPILOGUE
