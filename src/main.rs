use {
	amc86::{
		args::Args,
		io::IO::*,
		line::{Line, Lines},
		mode::Mode::*,
		utils::read_lines,
	},
	clap::Parser,
	core::panic,
};
fn main() {
	let args = Args::parse();
	let mode = (
		if let Some(i) = args.r#in { File(i) } else { Std(In) },
		if let Some(o) = args.out { File(o) } else { Std(Out) },
	);
	println!("{in:?} -> {out:?}", in = mode.0, out = mode.1);
	let mut lines = vec![];
	match &mode.0 {
		Std(io) => match &io {
			In => {}
			Out => unreachable!(),
		},
		File(f) => {
			if let Ok(ll) = read_lines(f) {
				for l in ll.map_while(Result::ok) {
					lines.push(l)
				}
			} else {
				panic!("Could not read lines from {f}")
			}
		}
	}
	for Line { line, tokens } in Lines::new(lines).0 {
		print!("{line}:");
		for i in tokens {
			print!(" {i}")
		}
		println!()
	}
}
