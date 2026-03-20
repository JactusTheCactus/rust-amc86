#[derive(Debug)]
pub struct Line {
	pub tokens: Vec<String>,
	pub line: usize,
}
pub struct Lines(pub Vec<Line>);
impl Lines {
	pub fn new(lines: Vec<String>) -> Self {
		let mut processed = vec![];
		for (n, l) in lines.iter().enumerate() {
			for i in l.split("//").nth(0).unwrap().split(';') {
				let line: Vec<String> =
					i.split_whitespace().map(|i| i.to_owned()).collect();
				processed.push(Line { tokens: line, line: n + 1 })
			}
		}
		Lines(processed)
	}
}
