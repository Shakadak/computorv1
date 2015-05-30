use std::str;
use std::iter;

pub type I<'a> = iter::Peekable<str::Chars<'a>>;
pub type F = Box<Fn(&mut I) -> Result<String, String>>;

pub struct Parser {
    f: F}

impl Parser {
    pub fn new(func: F) -> Parser {
        Parser {f: func}}

    pub fn parse(self, input: &mut I) -> Result<String, String> {
        (self.f)(input)}

    pub fn literal(c: char) -> Parser {
        Parser::new(Box::new(move
            |input: &mut I| {
                match input.peek() {
                    Some(&peeked)
                    => {if peeked == c {
                            input.next();
                            Ok(peeked.to_string())}
                        else {
                            Err(format!("Error, expected '{}' instead of '{}'.", c, peeked))}}
                    None
                    => Err(format!("Error, expected '{}' instead of '{}'.", c, "nothing"))}}))}

    pub fn or(self, rhs: Parser) -> Parser {
        Parser::new(Box::new(move
            |input: &mut I| {
                match (self.f)(input) {
                    Ok(c) => Ok(c),
                    _ => (rhs.f)(input)}}))}

    pub fn and(self, rhs: Parser) -> Parser {
        Parser::new(Box::new(move
            |input: &mut I| {
                let mut dup = input.clone();
                match (self.f)(&mut dup) {
                    Ok(mut cl)
                    => match (rhs.f)(&mut dup) {
                        Ok(cr)
                        => {cl.push_str(&cr);
                            input.clone_from(&dup);
                            Ok(cl)},
                        Err(s) => Err(s)},
                    Err(s) => Err(s)}}))}

    pub fn digit() -> Parser {
        Parser::new(Box::new(move
            |input: &mut I| {
                match input.peek() {
                    None
                    => Err(format!("Error, expected '{}' instead of '{}'.", "a digit", "nothing")),
                    Some(&c)
                    => match c.is_digit(10) {
                        false
                        => Err(format!("Error, expected '{}' instead of '{}'.", "a digit", c)),
                        true
                        => {input.next();
                            Ok(c.to_string())}}}}))}

    pub fn skip_whitespace() -> Parser {
        Parser::new(Box::new(move
            |input: &mut I| {
                loop {
                    match input.peek() {
                        Some(&c) if c.is_whitespace()
                        => {input.next();},
                        _
                        => break}}
                Ok(String::new())}))}

    pub fn option(p: Parser) -> Parser {
        Parser::new(Box::new(move
            |input: &mut I| {
                let mut s = String::new();
                if let Ok(tok) = (p.f)(input) {
                    s.push_str(&tok);}
                Ok(s)}))}

    pub fn repeat(p: Parser) -> Parser {
        Parser::new(Box::new(move
            |input: &mut I| {
                let mut s = String::new();
                loop {
                    match (p.f)(input) {
                        Ok(tok)
                        => {s.push_str(&tok);}
                        _
                        => break}}
                Ok(s)}))}

    pub fn repeat1(p: Parser) -> Parser {
        p.and(Parser::repeat(p))}
}
