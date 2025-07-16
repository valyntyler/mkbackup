#!/usr/bin/env nu

def main [
  path: string
  --zip (-z) = true
  --name (-n) = true
  --date (-n) = true
  --uid (-u)
  --uid-length (-l) = 6
] {
  let path = $path | path expand
  if not ($path | path exists) {
    error make {
      msg: "Invalid path"
      label: {
        text: $"this path doesn't exist."
        span: (metadata $path).span
      }
    }
  }

  let file = [
    (if $name {$"($path | path basename)"})
    (if $date {$"(date now | format date "%y%m%d%H%M%S")"})
    (if $uid {$"(random chars --length $uid_length)"})
  ]
    | filter {$in != null}
    | str join '-'
    | $in + ".bak"

  if $zip {
    ouch compress ...(glob ($path + "/*")) $file --format zip
  } else {
    cp -r $path $file
  }
}
