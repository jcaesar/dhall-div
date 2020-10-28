# Division for Dhall

You're excited for a new bright day.
You've been tricked into using the using dhall, the newest esolang on the block, in your mission-critical production system.
You think to yourself: Ope, I'd like to create a config file where I dimension this volume size to be 30% larger than that input parameter, for safety and giggles.
You notice, your since-today favourite language dhall doesn't allow doing calculations on floats, and naturals only have addition, substraction, and multiplication.
But you don't fret. Because this repository exists!

## Features
A division implementation for dhall featuring
* blazingly fast
(The ~640000 small integer divisions in the test suite are executed in 10 seconds! Division was never faster!)
* slim
(Only 69 lines of code! Division was never slicker!)
* correct
(Only tested for values <800! Division was never correcter!)
* applicable to large numbers
(Dividends up to 2^2^23, but unless you have more than 64 GB of memory, you're probably limited to 2^2^19 - I don't know what kind of sarcastic remark I could make to people that are bothered by this limitation.)

Specifically, this implements long division and for `n / m`, returns a pair of values `q`, `r`, such that `m * q + r ≡ n`, where `r` is only larger than `m` if `m` is either 0 or `n / m` is larger than 2^2^23.

## Usage
```dhall
let Natural/div = λ(n : Natural) → λ(m : Natural) → 
    let div = https://github.com/jcaesar/dhall-div/releases/download/1/quotient.dhall sha256:d6a994f4b431081e877a0beac02f5dcc98f3ea5b027986114487578056cb3db9
    in (div n m).q
in  Natural/div 42 7
```

## Endorsements
[@profpatsch](https://github.com/profpatsch)
> I mean, do what floats your boat, but in like any kind of production environment I wouldn’t accept that :)

## Related
* Stackoverflow question that nerdsniped me to do this: https://stackoverflow.com/questions/64116125/integer-division-in-dhall
* Dhall forum discussion: https://discourse.dhall-lang.org/t/natural-division/366/3
* x / 0 = 0. Go away. https://www.hillelwayne.com/post/divide-by-zero/
