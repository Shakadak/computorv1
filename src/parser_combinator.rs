pub fn lit(c: char) -> Box<Fn(&mut String) -> Result<char, String>> {
    Box::new( move
        |input: &mut String| {
            if input.starts_with(c) {
                input.remove(0);
                Ok(c)}
            else {
                Err(format!("Error, expected '{}' instead of {}.", c, input.chars().nth(0).unwrap()))}})}
