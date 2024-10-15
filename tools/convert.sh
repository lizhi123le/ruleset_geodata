# 处理文件
list=($(ls ./rules/))
for ((i = 0; i < ${#list[@]}; i++)); do
	mkdir -p ${list[i]}
	# 归类
	# android package
	if [ -n "$(cat ./rules/${list[i]}/${list[i]}.yaml | grep 'PROCESS-NAME,' | grep -v '\.exe' | grep '\.')" ]; then
		cat ./rules/${list[i]}/${list[i]}.yaml | grep 'PROCESS-NAME,' | grep -v '\.exe' | grep '\.' | sed 's/^PROCESS-NAME,//' > ${list[i]}/package.json
	fi
	# process name
	if [ -n "$(cat ./rules/${list[i]}/${list[i]}.yaml | grep 'PROCESS-NAME,' | grep -v '\.')" ]; then
		cat ./rules/${list[i]}/${list[i]}.yaml | grep 'PROCESS-NAME,' | grep -v '\.' | sed 's/^PROCESS-NAME,//' > ${list[i]}/process.json
	fi
	if [ -n "$(cat ./rules/${list[i]}/${list[i]}.yaml | grep 'PROCESS-NAME,' | grep '\.exe')" ]; then
		cat ./rules/${list[i]}/${list[i]}.yaml | grep 'PROCESS-NAME,' | grep '\.exe' | sed 's/^PROCESS-NAME,//' >> ${list[i]}/process.json
	fi
	# domain
 	if [ -n "$(cat ./rules/${list[i]}/${list[i]}.yaml | grep 'DOMAIN,')" ]; then
		cat ./rules/${list[i]}/${list[i]}.yaml | grep 'DOMAIN,' | sed 's/^DOMAIN,//' > ${list[i]}/domain.json
	fi
 	# suffix
	if [ -n "$(cat ./rules/${list[i]}/${list[i]}.yaml | grep 'DOMAIN-SUFFIX,')" ]; then
		cat ./rules/${list[i]}/${list[i]}.yaml | grep 'DOMAIN-SUFFIX,' | sed 's/^DOMAIN-SUFFIX,//' > ${list[i]}/suffix.json
	fi
 	# keyword
	if [ -n "$(cat ./rules/${list[i]}/${list[i]}.yaml | grep 'DOMAIN-KEYWORD,')" ]; then
		cat ./rules/${list[i]}/${list[i]}.yaml | grep 'DOMAIN-KEYWORD,' | sed 's/^DOMAIN-KEYWORD,//' > ${list[i]}/keyword.json
	fi
 	# regex
 	if [ -n "$(cat ./rules/${list[i]}/${list[i]}.yaml | grep 'DOMAIN-REGEX,')" ]; then
		cat ./rules/${list[i]}/${list[i]}.yaml | grep 'DOMAIN-REGEX,' | sed 's/^DOMAIN-REGEX,//' > ${list[i]}/regex.json
	fi
	# ipcidr
	if [ -n "$(cat ./rules/${list[i]}/${list[i]}.yaml | grep 'IP-CIDR')" ]; then
		cat ./rules/${list[i]}/${list[i]}.yaml | grep 'IP-CIDR' | sed -e 's/^IP-CIDR,//' -e 's/^IP-CIDR6,//' > ${list[i]}/ipcidr.json
	fi
	# 转换成 .json 格式
	# android package
	if [ -f "${list[i]}/package.json" ]; then
		sed -i 's/.*/        "&",/' ${list[i]}/package.json
		sed -i '1s/^/      "package_name": [\n/' ${list[i]}/package.json
		sed -i '$s/,$/\n      ],/' ${list[i]}/package.json
	fi
	# process name
	if [ -f "${list[i]}/process.json" ]; then
		sed -i 's/.*/        "&",/' ${list[i]}/process.json
		sed -i '1s/^/      "process_name": [\n/' ${list[i]}/process.json
		sed -i '$s/,$/\n      ],/' ${list[i]}/process.json
	fi
	# domain
	if [ -f "${list[i]}/domain.json" ]; then
		sed -i 's/.*/        "&",/' ${list[i]}/domain.json
		sed -i '1s/^/      "domain": [\n/' ${list[i]}/domain.json
		sed -i '$s/,$/\n      ],/' ${list[i]}/domain.json
	fi
 	# suffix
	if [ -f "${list[i]}/suffix.json" ]; then
		sed -i 's/.*/        "&",/' ${list[i]}/suffix.json
		sed -i '1s/^/      "domain_suffix": [\n/' ${list[i]}/suffix.json
		sed -i '$s/,$/\n      ],/' ${list[i]}/suffix.json
	fi
 	# keyword
	if [ -f "${list[i]}/keyword.json" ]; then
		sed -i 's/.*/        "&",/' ${list[i]}/keyword.json
		sed -i '1s/^/      "domain_keyword": [\n/' ${list[i]}/keyword.json
		sed -i '$s/,$/\n      ],/' ${list[i]}/keyword.json
	fi
 	# regex
 	if [ -f "${list[i]}/regex.json" ]; then
		sed -i 's/.*/        "&",/' ${list[i]}/regex.json
		sed -i '1s/^/      "domain_regex": [\n/' ${list[i]}/regex.json
		sed -i '$s/,$/\n      ],/' ${list[i]}/regex.json
	fi
	# ipcidr
	if [ -f "${list[i]}/ipcidr.json" ]; then
		sed -i 's/.*/        "&",/' ${list[i]}/ipcidr.json
		sed -i '1s/^/      "ip_cidr": [\n/' ${list[i]}/ipcidr.json
		sed -i '$s/,$/\n      ],/' ${list[i]}/ipcidr.json
	fi
	# 合并文件
	if [ -f "${list[i]}/package.json" -a -f "${list[i]}/process.json" ]; then
		mv -f ${list[i]}/package.json ${list[i]}.json
		sed -i '$ s/,$/\n    },\n    {/' ${list[i]}.json
		cat ${list[i]}/process.json >> ${list[i]}.json
		rm -f ${list[i]}/process.json
	elif [ -f "${list[i]}/package.json" ]; then
		mv -f ${list[i]}/package.json ${list[i]}.json
	elif [ -f "${list[i]}/process.json" ]; then
		mv -f ${list[i]}/process.json ${list[i]}.json
	fi

	if [ "$(ls ${list[i]})" = "" ]; then
		sed -i '1s/^/{\n  "version": 2,\n  "rules": [\n    {\n/' ${list[i]}.json
	elif [ -f "${list[i]}.json" ]; then
		sed -i '1s/^/{\n  "version": 2,\n  "rules": [\n    {\n/' ${list[i]}.json
		sed -i '$ s/,$/\n    },\n    {/' ${list[i]}.json
		cat ${list[i]}/* >> ${list[i]}.json
	else
		cat ${list[i]}/* >> ${list[i]}.json
		sed -i '1s/^/{\n  "version": 2,\n  "rules": [\n    {\n/' ${list[i]}.json
	fi
	sed -i '$ s/,$/\n    }\n  ]\n}/' ${list[i]}.json
	rm -rf ${list[i]}

 	# 编译成 .srs 格式
	./sing-box rule-set compile --output ${list[i]}.srs ${list[i]}.json
done
