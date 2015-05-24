pub struct Letter(pub char);
pub struct Digit(pub char);
pub struct Power(pub char);
pub struct Addition(pub char);
pub struct Multiplication(pub char);
pub struct Equality(pub char);

pub struct Number(pub Digit, pub Option<Box<Number>>);
