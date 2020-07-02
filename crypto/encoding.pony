use "path:/usr/local/opt/libressl/lib" if osx
use "lib:crypto"
use "lib:ssl"
use "lib:encoding"
// use "lib:ponyc"
// use "lib:ponyrt"

use "format"

primitive _BIO
primitive _BUFMEM
  
primitive Base64
  fun encode(input: ByteSeq, newline: Bool =false): String=>
    let nl:I32 = if newline then 1 else 0 end
    let cstr = @base64_encode[Pointer[U8]](input, nl)
    // Array[U8].from_cpointer(ptr, size)
    String.from_cstring(cstr).clone()

  fun decode(input: ByteSeq, newline: Bool =false): String=>
    let nl:I32 = if newline then 1 else 0 end
    let cstr = @base64_decode[Pointer[U8]](input, nl)
    // Array[U8].from_cpointer(ptr, size)
    String.from_cstring(cstr).clone()
