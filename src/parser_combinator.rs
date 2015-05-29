use std::str;
use std::iter;

pub type I<'a> = iter::Peekable<str::Chars<'a>>;
pub type F = Box<Fn(&mut I) -> Result<String, String>>;

pub fn lit(c: char) -> F {
    Box::new( move
        |input: &mut I| {
            match input.peek() {
                Some(&peeked)
                => {if peeked == c {
                        input.next();
                        Ok(peeked.to_string())}
                    else {
                        Err(format!("Error, expected {} instead of {}.", c, peeked))}}
                None
                => Err(format!("Error, expected {} instead of {}.", c, "nothing"))}})}

pub fn or(lhs: F, rhs: F) -> F {
    Box::new( move
        |input: &mut I| {
            match lhs(input) {
                Ok(c)
                => Ok(c),
                _
                => rhs(input)}})}

pub fn and(lhs: F, rhs: F) -> F {
    Box::new( move
        |input: &mut I| {
            match lhs(input) {
                Ok(mut cl)
                => match rhs(input) {
                    Ok(cr)
                    => {cl.push_str(&cr[0..cr.len()]);
                        Ok(cl)},
                    Err(s)
                    => {/*input.rewind_by(1);*/
                        Err(s)}},
                Err(s)
                => {/*input.rewind_by(1);*/
                    Err(s)}}})}
