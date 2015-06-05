extern crate parser_combinators;

mod parser;

use parser_combinators::Parser;
use parser::{
    natural,
    real};
use std::iter::FromIterator;

fn main() {
    println!("{:?}", natural().parse("123"));
    println!("{:?}", real().parse("24.5"));
}
