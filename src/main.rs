mod syntax;

use syntax::{
    Digit,
    Number};

fn main() {
    let x = Number(Digit('3'), None);
    match x {
        Number(Digit(num), _) => println!("{}", num)}
}
