use crate::type_::_Type;
pub enum _Operand {
	Variable(String),
	Label(String),
	Literal(_Type),
}
