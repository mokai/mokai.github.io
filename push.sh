git add -A

if [[ $# = 0 ]]; then
	git commit -m 'update'
elif [[ $# = 1  ]]; then
	git commit -m $1
fi

git push -u origin source



