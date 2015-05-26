mod syntax;
mod parser_combinator;

use std::env;
use parser_combinator::{
    lit,
    or};
use syntax::{
    Digit,
    Number};

fn main() {
    let args: Vec<_> = env::args().collect();
    if args.len() == 2 {
        println!("ok")}
    let x = Number(Digit('3'), None);
    match x {
        Number(Digit(num), _)
            => println!("{}", num)}
    let parser = or(lit('A'), lit('y'));
    let mut s = "Aytek".to_string();
    println!("{:?}", parser(&mut s));
//    s.remove(0);
    println!("{:?}", parser(&mut s));}
