@lazyglobal off.

local function idx {
    parameter m, i, j.
    return (j - 1) * m + i + 1.
}

local function klaInit {
    parameter m, n, v.
    local a is List(m, n).
    local end is m * n + 2.
    from { local i is 2. } until i = end step { set i to i + 1. } do {
        a:add(v).
    }
    return a.
}

function klaZeros {
    parameter m, n is m.
    return klaInit(m, n, 0).
}

function klaOnes {
    parameter m, n is m.
    return klaInit(m, n, 1).
}

function klaEye {
    parameter n.
    local a is klaInit(n, n, 0).
    from { local i is a:length - 1. } until i < 2 step { set i to i - n - 1. } do {
        set a[i] to 1.
    }
    return a.
}

function klaColumns {
    parameter a.
    local m is a[0]:length.
    local n is a:length.
    local b is List(m, n).
    for col in a {
        for v in col {
            b:add(v).
        }
    }
    return b.
}

function klaRows {
    parameter a.
    local m is a:length.
    local n is a[0]:length.
    local b is List(m, n).
    from { local j is 0. } until j = n step { set j to j + 1. } do {
        for row in a {
            b:add(row[j]).
        }        
    }
    return b.
}

function klaGet {
    parameter a, i, j.
    return a[idx(a[0], i, j)].
}

function klaSet {
    parameter a, i, j, s.
    set a[idx(a[0], i, j)] to s.
}

function klaSize {
    parameter a.
    return a:subList(0, 2).
}

function klaNorm {
    parameter a.
    local x is 0.
    from { local i is a:length - 1. } until i < 2 step { set i to i - 1. } do {
        set x to x + a[i] * a[i].
    }
    return sqrt(x).
}

function klaLNorm {
    parameter a, l is 2.
    local x is 0.
    from { local i is a:length - 1. } until i < 2 step { set i to i - 1. } do {
        set x to x + pow(a[i], l).
    }
    return pow(x, 1 / l).
}

function klaTranspose {
    parameter a.
    local m is a[1].
    local n is a[0].
    if m = 1 and n = 1 {
        local b is a:copy.
        set b[0] to m.
        set b[1] to n.
        return b.
    }
    local b is List(m, n).
    from { local i is 1. } until i > n step { set i to i + 1. } do {
        from { local j is 1. } until j > m step { set j to j + 1. } do {
            b:add(a[idx(n, i, j)]).
        }
    }
    return b.
}

function klaSum {
    parameter a, b.
    if not a:length = b:length print 1 / 0.
    set a to a:copy.
    from { local i is a:length - 1. } until i < 2 step { set i to i - 1. } do {
        set a[i] to a[i] + b[i].
    }
    return a.
}

function klaSProd {
    parameter s, a.
    set a to a:copy.
    from { local i is a:length - 1. } until i < 2 step { set i to i - 1. } do {
        set a[i] to s * a[i].
    }
    return a.
}

function klaMProd {
    parameter a, b.
    if not a[1] = b[0] print 1 / 0.
    local m is a[0].
    local n is b[1].
    local p is a[1].
    local c is List(m, n).
    from { local j is 1. } until j > n step { set j to j + 1. } do {
        from { local i is 1. } until i > m step { set i to i + 1. } do {
            local tmp is 0.
            from { local k is 1. } until k > p step { set k to k + 1. } do {
                set tmp to tmp + a[idx(m, i, k)] * b[idx(p, k, j)].
            }
            c:add(tmp).
        }
    }
    return c.
}

function klaNormalize {
    parameter a.
    return klaSProd(1 / klaNorm(a), a).
}

function klaQRDecompose {
    parameter a.
    local m is a[0].
    local n is a[1].
    local q is a:copy.
    local r is klaInit(n, n, 0).
    local col is List().
    from { local j is 1. } until j > n step { set j to j + 1. } do {
        col:add(idx(m, 1, j)).
    }
    from { local j is 1. } until j > n step { set j to j + 1. } do {
        local qj is klaColumns(List(a:subList(col[j - 1], m))).
        local aj is klaTranspose(qj).
        from { local k is 1. } until k = j step { set k to k + 1. } do {
            local qk is klaColumns(List(q:subList(col[k - 1], m))).
            local v is klaMProd(aj, qk)[2].
            set r[idx(n, k, j)] to v.
            set qj to klaSum(qj, klaSProd(-v, qk)).
        }
        local v is klaNorm(qj).
        set r[idx(n, j, j)] to v.
        from { local i is 0. } until i = m step { set i to i + 1. } do {
            set q[col[j - 1] + i] to qj[i + 2] / v.
        } 
    }
    return List(q, r).
}

function klaBackslash {
    parameter a, b.
    if not a[0] = b[0] print 1 / 0.
    local n is a[1].
    local p is b[1].
    local x is klaInit(n, p, 0).
    local qr is klaQRDecompose(a).
    local z is klaMProd(klaTranspose(qr[0]), b).
    local r is qr[1].
    from { local j is 1. } until j > p step { set j to j + 1. } do {
        from { local i is n. } until i = 0 step { set i to i - 1. } do {
            local tmp is z[idx(n, i, j)].
            from { local k is n. } until k = i step { set k to k - 1. } do {
                set tmp to tmp - r[idx(n, i, k)] * x[idx(n, k, j)].
            }
            set x[idx(n, i, j)] to tmp / r[idx(n, i, i)].
        }
    }
    return x.
}

function klaPrint {
    parameter a.
    local m is a[0].
    local n is a[1].
    from { local i is 1. } until i > m step { set i to i + 1. } do {
        local s is "".
        from { local j is 1. } until j > n step { set j to j + 1. } do {
            local x is a[idx(m, i, j)].
            if x >= 0 set s to s + " ".
            set s to s + ("" + round(x, 4)):padLeft(6) + "    ".
        }
        print s.
    }
}
