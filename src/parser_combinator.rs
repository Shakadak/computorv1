pub type F = Box<Fn(&mut String) -> Result<char, String>>;

pub fn lit(c: char) -> F {
    Box::new( move
        |input: &mut String| {
            if input.starts_with(c) {
                input.remove(0);
                Ok(c)}
            else {
                Err(format!("Error, expected '{}' instead of {}.", c, input.chars().nth(0).unwrap()))}})}

pub fn or(lhs: F, rhs: F) -> F {
    Box::new( move
        |input: &mut String| {
            match lhs(input) {
                Ok(c)
                    => Ok(c),
                _
                    => rhs(input)}})}
