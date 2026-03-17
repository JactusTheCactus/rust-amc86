use clap::Parser;
pub mod utils;
#[derive(Parser, Debug)]
pub struct Args {
	/// Input AMC86 file
	#[arg(short, long)]
	pub r#in: Option<String>,
	/// Output ASM file
	#[arg(short, long)]
	pub out: Option<String>,
}
struct _Line {
	tokens: Vec<String>,
	line: usize,
}
enum _Type {
	Int(i64),
	Str(String),
	Bool(bool),
}
enum _Operand {
	Variable(String),
	Label(String),
	Literal(_Type),
}
enum _Instruction {
	Def {
		r#type: _Type,
		name: _Operand,
		expr: Vec<_Operand>,
	},
	Exit(_Operand),
	Incr(_Operand),
	Print(_Operand),
	PrintLn(String),
	Jump(_Operand),
	If {
		cond: _Operand,
		body: Box<_Instruction>,
	},
	Le(_Operand, _Operand),
}
#[derive(Debug)]
pub enum IO {
	In,
	Out,
}
#[derive(Debug)]
pub enum Mode {
	Std(IO),
	File(String),
}
pub struct Lines(pub Vec<Vec<String>>);
impl Lines {
	pub fn new(lines: Vec<String>) -> Self {
		let mut processed = vec![];
		for l in lines {
			for i in l.split("//").nth(0).unwrap().split(';') {
				processed.push(i.split_whitespace().map(|i| i.to_owned()).collect());
			}
		}
		Lines(processed)
	}
}
