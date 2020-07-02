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
  fun encode1(input: ByteSeq, newline: Bool =false): String=>
    let nl:I32 = if newline then 1 else 0 end
    let cstr = @base64_encode[Pointer[U8]](input, nl)
    // Array[U8].from_cpointer(ptr, size)
    String.from_cstring(cstr).clone()

  fun decode1(input: ByteSeq, newline: Bool =false): String=>
    let nl:I32 = if newline then 1 else 0 end
    let cstr = @base64_decode[Pointer[U8]](input, nl)
    // Array[U8].from_cpointer(ptr, size)
    String.from_cstring(cstr).clone()

  // fun encode(input: ByteSeq, newline: Bool =false): String=>
    // let bio_flags_base64_no_nl = 0x100
    // let nl:I32 = if newline then 1 else 0 end
    // var b64 = @BIO_new[Pointer[_BIO]](@BIO_f_base64[Pointer[U8]]())
    
    // if newline then
      // @BIO_set_flags[None](b64, bio_flags_base64_no_nl);
    // end
    
    // let bmem = @BIO_new[Pointer[_BIO]](BIO_s_mem[Pointer[U8]]());
    // @BIO_push(b64, bmem)
    // @BIO_write[None](b64, input, input.size());
    // @BIO_flush[None](b64)

    // let buff = @pony_alloc[Pointer[U8]](@pony_ctx[Pointer[None] iso](), size)

primitive AES128
primitive AES196
primitive AES256
type AESLevel is (AES128 | AES196 | AES256)

primitive ECB
primitive CBC
primitive CFB
primitive OFB
type AESMode is (ECB | CBC | CFB | OFB)

primitive ZERO
primitive PKCS7
primitive ISO
type Padding is (ZERO | PKCS7 | ISO)

primitive AES
  fun encode1(input: ByteSeq, newline: Bool =false): String=>
    
