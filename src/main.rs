//#![crate_type = "staticlib"]

#![no_std]
#![no_main]

#![feature(asm_experimental_arch)]
//#![feature(stdsimd)]

#[cfg(target_arch = "arcv2")]
use core::arch::arcv2::*;//{lr, sr};

use core::panic::PanicInfo;
use core::arch::asm;


struct AuxPeripherals {
	timer0: Option<Timer>,
	timer1: Option<Timer>,
}
impl AuxPeripherals {
	fn take_timer0(&mut self) -> Timer {
		self.timer0.take().unwrap()
	}
}

struct Timer {
}
impl Timer {
	fn count() -> u32 {
		arcv2::lr(0x100);
		0
	}
	fn control() -> u32 {
		0
	}
	fn limit() -> u32 {
		0
	}
}




static mut AUX_PERIPH: AuxPeripherals = AuxPeripherals {
	timer0: Some(Timer {}),
	timer1: Some(Timer {}),
};

#[no_mangle]
pub extern "C" fn main() -> ! {
	unsafe {
		let timer0 = unsafe {AUX_PERIPH.take_timer0()};
		asm!["nop"];
		asm!["sync"];
		asm!["flag 1"];
	
	}
	loop {}
}

#[panic_handler]
unsafe fn panic(_info: &PanicInfo) -> ! {
	asm!["flag 1"];
	loop {}
}
