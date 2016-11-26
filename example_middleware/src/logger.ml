let output = ref stdout
let set_output o =
  output := o

let puts message = Printf.fprintf !output message
let debug message = puts message
let info message = puts message
let warn message = puts message
let error message = puts message
