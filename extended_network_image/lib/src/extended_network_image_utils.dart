import 'dart:convert';
import 'package:crypto/crypto.dart';

const String CacheImageFolderName = "cacheimage";

class ExtendedNetworkImageUtils {}

String toMd5(String str) => md5.convert(utf8.encode(str)).toString();
