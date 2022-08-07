package main

import (
	"fmt"
	"sort"
)

type sortString []string

func (s sortString) Less(i, j int) bool {
	return s[i] < s[j]
}

func (s sortString) Len() int {
	return len(s)
}
func (s sortString) Swap(i, j int) {
	s[i], s[j] = s[j], s[i]
}

func main() {
	str1 := []string{"c", "a", "b", "h", "j", "d", "z", "n", "q"}
	sort.Sort(sortString(str1))
	fmt.Println(str1)
}
