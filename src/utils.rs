use std::{
	fs::File,
	io::{self, BufRead, BufReader, Lines, Result},
	path::Path,
};
pub fn read_lines<P>(filename: P) -> Result<Lines<BufReader<File>>>
where
	P: AsRef<Path>,
{
	let file = File::open(filename)?;
	let buffer = BufReader::new(file);
	Ok(buffer.lines())
}
