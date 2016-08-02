import 'dart:math';
import 'dart:typed_data';
import 'inbuilts.dart';

class $PyMath {
	round(x) {
		return $PyNum.toNum(x).round();
	}

	ceil(x) {
		return $PyNum.toNum(x).ceil();
	}

	floor(x) {
		return $PyNum.toNum(x).ceil();
	}

	acos(x) {
		return acos($PyNum.toNum(x));
	}
	cos(x) {
		return cos($PyNum.toNum(x));
	}
	sin(x) {
		return sin($PyNum.toNum(x));
	}
	asin(x) {
		return asin($PyNum.toNum(x));
	}
	exp(x) {
		return exp($PyNum.toNum(x));
	}
	log(x) {
		return log($PyNum.toNum(x));
	}

	copysign(x, y) {
		if($PyNum.toNum(x).isNegative && $PyNum.toNum(y).isNegative) {
			return y;
		} else {
			return -y;
		}
	}

	

	// frexp and ldexp adapted from
	// https://github.com/czurnieden/intparts/blob/master/intparts.js
	// LICENSE: ???

	$PyTuple frexp(x) {
    	var HEAPD64 = new Float64List(2);
    	var HEAPU32 = new Uint32List.view(HEAPD64.buffer);
        var high = 0,
            tmp = 0,
            low = 0,
     		exp = 0,
     		tmpd = 0.0;

        HEAPD64[0] = x;

        if (x == 0)
            return x;

        high = HEAPU32[1];
        low = HEAPU32[0];
        tmp = 0x7fffffff & high;
        print(tmp);
        print(high);
        print(low);

        if (tmp >= 0x7ff00000 || ((tmp | low) == 0))
            return x;

        if (tmp < 0x00100000) {
            tmpd = HEAPD64[0];
            tmpd *= 18014398509481984.0;
            HEAPD64[0] = tmpd;

            high = HEAPU32[1];
            tmp = high & 0x7fffffff;
            exp = -54;
        }

        exp += ((tmp & 0xffffffff) >> 20) - 1022;
        high = (high & 0x800fffff) | 0x3fe00000;
        print(exp);
        print(high);
        HEAPU32[1] = high;
        HEAPD64[1] = exp * 1.0;
        return new $PyTuple([HEAPD64[0], HEAPD64[1]]);
    }

    num ldexp(mantissa, exponent) {
    	var HEAPD64 = new Float64List(2);
    	var HEAPU32 = new Uint32List.view(HEAPD64.buffer);
        var k = 0,
            hx = 0,
            lx = 0;
        var sign = 0;
        var tmpd = 0.0;

        HEAPD64[0] = mantissa;
        hx = HEAPU32[1];
        lx = HEAPU32[0];
        k = (hx & 0x7ff00000) >> 20;
        if (k == 0) {
            if ((lx | (hx & 0x7fffffff)) == 0) {
                return mantissa;
            }
            tmpd = HEAPD64[0];
            tmpd *= 18014398509481984.0;
            HEAPD64[0] = tmpd;
            hx = HEAPU32[1];
            k = ((hx & 0x7ff00000) >> 20) - 54;
        }
        if (k == 0x7ff) {
            return (2 * HEAPD64[0]);
        }
        k = k + exponent;
        sign = (mantissa < 0) ? -1 : 1;
        if (k > 0x7fe) {
            return 1.0e+300 * sign;
        }
        if (exponent < -50000) {
            return 1.0e-300 * sign;
        }
        k = k.round(); // convert to int
        if (k > 0) {
            hx = (hx & 0x800fffff) | (k << 20);
            HEAPU32[1] = hx;
            return HEAPD64[0];
        }
        if (k <= -54) {
            if (exponent > 50000) {
                return 1.0e+300 * sign;
            }
            return 1.0e-300 * sign;
        }
        k += 54;
        hx = (hx & 0x800fffff) | (k << 20);
        HEAPU32[1] = hx;
        return (HEAPD64[0] * 5.55111512312578270212e-17 * sign);
    }

}
