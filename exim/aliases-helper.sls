#!pydsl

root = __pillar__["auth"]["groups"][__grains__["id"]]["sudo"]
users = __pillar__["auth"]["users"]

lines = ["{0}: {1}".format(n, u["email"]) for n, u in users.items()]
lines.append("root: " + ", ".join(root))

contents = "\n".join(lines)

state('/etc/aliases').file(
    'managed', contents=contents, user="root", group="root", mode=644)
