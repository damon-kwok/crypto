use "path:/usr/local/opt/libressl/lib" if osx
use "lib:crypto"
use "lib:ssl"
// use "lib:encoding"
// use "lib:ponyc"
// use "lib:ponyrt"

use "format"

primitive _BIO
primitive _BUFMEM

class Encoding
  var _digest_size: USize
  let _ctx: Pointer[_EVPCTX]
  var _hash: (Array[U8] val | None) = None
  
  new base64() =>
    """
    Use the MD5 algorithm to calculate the hash.
    """
    _digest_size = 0
    ifdef "openssl_1.1.x" then
      _ctx = @EVP_ENCODE_CTX_new[Pointer[_EVPCTX]]()
    else
      _ctx = @EVP_ENCODE_CTX_create[Pointer[_EVPCTX]]()
    end
    @EVP_EncodeInit[None](_ctx)

  fun ref append(input: ByteSeq) ? =>
    """
    Update the Digest object with input. Throw an error if final() has been
    called.
    """
    if _hash isnt None then error end
    _digest_size = _digest_size + input.size()
    var len: I32 = 0
    @EVP_EncodeUpdate[I32](_ctx, addressof len, input.cpointer(), input.size())

  fun ref final(): Array[U8] val =>
    """
    Return the digest of the strings passed to the append() method.
    """
    match _hash
    | let h: Array[U8] val => h
    else
      let size = _digest_size*2
      let digest =
        recover String.from_cpointer(
          @pony_alloc[Pointer[U8]](@pony_ctx[Pointer[None] iso](), size), size)
        end
      var len: I32 = 0
      @EVP_EncodeFinal[None](_ctx, digest.cpointer(), addressof len)
      ifdef "openssl_1.1.x" then
        @EVP_ENCODE_CTX_free[None](_ctx)
      else
        @EVP_ENCODE_CTX_cleanup[None](_ctx)
      end
      let h = (consume digest).array()
      _hash = h
      h
    end
    
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
    // var bptr = Pointer[_BUFMEM]
    
    // if newline then
      // @BIO_set_flags[None](b64, bio_flags_base64_no_nl);
    // end
    // let bmem = BIO_new[Pointer[_BIO]](BIO_s_mem[Pointer[U8]]());
    // @BIO_push[None](b64, bmem);
    // @BIO_write[None](b64, input, input.size());
    // @BIO_flush[None](b64);
    // @BIO_get_mem_ptr[None](b64, addressof bptr);
    // let nio_noclose = 0x00
    // @BIO_set_close[None](b64, bio_noclose);

    // let buff = @pony_alloc[Pointer[U8]](@pony_ctx[Pointer[None] iso](), size)
    // @memcpy[None](buff, )

  // fun encode(input: ByteSeq, newline: Bool =false): String=>
    // recover
      // let size: USize = 16
      // let digest =
        // @pony_alloc[Pointer[U8]](@pony_ctx[Pointer[None] iso](), size)
      // @MD4[Pointer[U8]](input.cpointer(), input.size(), digest)
      // Array[U8].from_cpointer(digest, size)
    // end
    
/*
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
    
*/
