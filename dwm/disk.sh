#!/bin/sh

disk(){
	disk_root=$(df -h|awk '{if ($6 == "/") {print}}'|awk '{print "[/]: " $5}')
	disk_home=$(df -h|awk '{if ($6 == "/home") {print}}'|awk '{print "[/home]: " $5}')
	disk_="💾 $disk_root $disk_home"
}
