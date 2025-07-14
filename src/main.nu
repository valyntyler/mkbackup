#!/usr/bin/env nu

def main [
  path: string
  --zip (-z) = true
  --length (-l) = 6
] {
  if not ($path | path exists) {
    error make {
      msg: "Invalid path"
      label: {
        text: $"this path doesn't exist."
        span: (metadata $path).span
      }
    }
  }

  let path = $path | path expand
  let uid = random chars --length $length
  ouch compress $path $"($path | path basename)-($uid).bak" --format zip
}
