from io import *
from subprocess import call

with open('bitrix_tasks.txt', 'r', encoding="utf-16") as txt:
    lines = txt.readlines()
    for line in lines:
        pieces = line.split(" ");
        # filter out empty strings
        pieces = [piece for piece in pieces if piece not in set([""])]
        pid = pieces[1]
        print pid
        call(["taskkill", "/pid", pid, "/F"])
