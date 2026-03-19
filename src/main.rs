use {
	amc86::{args::Args, io::IO, line::Line, lines::Lines, mode::Mode, utils::read_lines},
	clap::Parser,
	core::panic,
};
fn main() {
	let args = Args::parse();
	let mode = (
		if let Some(i) = args.r#in {
			Mode::File(i)
		} else {
			Mode::Std(IO::In)
		},
		if let Some(o) = args.out {
			Mode::File(o)
		} else {
			Mode::Std(IO::Out)
		},
	);
	// println!("<{:?}>", mode.0);
	let mut lines = vec![];
	match &mode.0 {
		Mode::Std(io) => match &io {
			IO::In => {}
			IO::Out => unreachable!(),
		},
		Mode::File(f) => {
			if let Ok(ll) = read_lines(f) {
				for l in ll.map_while(Result::ok) {
					lines.push(l);
				}
			} else {
				panic!("Could not read lines from {f}");
			}
		}
	}
	for Line { line, tokens } in Lines::new(lines).0 {
		print!("{line}:");
		for i in tokens {
			print!(" {i:?}");
		}
		println!();
		// println!("{line}: {tokens:?}");
	}
	// println!("<{:?}>", mode.1);
}
