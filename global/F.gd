class_name F
extends Object

static func format_thousands(n: float) -> String:
	var integer: int = int(n)
	var result: String = ""
	while absi(integer) >= 1000:
		result = " %03d%s" % [(absi(integer) % 1000), result]
		integer /= 1000
	result = "%d%s" % [integer, result]
	
	return result

static func F(n: float) -> String:
	if absf(n) >= 10_000_000:
		return "%s K" % F.format_thousands(n / 1000.0)
	return F.format_thousands(n)
