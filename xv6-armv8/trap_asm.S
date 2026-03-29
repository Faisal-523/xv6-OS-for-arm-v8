
.global trapret

.macro	exception_1_entry
	sub	sp, sp, #272
	add	x21, sp, #272            /* interrupted SP (SP_EL1) */
	mrs	x22, elr_el1             /* interrupted PC */
	mrs	x23, spsr_el1

	str	x21, [sp, #0]            /* trapframe.sp */
	str	x22, [sp, #8]            /* trapframe.pc */
	str	x23, [sp, #16]           /* trapframe.spsr */

	stp	x0, x1, [sp, #24]
	stp	x2, x3, [sp, #40]
	stp	x4, x5, [sp, #56]
	stp	x6, x7, [sp, #72]
	stp	x8, x9, [sp, #88]
	stp	x10, x11, [sp, #104]
	stp	x12, x13, [sp, #120]
	stp	x14, x15, [sp, #136]
	stp	x16, x17, [sp, #152]
	stp	x18, x19, [sp, #168]
	stp	x20, x21, [sp, #184]
	stp	x22, x23, [sp, #200]
	stp	x24, x25, [sp, #216]
	stp	x26, x27, [sp, #232]
	stp	x28, x29, [sp, #248]
	str	x30, [sp, #264]
.endm

.macro	exception_1_exit
	ldr	x22, [sp, #8]
	ldr	x23, [sp, #16]
	msr	elr_el1, x22
	msr	spsr_el1, x23

	ldp	x0, x1, [sp, #24]
	ldp	x2, x3, [sp, #40]
	ldp	x4, x5, [sp, #56]
	ldp	x6, x7, [sp, #72]
	ldp	x8, x9, [sp, #88]
	ldp	x10, x11, [sp, #104]
	ldp	x12, x13, [sp, #120]
	ldp	x14, x15, [sp, #136]
	ldp	x16, x17, [sp, #152]
	ldp	x18, x19, [sp, #168]
	ldp	x20, x21, [sp, #184]
	ldp	x22, x23, [sp, #200]
	ldp	x24, x25, [sp, #216]
	ldp	x26, x27, [sp, #232]
	ldp	x28, x29, [sp, #248]
	ldr	x30, [sp, #264]
	add	sp, sp, #272
	eret
.endm

.macro	exception_0_entry
	sub	sp, sp, #272
	mrs	x21, sp_el0
	mrs	x22, elr_el1
	mrs	x23, spsr_el1

	str	x21, [sp, #0]            /* trapframe.sp (user SP) */
	str	x22, [sp, #8]            /* trapframe.pc (user PC) */
	str	x23, [sp, #16]           /* trapframe.spsr */

	stp	x0, x1, [sp, #24]
	stp	x2, x3, [sp, #40]
	stp	x4, x5, [sp, #56]
	stp	x6, x7, [sp, #72]
	stp	x8, x9, [sp, #88]
	stp	x10, x11, [sp, #104]
	stp	x12, x13, [sp, #120]
	stp	x14, x15, [sp, #136]
	stp	x16, x17, [sp, #152]
	stp	x18, x19, [sp, #168]
	stp	x20, x21, [sp, #184]
	stp	x22, x23, [sp, #200]
	stp	x24, x25, [sp, #216]
	stp	x26, x27, [sp, #232]
	stp	x28, x29, [sp, #248]
	str	x30, [sp, #264]
.endm

.macro	exception_0_exit
	ldr	x21, [sp, #0]
	ldr	x22, [sp, #8]
	ldr	x23, [sp, #16]
	msr	sp_el0, x21
	msr	elr_el1, x22
	msr	spsr_el1, x23

	ldp	x0, x1, [sp, #24]
	ldp	x2, x3, [sp, #40]
	ldp	x4, x5, [sp, #56]
	ldp	x6, x7, [sp, #72]
	ldp	x8, x9, [sp, #88]
	ldp	x10, x11, [sp, #104]
	ldp	x12, x13, [sp, #120]
	ldp	x14, x15, [sp, #136]
	ldp	x16, x17, [sp, #152]
	ldp	x18, x19, [sp, #168]
	ldp	x20, x21, [sp, #184]
	ldp	x22, x23, [sp, #200]
	ldp	x24, x25, [sp, #216]
	ldp	x26, x27, [sp, #232]
	ldp	x28, x29, [sp, #248]
	ldr	x30, [sp, #264]
	add	sp, sp, #272
	eret
.endm

trapret:
	exception_0_exit

/* Exception vectors */

	.align	12
	.globl	vectors
vectors:
	/* Current EL with SP0 */
	.align	7
	b	_el_current_bad_sync
	.align	7
	b	_el_current_bad_irq
	.align	7
	b	_el_current_bad_fiq
	.align	7
	b	_el_current_bad_error

	/* Current EL with SPx */
	.align	7
	b	_el_current_sync
	.align	7
	b	_el_current_irq
	.align	7
	b	_el_current_fiq
	.align	7
	b	_el_current_error

	/* Lower EL using AArch64 */
	.align	7
	b	_el_lower_sync
	.align	7
	b	_el_lower_irq
	.align	7
	b	_el_lower_fiq
	.align	7
	b	_el_lower_error

	.align	6
_el_current_bad_sync:
	exception_1_entry
	mov	x0, sp
	mov	x1, #1
	mrs	x2, esr_el1
	bl	bad_handler
	b	.

	.align	6
_el_current_bad_irq:
	exception_1_entry
	mov	x0, sp
	mov	x1, #2
	mrs	x2, esr_el1
	bl	bad_handler
	b	.

	.align	6
_el_current_bad_fiq:
	exception_1_entry
	mov	x0, sp
	mov	x1, #3
	mrs	x2, esr_el1
	bl	bad_handler
	b	.

	.align	6
_el_current_bad_error:
	exception_1_entry
	mov	x0, sp
	mov	x1, #4
	mrs	x2, esr_el1
	bl	bad_handler
	b	.


	.align	6
_el_current_sync:
	exception_1_entry
	mrs	x2, esr_el1
	lsr	x24, x2, #26
	cmp	x24, #0x25
	b.eq	el1_da
	cmp	x24, #0x21
	b.eq	el1_ia
	b	el1_default

el1_da:
	mov	x0, sp
	mov	x1, #1
	bl	dabort_handler
	b	.

el1_ia:
	mov	x0, sp
	mov	x1, #1
	bl	iabort_handler
	b	.

el1_default:
	mov	x0, sp
	mov	x1, #1
	bl	default_handler
	b	.

	.align	6
_el_current_irq:
	exception_1_entry
	mov	x0, sp
	mov	x1, #1
	mrs	x2, esr_el1
	bl	irq_handler
	exception_1_exit

	.align	6
_el_current_fiq:
	exception_1_entry
	mov	x0, sp
	mov	x1, #1
	mrs	x2, esr_el1
	bl	fiq_handler
	b	.

	.align	6
_el_current_error:
	exception_1_entry
	mov	x0, sp
	mov	x1, #1
	mrs	x2, esr_el1
	bl	error_handler
	b	.


	.align	6
_el_lower_sync:
	exception_0_entry
	mrs	x2, esr_el1
	lsr	x24, x2, #26
	cmp	x24, #0x15
	b.eq	el0_svc
	cmp	x24, #0x24
	b.eq	el0_da
	cmp	x24, #0x20
	b.eq	el0_ia
	cmp	x24, #0x00
	b.eq	el0_undef
	b	el0_default

el0_svc:
	mov	x0, sp
	mov	x1, #0
	bl	swi_handler
	exception_0_exit

el0_da:
	mov	x0, sp
	mov	x1, #0
	bl	dabort_handler
	b	.

el0_ia:
	mov	x0, sp
	mov	x1, #0
	bl	iabort_handler
	b	.

el0_undef:
	mov	x0, sp
	mov	x1, #0
	bl	und_handler
	b	.

el0_default:
	mov	x0, sp
	mov	x1, #0
	bl	default_handler
	b	.

	.align	6
_el_lower_irq:
	exception_0_entry
	mov	x0, sp
	mov	x1, #0
	mrs	x2, esr_el1
	bl	irq_handler
	exception_0_exit

	.align	6
_el_lower_fiq:
	exception_0_entry
	mov	x0, sp
	mov	x1, #0
	mrs	x2, esr_el1
	bl	fiq_handler
	b	.

	.align	6
_el_lower_error:
	exception_0_entry
	mov	x0, sp
	mov	x1, #0
	mrs	x2, esr_el1
	bl	error_handler
	b	.
