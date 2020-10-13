-- x / 0 = 0. Go away. https://www.hillelwayne.com/post/divide-by-zero/
-- Not stolen from https://stackoverflow.com/questions/64116125/integer-division-in-dhall (This is my original development)
-- See https://discourse.dhall-lang.org/t/natural-division/366/3 also
-- Maximum 2^23 bits more in the numerator than the denominator

let Natural/le =
      λ(a : Natural) → λ(b : Natural) → Natural/isZero (Natural/subtract b a)

let Natural/equals =
      λ(a : Natural) → λ(b : Natural) → Natural/le a b && Natural/le b a

let Natural/less =
      λ(a : Natural) →
      λ(b : Natural) →
        if Natural/isZero (Natural/subtract a b) then False else True

let bits =
      λ(bits : Natural) →
        Natural/fold
          bits
          (List Natural)
          ( λ(l : List Natural) →
                l
              # [ merge
                    { Some = λ(i : Natural) → i * 2, None = 1 }
                    (List/last Natural l)
                ]
          )
          ([] : List Natural)

let quotient =
      λ(w : Natural) →
        let bits = bits w

        in  λ(n : Natural) →
            λ(m : Natural) →
              let T = { r : Natural, q : Natural } : Type

              let div =
                    List/fold
                      Natural
                      bits
                      T
                      ( λ(bit : Natural) →
                        λ(t : T) →
                          let m = m * bit

                          in  if    Natural/le m t.r
                              then  { r = Natural/subtract m t.r
                                    , q = t.q + bit
                                    }
                              else  t
                      )
                      { r = n, q = 0 }

              in  if Natural/equals m 0 then 0 else div.q

let max = 23

let powpowT = { l : Natural, n : Natural }

let powpow =
      Natural/fold
        max
        (List powpowT)
        ( λ(ts : List powpowT) →
            merge
              { Some =
                  λ(t : powpowT) → [ { l = t.l + t.l, n = t.n * t.n } ] # ts
              , None = [ { l = 1, n = 2 } ]
              }
              (List/head powpowT ts)
        )
        ([] : List powpowT)

let powpow = List/reverse powpowT powpow

let bitapprox =
      λ(n : Natural) →
        List/fold
          powpowT
          powpow
          Natural
          ( λ(e : powpowT) →
            λ(l : Natural) →
              if Natural/less n e.n then e.l else l
          )
          0

let quotient = λ(n : Natural) → λ(m : Natural) → quotient (bitapprox n) n m

let test = assert : quotient 0 0 ≡ 0

let test = assert : quotient 0 1 ≡ 0

let test = assert : quotient 0 2 ≡ 0

let test = assert : quotient 1 0 ≡ 0

let test = assert : quotient 1 1 ≡ 1

let test = assert : quotient 2 0 ≡ 0

let test = assert : quotient 2 2 ≡ 1

let test = assert : quotient 3 1 ≡ 3

let test = assert : quotient 3 2 ≡ 1

let test = assert : quotient 4 5 ≡ 0

let test = assert : quotient 9 4 ≡ 2

let test = assert : quotient 2070694161486487383910 15309440096 ≡ 135256034740

let test =
        assert
      :   quotient 331173745707472681913821994339854211788800 42
        ≡ 7885089183511254331281476055710814566400

in quotient
