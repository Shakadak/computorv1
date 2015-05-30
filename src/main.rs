mod syntax;
mod parser_combinator;

use std::env;
use parser_combinator::{
    Parser};
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
    let parse_ua = Parser::literal('A');
    let parse_y = Parser::literal('y');
    let parser = parse_ua.and(parse_y);
    let parser2 = parser.f.clone();
    let s = "    Aytek".to_string();
    let mut i = s.chars().peekable();
    println!("{:?}", Parser::skip_whitespace().and(Parser::option(Parser::digit())).and(Parser::skip_whitespace()).parse(&mut i));
    println!("{:?}", parser.parse(&mut i));
    println!("{:?}", i.nth(1));
    println!("{:?}", i.peek());
    println!("{:?}", vec![1, 2, 3]);}
