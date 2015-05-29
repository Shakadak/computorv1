mod syntax;
mod parser_combinator;

use std::env;
use parser_combinator::{
    lit};
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
    let parser = lit('A');
    let s = "Aytek".to_string();
    let mut i = s.chars().peekable();
 //   i.next();
//    println!("{:?}", parser(&mut i));
    println!("{:?}", i.nth(1));}
