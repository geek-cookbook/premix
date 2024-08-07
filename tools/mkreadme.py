import sys
import pystache
import ruamel.yaml
import collections


tableHeader = "\n".join([
    "**Parameter** | **Description** | **Default**",
    "--- | --- | ---",
    ""
])

yaml = ruamel.yaml.YAML()

if len(sys.argv) != 5:
    raise ValueError("Invalid parameter length")

template = ""
chart = {}
values = {}

with open(sys.argv[1], 'r') as f:
    template = f.read()
with open(sys.argv[3], 'r') as f:
    chart = yaml.load(f.read())
with open(sys.argv[4], 'r') as f:
    values = yaml.load(f.read())

tableRows = []

def followPath(a, path):
    if len(path) == 0:
        return a
    k = path[0]
    if k == "[]":
        k = 0
    return followPath(a[k], path[1:])

def isDict(val):
    return isinstance(val, collections.OrderedDict) or isinstance(val, ruamel.yaml.comments.CommentedMap)

def isList(val):
    return isinstance(val, list) or isinstance(val, ruamel.yaml.comments.CommentedSeq)

def itr(a, path = []):
    col = {}
    if isDict(a):
        col = a.items()
    elif isList(a):
        col = a
    for z in col:
        key, val = z
        pth = path[:]
        pth.append(key)

        if isDict(val) and len(val) > 0:
            itr(val, pth)
        else:
            v = val
            if isDict(v) and len(v) == 0:
                v = "{}"
            if isList(v) and len(v) == 0:
                v = "[]"

            if isList(v) and len(v) > 0:
                pth.append("[]")
                itr(val[0],pth)
                continue

            if not v:
                v = "nil"
            description = ""
            di = followPath(values, path).ca.items
            c = 0
            if key in di:
                while not di[key][c]:
                    c = c + 1
                    if c == len(di[key]):
                        c = 0
                        break
                if di[key][c]:
                    description = di[key][c]
                    if isList(description):
                        description = description[0]
                    description = description.value.strip().replace("\n", "").replace("#","",1)
            
            e = " | ".join(["`" + '.'.join(pth).replace(".[]","[]") + "`", description, "`" + str(v) + "`"])
            tableRows.append(e)

itr(values)

table = '\n'.join(tableRows)

chart["valuesTable"] = tableHeader + table


output = pystache.render(template, {'Chart': chart})


with open(sys.argv[2], 'w') as f:
    f.write(output)
