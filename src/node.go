package main

import(
  "os"
  "log"
  "os/exec"
)

const VERSION_VAR_NAME = "NODE_VERSION"

func exe() string {
  if os.Getenv(VERSION_VAR_NAME) == "4" {
    return "C:/Progra~2/NodeJS/node4.exe"
  } else {
    return "C:/Progra~1/NodeJS/node5.exe"
  }
}

func args() []string {
  if len(os.Args) > 1 {
    arg1 := os.Args[1]
    if arg1 == "-4" {
      os.Setenv(VERSION_VAR_NAME, "4")
      return os.Args[2:]
    } else if arg1 == "-6" {
      os.Setenv(VERSION_VAR_NAME, "")
      return os.Args[2:]
    } else {
      return os.Args[1:]
    }
  }
  return os.Args[1:]
}

func main() {
  args := args()
  exe := exe()
  cmd := exec.Command(exe, args...)
  cmd.Stdin = os.Stdin
  cmd.Stdout = os.Stdout
  cmd.Stderr = os.Stderr
  err := cmd.Start()
  if err != nil {
    log.Fatal(err)
  }
  cmd.Wait()
}
