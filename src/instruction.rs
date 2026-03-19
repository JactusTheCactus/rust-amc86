use crate::{operand::_Operand, type_::_Type};
pub enum _Instruction {
	Def {
		type_: _Type,
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
