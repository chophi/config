#!/usr/bin/env python

from struct import pack, unpack
import os
import sys

# /*
#  * File Format
#  *
#  * u32 - magic number
#  * u32 - version
#  * u32 - length of pcre version EXCLUDING nul
#  * char - pcre version string EXCLUDING nul
#  * u32 - number of stems
#  * ** Stems
#  *	u32  - length of stem EXCLUDING nul
#  *	char - stem char array INCLUDING nul
#  * u32 - number of regexs
#  * ** Regexes
#  *	u32  - length of upcoming context INCLUDING nul
#  *	char - char array of the raw context
#  *	u32  - length of the upcoming regex_str
#  *	char - char array of the original regex string including the stem.
#  *	u32  - mode bits for >= SELINUX_COMPILED_FCONTEXT_MODE
#  *	       mode_t for <= SELINUX_COMPILED_FCONTEXT_PCRE_VERS
#  *	s32  - stemid associated with the regex
#  *	u32  - spec has meta characters
#  *	u32  - The specs prefix_len if >= SELINUX_COMPILED_FCONTEXT_PREFIX_LEN
#  *	u32  - data length of the pcre regex
#  *	char - a bufer holding the raw pcre regex info
#  *	u32  - data length of the pcre regex study daya
#  *	char - a buffer holding the raw pcre regex study data
#  */


kFilePath = os.path.expanduser(
    "$OUT/"
    "obj/ETC/file_contexts.bin_intermediates/file_contexts.bin"
)


def readString(f):
    length, = unpack("I", f.read(4))
    retString, = unpack("{0}s".format(length), f.read(length))
    return retString

if len(sys.argv) == 2:
    kFilePath = os.path.expanduser(sys.argv[1])

with open(kFilePath, 'rb') as f:
    magic, version = unpack("II", f.read(8))
    print("magic number: {0:#x}\nversion: {1}".format(magic, version))

    pcreVersionLen, = unpack("I", f.read(4))
    print("pcre version length: {0}".format(pcreVersionLen))

    pcreVersion, = unpack("{0}s".format(pcreVersionLen), f.read(pcreVersionLen))
    print("pcre Versinon: {0}".format(pcreVersion))

    numOfStems, = unpack("I", f.read(4))
    print("number of stems: {0}".format(numOfStems))

    for i in range(numOfStems):
        stemLen, = unpack("I", f.read(4))
        stem, _ = unpack("{0}s{1}s".format(stemLen, 1), f.read(stemLen + 1))
        print("{0:< 2}: {1}".format(i, stem))

    numOfRegexes, = unpack("I", f.read(4))
    print("number of regexes: {0}".format(numOfRegexes))

    for i in range(numOfRegexes):
        rawContext = readString(f)
        print("context: {0}".format(rawContext))

        regex = readString(f)
        print("regex: {0}".format(regex))

        modeBit, = unpack("I", f.read(4))
        print("modeBit: {0}".format(modeBit))

        stemId, = unpack("I", f.read(4))
        print("stemId: {0}".format(stemId))

        specHasMetaChars, = unpack("I", f.read(4))
        print("specHasMetaChars: {0}".format(specHasMetaChars))

        specPrefixLen, = unpack("I", f.read(4))
        print("specPrefixLen: {0}".format(specPrefixLen))

        pcreRegex = readString(f)
        # print("pcreRegex: {0}".format(pcreRegex))

        pcreRegexStudyData = readString(f)
        # print("pcreRegex study data: {0}".format(pcreRegexStudyData))
        # exit(0)

