let quotient = ./quotient.dhall

let Natural/less =
      λ(a : Natural) →
      λ(b : Natural) →
        if Natural/isZero (Natural/subtract a b) then False else True

let tq =
      λ(n : Natural) →
      λ(m : Natural) →
        let q = quotient n m in { n, m, e = q.q * m + q.r } ∧ q

let test = let t = tq 0 0 in assert : t.e ≡ t.n

let test = let t = tq 1 0 in assert : t.e ≡ t.n

let test = let t = tq 1 0 in assert : Natural/less t.r t.m ≡ False

let test = let t = tq 2 0 in assert : t.e ≡ t.n

let test = let t = tq 2 0 in assert : Natural/less t.r t.m ≡ False

let test = let t = tq 0 1 in assert : t.e ≡ t.n

let test = let t = tq 0 1 in assert : Natural/less t.r t.m ≡ True

let test = let t = tq 0 2 in assert : t.e ≡ t.n

let test = let t = tq 0 2 in assert : Natural/less t.r t.m ≡ True

let test = let t = tq 1 1 in assert : t.e ≡ t.n

let test = let t = tq 1 1 in assert : Natural/less t.r t.m ≡ True

let test = let t = tq 2 2 in assert : t.e ≡ t.n

let test = let t = tq 2 2 in assert : Natural/less t.r t.m ≡ True

let test = let t = tq 3 1 in assert : t.e ≡ t.n

let test = let t = tq 3 1 in assert : Natural/less t.r t.m ≡ True

let test = let t = tq 3 2 in assert : t.e ≡ t.n

let test = let t = tq 3 2 in assert : Natural/less t.r t.m ≡ True

let test = let t = tq 4 5 in assert : t.e ≡ t.n

let test = let t = tq 4 5 in assert : Natural/less t.r t.m ≡ True

let test = let t = tq 9 4 in assert : t.e ≡ t.n

let test = let t = tq 9 4 in assert : Natural/less t.r t.m ≡ True

let test = let t = tq 2070694161486487383910 15309440096 in assert : t.e ≡ t.n

let test =
      let t = tq 331173745707472681913821994339854211788800 42

      in  assert : t.e ≡ t.n

let Natural/all =
      λ(f : Natural → Bool) →
      λ(n : Natural) →
        let T = { i : Natural, r : Bool }

        let r =
              Natural/fold
                n
                T
                (λ(i : T) → { i = i.i + 1, r = i.r && f i.i })
                { i = 0, r = True }

        in  r.r

let Natural/allPairs =
      λ(f : Natural → Natural → Bool) →
      λ(i : Natural) →
        Natural/all (λ(n : Natural) → Natural/all (λ(m : Natural) → f n m) i) i

let quad =
      Natural/allPairs
        ( λ(n : Natural) →
          λ(m : Natural) →
            let t = tq n m

            in      Natural/less 0 m == Natural/less t.r t.m
                &&  Natural/less t.e t.n == Natural/less t.n t.e
        )

let test = assert : quad 808 ≡ True

in  < OK >
