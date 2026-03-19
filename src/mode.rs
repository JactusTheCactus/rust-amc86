use crate::io::IO;
#[derive(Debug)]
pub enum Mode {
	Std(IO),
	File(String),
}
