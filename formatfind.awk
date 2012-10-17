function ltrim(v) {gsub(/^[ \t]+/, "", v);return v}

BEGIN {
	FS=":"
	maxlen = 0
}

{
	result = $3
	for( i=4; i <= NF; i++ )
		result = result FS $i
	if( length($1) > maxlen )
		maxlen = length($1)

	filenames[NR-1] = $1
	linenums[NR-1] = $2
	foundcode[NR-1] = result
}

END {
	formatting_str = "%" maxlen "s[0;37;40m%6d[0;;m  %s\n"
	for( i=0; i < NR; i++ )
		printf(formatting_str, filenames[i], linenums[i], ltrim(foundcode[i]))
}
