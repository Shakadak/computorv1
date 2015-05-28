pub type F = Box<Fn(&mut String) -> Result<String, String>>;

pub fn lit(c: char) -> F {
    Box::new( move
        |input: &mut String| {
            if input.starts_with(c) {
                input.remove(0);
                Ok(c.to_string())}
            else {
                Err(format!("Error, expected {} instead of {}.", c, input.chars().nth(0).unwrap()))}})}

pub fn or(lhs: F, rhs: F) -> F {
    Box::new( move
        |input: &mut String| {
            match lhs(input) {
                Ok(c)
                    => Ok(c),
                _
                    => rhs(input)}})}

pub fn and(lhs: F, rhs: F) -> F {
    Box::new( move
        |input: &mut String| {
            match lhs(input) {
                Ok(cl)
                    => match rhs(input) {
                        Ok(cr)
                            => Ok(cl.push_str(cr[0..cr.len()])),
                        Err(s)
                            => {/*input.rewind_by(1);*/
                            Err(s)}},
                Err(s)
                    => {/*input.rewind_by(1);*/
                    Err(s)}}})}
