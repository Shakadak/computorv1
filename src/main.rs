extern crate parser_combinators;
use parser_combinators::{
    Parser,
    ParserExt,
    many1,
    try,
    string,
    optional};
use parser_combinators::char;
use parser_combinators::combinator;

fn main() {
    let mut natural = many1::<String, _>(char::digit());

    let minus = char::char('-');

    let relatif =
        optional(minus.clone())
        .and(natural.clone())
        .map(|x| {
            let mut ret = String::new();
            if let Some(minus) = x.0 {
                ret.push(minus);}
            ret.push_str(&x.1);
            ret});

    let decimal = optional(char::char('.')
                      .and(natural.clone())
                      .map(|x| {
                            let mut ret = String::new();
                            ret.push(x.0);
                            ret.push_str(&x.1);
                            ret}));

    let mut real = relatif.and(decimal)
        .map(|x| {
            let mut ret = String::new();
            ret.push_str(&x.0);
            if let Some(decimal) = x.1 {
                ret.push_str(&decimal);}
            ret.parse::<f64>().unwrap()});

    println!("{:?}", natural.parse("123"));
    println!("{:?}", real.parse("-24.5"));
    println!("{:?}", "-34.5".to_string().parse::<f64>());
}
