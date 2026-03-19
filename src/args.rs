use clap::Parser;
#[derive(Parser, Debug)]
pub struct Args {
	/// Input AMC86 file
	#[arg(short, long)]
	pub r#in: Option<String>,
	/// Output ASM file
	#[arg(short, long)]
	pub out: Option<String>,
}
