extern crate parser_combinators;

use self::parser_combinators::{
    Parser,
    ParserExt,
    many1,
    try,
    string,
    parser,
    optional,
    primitives};

use self::parser_combinators::char;
use self::parser_combinators::char::{
    Char,
    Digit};

use self::parser_combinators::combinator::{
    And,
    Many1,
    Map,
    Optional};

pub fn natural<I>() -> Many1<String, Digit<I>>
where I: primitives::Stream<Item=char> {
    many1::<String, _>(char::digit())}

pub fn relatif<I>() -> Map<And<Optional<Char<I>>, Many1<String, Digit<I>>>, fn((Option<char>, String)) -> String>
where I: primitives::Stream<Item=char> {
    optional(char::char('-'))
        .and(natural())
        .map(clean_relatif)}

fn clean_relatif(tuple: (Option<char>, String)) -> String {
    let mut ret = String::new();
    if let Some(minus) = tuple.0 {
        ret.push(minus);}
    ret.push_str(&tuple.1);
    ret}

pub fn decimal<I>() -> Optional<Map<And<Char<I>, Many1<String, Digit<I>>>, fn((char, String)) -> String>>
where I: primitives::Stream<Item=char> {
    optional(char::char('.')
             .and(natural())
             .map(clean_decimal))}

fn clean_decimal(tuple: (char, String)) -> String {
    let mut ret = String::new();
    ret.push(tuple.0);
    ret.push_str(&tuple.1);
    ret}

pub fn real<I>() -> Map<And<Map<And<Optional<Char<I>>, Many1<String, Digit<I>>>, fn((Option<char>, String)) -> String>, Optional<Map<And<Char<I>, Many1<String, Digit<I>>>, fn((char, String)) -> String>>>, fn((String, Option<String>)) -> f64>
where I: primitives::Stream<Item=char> {
    relatif().and(decimal())
        .map(clean_real)}

fn clean_real(tuple: (String, Option<String>)) -> f64 {
    let mut ret = String::new();
    ret.push_str(&tuple.0);
    if let Some(decimal) = tuple.1 {
        ret.push_str(&decimal);}
    ret.parse::<f64>().unwrap()}
