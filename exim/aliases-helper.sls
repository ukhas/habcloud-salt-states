#!pydsl

users = __pillar__["users"]
root = [u["email"] for u in users.values() if u["sudo"]]
lines = ["{0}: {1}".format(n, u["email"]) for n, u in users.items()]
lines.append("root: " + ", ".join(root))
contents = "\n".join(lines)

state('/etc/aliases') \
    .file('managed', contents=contents,
          user="root", group="root", mode=0o644)
