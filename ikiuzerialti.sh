#!/bin/bash
#Pardus Corporate 2 sürümünün 32 bit devel deposunu 64 bite çevirmek için gerekli işlemlerin yapılmasını sağlamak için yazılmış bir betiktir.
#Yakın zamanda fezaya bayrak dikmesi planlanmaktadır.

#fix for glibc
echo "glibc x86-64 için uygun hale getiriliyor"
sed 's/-march=i686/-march=x86-64/g' $source/devel/system/base/glibc/actions.py > $destination/system/base/glibc/actions.py
sed -e 's/<Path fileType="library">\/lib<\/Path>/ <Path fileType="library">\/lib<\/Path>\n             <Path fileType="library">\/lib64<\/Path>/g' -e 's/<Path fileType="library">\/usr\/lib\/<\/Path>/ <Path fileType="library">\/usr\/lib\/<\/Path>\n             <Path fileType="library">\/usr\/lib64\/<\/Path>/g' $source/devel/system/base/glibc/pspec.xml > $destination/system/base/glibc/pspec.xml

#fix for python
echo "pytho x86-64 için uygun hale getiriliyor"
sed 's/--enable-unicode=ucs4/--enable-unicode=ucs4 \\\n                         --enable-universalsdk \\\n                         --with-universal-archs=64-bit /g' $source/devel/system/base/python/actions.py > $destination/system/base/python/actions.py

#fix for perl
echo "perl x86-64 için uygun hale getiriliyor"
sed 's/i686/x86_64/g' $source/devel/system/base/perl/actions.py > $destination/system/base/perl/actions.py

#fix for baselayout
echo "baselayout x86-64 için uygun hale getiriliyor"
sed 's/<Path fileType="library" permanent="true">\/lib<\/Path>/<Path fileType="library" permanent="true">\/lib<\/Path>\n            <Path fileType="library" permanent="true">\/lib64<\/Path>/' $source/devel/system/base/baselayout/pspec.xml > $destination/system/base/baselayout/pspec.xml
sed 's/pisitools\.dosym("share\/man", "\/usr\/local\/man")/pisitools\.dosym("share\/man", "\/usr\/local\/man")\n    pisitools\.dosym("lib", "lib64")\n    shelltools\.cd("%s\/usr" %get\.installDIR())\n    shelltools\.system("ln -s lib lib64")/' $source/devel/system/base/baselayout/actions.py > $destination/system/base/baselayout/actions.py

#fix for gcc
echo "gcc x86-64 için uygun hale getiriliyor"
sed -e 's/--enable-ssp /--enable-ssp \\\n                       --enable-long-long /g' -e 's/-march=i686/-march=x86-64/g' -e 's/\/usr\/lib\/libiberty\.a/\/usr\/lib64\/libiberty\.a/' $source/devel/system/devel/gcc/actions.py > $destination/system/devel/gcc/actions.py
sed -e 's/<Path fileType="library">\/usr\/lib<\/Path>/ <Path fileType="library">\/usr\/lib<\/Path>\n             <Path fileType="library">\/usr\/lib64<\/Path>/' -e 's/\/usr\/lib\//\/usr\/lib64\//'  $source/devel/system/devel/gcc/pspec.xml > $destination/system/devel/gcc/pspec.xml

#fix for klibc
echo "klibc x86-64 için uygun hale getiriliyor"
grep -v KLIBCARCH $source/devel/system/devel/klibc/actions.py > $destination/system/devel/klibc/actions.py

#fix for gmp
echo "gmp x86-64 için uygun hale getiriliyor"
grep -v 'enable-fat' $source/devel/system/devel/gmp/actions.py > $destination/system/devel/gmp/actions.py

#fix for valgrind
echo "valgrind x86-64 için uygun hale getiriliyor"
sed 's/--with-x/--with-x \\\n                         --enable-only64bit/g' $source/devel/programming/profiler/valgrind/actions.py > $destination/programming/profiler/valgrind/actions.py

#fix for ncompress
echo "ncompress x86-64 için uygun hale getiriliyor"
sed 's/shelltools\.move("Makefile\.def", "Makefile")/shelltools\.move("Makefile\.def", "Makefile") \n    pisitools\.dosed("Makefile","options= ","options= \$(CFLAGS) -DNOFUNCDEF -DUTIME_H \$(LDFLAGS) ")/g' $source/devel/system/base/ncompress/actions.py > $destination/system/base/ncompress/actions.py

#fix for lame
echo "lame x86-64 için uygun hale getiriliyor"
sed -e 's/shelltools\.makedirs("libmp3lame\/i386\/\.libs")/shelltools\.makedirs("libmp3lame\/%s\/\.libs" %(get\.HOST()))/g' -e 's/j1/j4/g' $source/devel/multimedia/sound/lame/actions.py > $destination/multimedia/sound/lame/actions.py

#fix for ffmpeg
echo "ffmpeg x86-64 için uygun hale getiriliyor"
grep -v i686 $source/devel/multimedia/video/ffmpeg/actions.py|grep -v enable-vaapi |sed 's/                            --prefix=\/usr/    autotools\.rawConfigure("--prefix=\/usr/g' > $destination/multimedia/video/ffmpeg/actions.py

#fix for sdl-gfx
echo "sdl-gfx x86-64 için uygun hale getiriliyor"
sed 's/--enable-mmx/--disable-mmx/g' $source/devel/multimedia/library/sdl-gfx/actions.py > $destination/multimedia/library/sdl-gfx/actions.py

#fix for p7zip·
echo "p7zip x86-64 için uygun hale getiriliyor"
sed -e 's/from pisi\.actionsapi import pisitools/from pisi\.actionsapi import pisitools\nfrom pisi\.actionsapi import shelltools/g' -e 's/def build():/def build():\n    shelltools.copy("makefile\.linux_amd64", "makefile\.machine")/g' $source/devel/util/archive/p7zip/actions.py > $destination/util/archive/p7zip/actions.py

#fix for nspr
echo "nspr x86-64 için uygun hale getiriliyor"
sed 's/--prefix=\/usr/--prefix=\/usr \\\n                       --enable-64bit/g' $source/devel/network/library/nspr/actions.py > $destination/network/library/nspr/actions.py

#fix for nss
echo "nss x86-64 için uygun hale getiriliyor"
sed 's/def build():/def build(): \n    shelltools\.export("USE_64","1")/g' $source/devel/network/library/nss/actions.py > $destination/network/library/nss/actions.py

#fix for lapack
echo "lapack x86-64 için uygun hale getiriliyor."
sed 's/pisitools\.dosed("make.inc", "-O2", "%s -fPIC -funroll-all-loops" % get.CFLAGS())/pisitools.dosed("make.inc", "-O2", "%s -fPIC -m64 -funroll-all-loops" % get.CFLAGS())\n    pisitools\.dosed("make.inc", "NOOPT    =", "NOOPT    =-m64 -fPIC ")/g' $source/devel/science/library/lapack/actions.py > $destination/science/library/lapack/actions.py

#fix for imlib2
echo "imlib2 x86-64 için uygun hale getiriliyor."
sed 's/--disable-amd64/--enable-amd64/g' $source/devel/multimedia/library/imlib2/actions.py > $destination/multimedia/library/imlib2/actions.py

#fix for libsdl
echo "libsdl x86-64 için uygun hale getiriliyor."
sed 's/--enable-nasm/--disable-nasm/g' $source/devel/multimedia/library/libsdl/actions.py > $destination/multimedia/library/libsdl/actions.py

#fix for atlas
echo "atlas x86-64 için uygun hale getiriliyor."
sed 's/-b 32/-b 64/g' $source/devel/multimedia/library/atlas/actions.py > $destination/multimedia/library/atlas/actions.py

#fix for qca
echo "qca x86-64 için uygun hale getiriliyor."
sed 's/get\.CXXFLAGS()/get\.CXXFLAGS() + " -fPIC "/g' $source/devel/programming/library/qca/actions.py > $destination/programming/library/qca/actions.py

#fix for libstdc++
echo "libstdc++ x86-64 için uygun hale getiriliyor."
sed 's/-mcpu=i686/-mcpu=x86-64/g' $source/devel/programming/library/libstdc++/actions.py > $destination/programming/library/libstdc++/actions.py

#fix for metis
echo "metis x86-64 için uygun hale getiriliyor."
sed 's/WorkDir="metis-4\.0/WorkDir="metis-4.0"\n\ndef setup():\n    pisitools.dosed("Makefile\.in", "COPTIONS = ",  "COPTIONS = -fPIC")/g' $source/devel/programming/library/metis/actions.py > $destination/programming/library/metis/actions.py

#fix for spidermonkey
echo "spidermonkey x86-64 için uygun hale getiriliyor."
sed -e 's/\/usr\/lib\/libjs\.a/\/usr\/lib64\/libjs\.a/g' -e 's/"\/usr\/lib\/libjs\.so", "libjs\.so\.1"/"\/usr\/lib64\/libjs\.so", "libjs\.so\.1"/g' -e 's/"\/usr\/lib\/libjs\.so\.1", "\/usr\/lib\/libjs\.so"/"\/usr\/lib64\/libjs\.so\.1", "\/usr\/lib\/libjs\.so"/g' $source/devel/programming/library/spidermonkey/actions.py > $destination/programming/library/spidermonkey/actions.py
sed 's/<Path fileType="library">\/usr\/lib<\/Path>/ <Path fileType="library">\/usr\/lib<\/Path> \n             <Path fileType="library">\/usr\/lib64<\/Path>/g' $source/devel/programming/library/spidermonkey/pspec.xml > $destination/programming/library/spidermonkey/pspec.xml

#fix for perlconsole
echo "perlconsole x86-64 için uygun hale getiriliyor."
sed 's/i686/x86_64/g' $source/devel/programming/language/perl/perlconsole/actions.py > $destination/programming/language/perl/perlconsole/actions.py

#fix for git
echo "git x86-64 için uygun hale getiriliyor."
sed 's/i686/x86_64/g' $source/devel/programming/vcs/git/actions.py > $destination/programming/vcs/git/actions.py

#fix for subversion
echo "subversion x86_64 için uygun hale getiriliyor."
sed 's/i686/x86_64/' $source/devel/programming/vcs/subversion/actions.py > $destination/programming/vcs/subversion/actions.py
sed 's/i686/x86_64/' $source/devel/programming/vcs/subversion/pspec.xml > $destination/programming/vcs/subversion/pspec.xml

#fix for pygame
echo "pygame x86-64 için uygun hale getiriliyor."
sed 's/i686/x86_64/g' $source/devel/programming/language/python/pygame/actions.py > $destination/programming/language/python/pygame/actions.py

#fix for dev86
echo "dev86 x86-64 için uygun hale getiriliyor."
sed 's/def build():/def setup():\n    pisitools.dosed("makefile.in", "alt-libs elksemu", "alt-libs")\n    pisitools.dosed("makefile.in", "install-lib install-emu", "install-lib")\n\ndef build():/' $source/devel/programming/tool/dev86/actions.py > $destination/programming/tool/dev86/actions.py

#fix for imagemagick
echo "imagemagick x86-64 için uygun hale getiriliyor"
sed 's/i686/x86_64/g' $source/devel/multimedia/graphics/imagemagick/actions.py > $destination/multimedia/graphics/imagemagick/actions.py

#fix for libx86
echo "libx86 x86-64 için uygun hale getiriliyor."
sed 's/make()/make("BACKEND=x86emu")/g' $source/devel/hardware/library/libx86/actions.py > $destination/hardware/library/libx86/actions.py

#fix for perl-Digest-HMAC
echo "perl-Digest-HMAC x86-64 için uygun hale getiriliyor"
sed 's/i686/x86_64/g' $source/devel/programming/language/perl/perl-Digest-HMAC/actions.py > $destination/programming/language/perl/perl-Digest-HMAC/actions.py

#fix for perl-Carp-Clan
echo "perl-Carp-Clan x86-64 için uygun hale getiriliyor"
sed 's/i686/x86_64/g' $source/devel/programming/language/perl/perl-Carp-Clan/actions.py > $destination/programming/language/perl/perl-Carp-Clan/actions.py

#fix for perl-Crypt-PasswdMD5
echo "perl-Crypt-PasswdMD5 x86-64 için uygun hale getiriliyor"
sed 's/i686/x86_64/g' $source/devel/programming/language/perl/perl-Crypt-PasswdMD5/actions.py > $destination/programming/language/perl/perl-Crypt-PasswdMD5/actions.py

#fix for perl-Convert-ASN1
echo "perl-Convert-ASN1 x86-64 için uygun hale getiriliyor"
sed 's/i686/x86_64/g' $source/devel/programming/language/perl/perl-Convert-ASN1/actions.py > $destination/programming/language/perl/perl-Convert-ASN1/actions.py

#fix for perl-Crypt-Simple
echo "perl-Crypt-Simple x86-64 için uygun hale getiriliyor"
sed 's/i686/x86_64/g' $source/devel/programming/language/perl/perl-Crypt-Simple/actions.py > $destination/programming/language/perl/perl-Crypt-Simple/actions.py

#fix for perl-Crypt-SmbHash
echo "perl-Crypt-SmbHash x86-64 için uygun hale getiriliyor"
sed 's/i686/x86_64/g' $source/devel/programming/language/perl/perl-Crypt-SmbHash/actions.py > $destination/programming/language/perl/perl-Crypt-SmbHash/actions.py

#fix for perl-Date-Manip
echo "perl-Date-Manip x86-64 için uygun hale getiriliyor"
sed 's/i686/x86_64/g' $source/devel/programming/language/perl/perl-Date-Manip/actions.py > $destination/programming/language/perl/perl-Date-Manip/actions.py

#fix for perl-Date-Calc
echo "perl-Date-Calc x86-64 için uygun hale getiriliyor"
sed 's/i686/x86_64/g' $source/devel/programming/language/perl/perl-Date-Calc/actions.py > $destination/programming/language/perl/perl-Date-Calc/actions.py

#fix for perl-Email-Abstract
echo "perl-Email-Abstract x86-64 için uygun hale getiriliyor"
sed 's/i686/x86_64/g' $source/devel/programming/language/perl/perl-Email-Abstract/actions.py > $destination/programming/language/perl/perl-Email-Abstract/actions.py

#fix for perl-Email-Address
echo "perl-Email-Address x86-64 için uygun hale getiriliyor"
sed 's/i686/x86_64/g' $source/devel/programming/language/perl/perl-Email-Address/actions.py > $destination/programming/language/perl/perl-Email-Address/actions.py

#fix for perl-Email-Date-Format
echo "perl-Email-Date-Format x86-64 için uygun hale getiriliyor"
sed 's/i686/x86_64/g' $source/devel/programming/language/perl/perl-Email-Date-Format/actions.py > $destination/programming/language/perl/perl-Email-Date-Format/actions.py

#fix for perl-Email-Date
echo "perl-Email-Date x86-64 için uygun hale getiriliyor"
sed 's/i686/x86_64/g' $source/devel/programming/language/perl/perl-Email-Date/actions.py > $destination/programming/language/perl/perl-Email-Date/actions.py

#fix for perl-Email-MessageID
echo "perl-Email-MessageID x86-64 için uygun hale getiriliyor"
sed 's/i686/x86_64/g' $source/devel/programming/language/perl/perl-Email-MessageID/actions.py > $destination/programming/language/perl/perl-Email-MessageID/actions.py

#fix for pam
echo "pam x86-64 için uygun hale getiriliyor"
sed 's/<Path fileType="library">\/usr\/lib<\/Path>/ <Path fileType="library">\/usr\/lib<\/Path> \n             <Path fileType="library">\/usr\/lib64<\/Path>/g' $source/devel/system/base/pam/pspec.xml > $destination/system/base/pam/pspec.xml

#fix for binutils
echo "binutils x86-64 için uygun hale getiriliyor."
sed -e  's/\/usr\/lib\/libiberty\.a/\/usr\/lib64\/libiberty\.a/g' -e 's/"\/usr\/lib", "libiberty\/libiberty\.a"/"\/usr\/lib64", "libiberty\/libiberty\.a"/g' $source/devel/system/devel/binutils/actions.py > $destination/system/devel/binutils/actions.py
sed 's/<Path fileType="library">\/usr\/lib<\/Path>/ <Path fileType="library">\/usr\/lib<\/Path>\n             <Path fileType="library">\/usr\/lib64<\/Path>/g' $source/devel/system/devel/binutils/pspec.xml > $destination/system/devel/binutils/pspec.xml

#fix for iceream
echo "iceream x86-64 için uygun hale getiriliyor."
sed 's/for chost in \["", "i686-pc-linux-gnu-"\]:/host= get\.HOST()+"-"\n    for chost in \["", host\]:/g' $source/devel/system/devel/icecream/actions.py > $destination/system/devel/icecream/actions.py


#fix for module-fglrx
echo "module-fglrx x86-64 için uygun hale getiriliyor"
sed -e 's/arch\/x86\/usr\/lib/arch\/x86_64\/usr\/lib64/' -e 's/arch\/x86\/usr\/X11R6\/lib/arch\/x86_64\/usr\/X11R6\/lib64/'  -e 's/arch\/x86\/usr/arch\/x86_64\/usr/' -e 's/arch\/x86\/lib\//arch\/x86_64\/lib\//' $source/devel/kernel/default/drivers/module-fglrx/actions.py > $destination/kernel/default/drivers/module-fglrx/actions.py

#fix for djbftt
#echo "djbftt x86-64 için uygun hale getiriliyor"
#sed -e 's/' /corporate2/devel/science/library/djbfft/actions.py > /corporate2/devel-x86_64/science/library/djbfft/actions.py

#fix for foomatic-db-engine
echo "foomatic-db-engine x86-64 için uygun hale getiriliyor"
sed 's/i686/x86_64/g' $source/devel/hardware/printer/foomatic-db-engine/actions.py > $destination/hardware/printer/foomatic-db-engine/actions.py

#fix for mpg123
echo "mpg123 x86-64 için uygun hale getiriliyor"
sed 's/--with-cpu=sse/--with-cpu=x86-64/' $source/devel/multimedia/sound/mpg123/actions.py > $destination/multimedia/sound/mpg123/actions.py

#fix for squashfs-tools
echo "squashfs-tools x86-64 için uygun hale getiriliyor"
sed 's/def build():/def setup():\n    for f in \["LZMA\/C\/LzFind\.o", "LZMA\/C\/LzmaDec\.o", "LZMA\/C\/LzmaEnc\.o", "LZMA\/C\/LzmaLib\.o", "LZMA\/C\/Alloc\.o"\]:\n        shelltools\.unlink(f)\n\ndef build():/g' $source/devel/hardware/disk/squashfs-tools/actions.py > $destination/hardware/disk/squashfs-tools/actions.py

#fix for obexftp
echo "obexftp x86-64 için uygun hale getiriliyor"
sed 's/i686/x86_64/g' $source/devel/hardware/library/obexftp/actions.py > $destination/hardware/library/obexftp/actions.py

#fix for johntheripper
echo "johntheripper x86-64 için uygun hale getiriliyor"
sed 's/linux-x86-sse2/linux-x86-64/s' $source/devel/util/crypt/johntheripper/actions.py > $destination/util/crypt/johntheripper/actions.py

###### patches ######

#no need a fix for comar

#fix for pisi
echo "pisi x86-64 için uygun hale getiriliyor"
cp files/corporate-x86_64.patch $destination/system/base/pisi/files/
sed 's/<\/Patches>/    <Patch>corporate-x86_64\.patch<\/Patch>\n        <\/Patches>/g' $source/devel/system/base/comar/pspec.xml > $destination/system/base/comar/pspec.xml

#fix for kernel
echo "kernel x86-64 için uygun hale getiriliyor"
cp files/kernel-config-64bit.patch $destination/kernel/default/kernel/files/pardus
cp files/fsam74XX-select_check_signature.patch $destination/kernel/default/kernel/files/pardus

sed 's/<Patch>pardus\/kernel-config\.patch<\/Patch>/<Patch level="1">kernel-config-64bit\.patch<\/Patch>/'  $source/kernel/default/kernel/pspec.xml > $destination/kernel/default/kernel/pspec.xml

sed 's/<Patch level="1">pardus\/linux-2\.6-add-fujitsu-amilo-74xx-rfkill-drivers\.patch<\/Patch>/<Patch level="1">pardus\/linux-2\.6-add-fujitsu-amilo-74xx-rfkill-drivers\.patch<\/Patch>\n\n            <\!-- Patch for Pardus64 to FSAM74XX devices, adding "select check_signature" -->\n            <Patch level="1">pardus\/fsam74XX-select_check_signature\.patch<\/Patch>\n/' $source/kernel/default/kernel/pspec.xml > $destination/kernel/default/kernel/pspec.xml

#fix for firebird
echo "firebird x86-64 için uygun hale getiriliyor"
cp files/firebird-mcpu-to-mtune.patch $destination/server/database/firebird/files/
sed 's/pisitools\.remove("\/usr\/lib\//pisitools\.remove("\/usr\/lib64\//g' $source/devel/server/database/firebird/actions.py > $destination/server/database/firebird/actions.py

#fix for libnut
echo "libnut x86-64 için uygun hale getiriliyor"
cp files/libnut_fPIC.patch $destination/multimedia/converter/libnut/files/
sed 's/        <\/Patches>/            <Patch level="1">libnut_fPIC\.patch<\/Patch>\n        <\/Patches>/g' $source/devel/multimedia/converter/libnut/pspec.xml > $destination/multimedia/converter/libnut/pspec.xml

#fix for check
echo "check x86-64 için uygun hale getiriliyor"
cp files/check-0.9.6-64bitsafe.patch $destination/programming/library/check/files/
sed 's/        <\/Patches>/            <Patch level="1">check-0\.9\.6-64bitsafe\.patch<\/Patch>\n        <\/Patches>/g' $source/devel/programming/library/check/pspec.xml > $destination/programming/library/check/pspec.xml

#fix for cvs
echo "cvs x86-64 için uygun hale getiriliyor"
cp files/x86_64.patch $destination/programming/vcs/cvs/files/
sed 's/        <\/Patches>/            <Patch level="1">x86_64\.patch<\/Patch>\n        <\/Patches>/g' $source/devel/programming/vcs/cvs/pspec.xml > $destination/programming/vcs/cvs/pspec.xml

#fix for pilot-link
echo "pilot-link x86-64 için uygun hale getiriliyor"
cp files/pilot-link-0.12.3-int_types.patch $destination/hardware/mobile/pilot-link/files/
sed 's/<Patch level="1">pilot-link-0\.12\.3-md5\.patch<\/Patch>/<!--Patch level="1">pilot-link-0\.12\.3-md5\.patch<\/Patch-->\n            <Patch level="1">pilot-link-0\.12\.3-int_types\.patch<\/Patch>/g' $source/devel/hardware/mobile/pilot-link/pspec.xml > $destination/hardware/mobile/pilot-link/pspec.xml
sed 's/i686-linux-thread-multi/x86_64-linux-thread-multi/g' $source/devel/hardware/mobile/pilot-link/actions.py > $destination/hardware/mobile/pilot-link/actions.py

#fix for module-syntekdriver
echo "module-syntekdriver x86-64 için uygun hale getiriliyor"
cp files/v4l_compat_ioctl32.patch $destination/kernel/default/drivers/module-syntekdriver/files/
sed 's/        <\/Patches>/            <Patch level="1">v4l_compat_ioctl32\.patch<\/Patch>\n        <\/Patches>/g' $source/devel/kernel/default/drivers/module-syntekdriver/pspec.xml > $destination/kernel/default/drivers/module-syntekdriver/pspec.xml

#fix for module-r5u870
echo "module-r5u870 x86-64 için uygun hale getiriliyor"
cp files/0001-Fix-bug-when-compiling-on-2.6.29-or-greater-64bit-ke.patch $destination/kernel/default/drivers/module-r5u870/files/
sed 's/        <\/Patches>/            <Patch level="1">0001-Fix-bug-when-compiling-on-2\.6\.29-or-greater-64bit-ke\.patch<\/Patch>\n        <\/Patches>/g' $source/devel/kernel/default/drivers/module-r5u870/pspec.xml > $destination/kernel/default/drivers/module-r5u870/pspec.xml

#fix for aggdraw
echo "aggdraw x86-64 için uygun hale getiriliyor"
cp files/aggdraw-x86-64.patch $destination/programming/language/python/aggdraw/files/
sed 's/        <\/Patches>/            <Patch>aggdraw-x86-64\.patch<\/Patch>\n        <\/Patches>/g' $source/devel/programming/language/python/aggdraw/pspec.xml > $destination/programming/language/python/aggdraw/pspec.xml

###### source/devel ######

#fix for module-fglrx
echo "module-fglrx x86-64 için uygun hale getiriliyor"
sed 's/<Archive sha1sum="e987c1540f7d0141cfe9145442367d1e88314cc4" type="binary">http:\/\/a248\.e\.akamai.net\/f\/674\/9206\/0\/www2\.ati\.com\/drivers\/linux\/ati-driver-installer-9-11-x86\.x86_64\.run</Archive>/<Archive sha1sum="c213b1ccd4130fbbb7e0ef828c32214e55fc15ba" type="binary">http://a248.e.akamai.net/f/674/9206/0/www2.ati.com/drivers/linux/ati-driver-installer-9-12-x86.x86_64.run</Archive>/' $source/devel/kernel/default/drivers/module-fglrx/pspec.xml > $destination/kernel/default/drivers/module-fglrx/pspec.xml
sed 's/arch\/x86/arch/x86-64/' $source/devel/kernel/default/drivers/module-fglrx/actions.py > $destination/kernel/default/drivers/module-fglrx/actions.py

#fix for module-broadcom-wl
echo "module-broadcom-wl x86-64 için uygun hale getiriliyor"
sed 's/<Archive sha1sum="80b413d810cbb3dbc8e2e7dfff9364656d042198" type="targz">http:\/\/www\.broadcom\.com\/docs\/linux_sta\/hybrid-portsrc-x86_32-v5\.10\.91\.9\.3\.tar\.gz<\/Archive>/<Archive sha1sum="a426712617bf3f1c03a0012e087a4735b527c53c" type="targz">http:\/\/www\.broadcom\.com\/docs\/linux_sta\/hybrid-portsrc-x86_64-v5\.10\.91\.9\.3\.tar\.gz<\/Archive>/' $source/devel/kernel/default/drivers/module-broadcom-wl/pspec.xml > $destination/kernel/default/drivers/module-broadcom-wl/pspec.xml

#fix for module-nvidia-current
echo "module-nvidia-current x86-64 için uygun hale getiriliyor"
sed -e 's/NVIDIA-Linux-x86-/NVIDIA-Linux-x86_64-/' -e 's/usr\/lib\/vdpau\/libvdpau_trace\.so/usr\/lib\/libvdpau_trace\.so/' $source/devel/kernel/default/drivers/module-nvidia-current/actions.py > $destination/kernel/default/drivers/module-nvidia-current/actions.py
sed -e 's/<Archive sha1sum="6e5bd89fbd41358e2d19a80c87aab73dee983523" type="tarbz2">http:\/\/cekirdek.pardus.org.tr\/~fatih\/dist\/nvidia\/NVIDIA-Linux-x86-190.53.tar.bz2<\/Archive>/<Archive sha1sum="ea021fe181b2d86d97ee886dd2176c731cd5a565" type="tarbz2">http:\/\/members.comu.edu.tr\/nyucel\/source\/devel\/NVIDIA-Linux-x86_64-190.42.tar.bz2<\/Archive>/g' $source/kernel/default/drivers/module-nvidia-current/pspec.xml > $destination/kernel/default/drivers/module-nvidia-current/pspec.xml

#fix for flashplugin
echo "flashplugin x86-64 için uygun hale getiriliyor"
sed 's/<Archive sha1sum="099f486bbc3e8e16afd09e2fbf963b6e531a6846" type="targz">http:\/\/fpdownload\.macromedia\.com\/get\/flashplayer\/current\/install_flash_player_10_linux\.tar\.gz<\/Archive>/<Archive sha1sum="4a4f2e4dcf9857b83b7e0bac3e7476e2868cc027" type="targz">http:\/\/download\.macromedia\.com\/pub\/labs\/flashplayer10\/libflashplayer-10\.0\.42\.34\.linux-x86_64\.so\.tar\.gz<\/Archive>/' $source/devel/network/plugin/flashplugin/pspec.xml > $destination/network/plugin/flashplugin/pspec.xml

#fix for sun-jdk
echo "sun-jdk x86-64 için uygun hale getiriliyor"
sed -e 's/linux-i586\.bin/linux-amd64\.bin/' -e 's/plugin\/i386\/ns7/plugin\/amd64\/ns7/' $source/devel/programming/language/java/sun-java/actions.py > $destination/programming/language/java/sun-java/actions.py
sed 's/<Archive sha1sum="d09eea7fb48cd662abafbf490b0cb8340936095a" type="binary">http:\/\/download\.java\.net\/dlj\/binaries\/jdk-6u15-dlj-linux-i586\.bin<\/Archive>/<Archive sha1sum="77323aab8b59b5cf84ea09cb43e0e4a0c05e1f1a" type="binary">http:\/\/download\.java\.net\/dlj\/binaries\/jdk-6u15-dlj-linux-amd64\.bin<\/Archive>/' $source/devel/programming/language/java/sun-java/pspec.xml > $destination/programming/language/java/sun-java/pspec.xml

#fix for catbox
echo "catbox x86-64 için uygun hale getiriliyor"
sed -e 's/<Archive sha1sum="23b22e77669a9eff75654d10c0f20753f69795cf" type="targz">http:\/\/cekirdek\.pardus\.org\.tr\/~gurer\/pisi\/catbox-1\.1\.tar\.gz<\/Archive>/<Archive sha1sum="f6ae6f9f2134a98b6261aba531a92f75afdbc2a6" type="targz">http:\/\/cekirdek\.pardus\.org\.tr\/~gurer\/pisi\/catbox-1\.2\.tar\.gz<\/Archive>/' -e 's/<Patch>kernel_build\.patch<\/Patch>/<!--Patch>kernel_build\.patch<\/Patch-->/' $source/devel/system/devel/catbox/pspec.xml > $destination/system/devel/catbox/pspec.xml

#fix for pam
echo "pam x86-64 için uygun hale getiriliyor"
sed 's/<Path fileType="library">\/lib<\/Path>/ <Path fileType="library">\/lib<\/Path> \n             <Path fileType="library">\/lib64<\/Path>/g' $source/devel/system/base/pam/pspec.xml > $destination/system/base/pam/pspec.xml

#fix for binutils
echo "binutils x86_64 için uygun hale getiriliyor"
sed 's/<Path fileType="library">\/usr\/lib\/<\/Path>/ <Path fileType="library">\/usr\/lib\/<\/Path> \n             <Path fileType="library">\/usr\/lib64\/<\/Path>/g' $source/devel/system/devel/binutils/pspec.xml > $destination/system/devel/binutils/pspec.xml
sed -e 's/pisitools\.remove("\/usr\/lib\/libiberty\.a")/pisitools\.remove("\/usr\/lib64\/libiberty\.a")/' -e 's/pisitools\.insinto("\/usr\/lib", "libiberty\/libiberty\.a")/pisitools\.insinto("\/usr\/lib64", "libiberty\/libiberty\.a")/' $source/devel/system/devel/binutils/actions.py > $destination/system/devel/binutils/actions.py

#fix for icecream
echo "icecream x86_64 için uygun hale getiriliyor"
sed 's/i686-pc-linux-gnu/x86_64-pc-linux-gnu-/' $source/devel/system/devel/icecream/actions.py > $destination/system/devel/icecream/actions.py

#fix for cups
echo "cups x86_64 için uygun hale getiriliyor"
sed 's/<Path fileType="library">\/usr\/lib<\/Path>/ <Path fileType="library">\/usr\/lib<\/Path>\n             <Path fileType="library">\/usr\/lib64<\/Path>/g' $source/devel/hardware/printer/cups/pspec.xml > $destination/hardware/printer/cups/pspec.xml

#fix for procps
echo "procps x86_64 için uygun hale getiriliyor"
sed 's/<Path fileType="library">\/lib<\/Path>/ <Path fileType="library">\/lib<\/Path>\n             <Path fileType="library">\/lib64<\/Path>/g' $source/devel/system/base/procps/pspec.xml > $destination/system/base/procps/pspec.xml

#fix for libcap
echo "libcap x86_64 için uygun hale getiriliyor"
sed 's/<Path fileType="library">\/lib<\/Path>/ <Path fileType="library">\/lib<\/Path>\n             <Path fileType="library">\/lib64<\/Path>/g' $source/devel/system/base/libcap/pspec.xml > $destination/system/base/libcap/pspec.xml
sed 's/pisitools\.remove("\/lib\/libcap\.a")/pisitools\.remove("\/lib64\/libcap\.a")/' $source/devel/system/base/libcap/actions.py > $destination/system/base/libcap/actions.py

#fix for Xaw3d
echo "Xaw3d x86_64 için uygun hale getiriliyor"
sed 's/<Path fileType="library">\/lib<\/Path>/ <Path fileType="library">\/lib<\/Path>\n             <Path fileType="library">\/lib64<\/Path>/g' $source/devel/x11/library/Xaw3d/pspec.xml > $destination/x11/library/Xaw3d/pspec.xml

#fix for graphviz
echo "graphviz x86_64 için uygun hale getiriliyor"
sed 's/<Path fileType="library">\/usr\/lib\/<\/Path>/ <Path fileType="library">\/usr\/lib\/<\/Path>\n             <Path fileType="library">\/usr\/lib64\/<\/Path>/g' $source/devel/multimedia/graphics/graphviz/pspec.xml > $destination/multimedia/graphics/graphviz/pspec.xml

#fix for jack-audio-connection-kit
echo "jack-audio-connection-kit x86_64 için uygun hale getiriliyor"
sed 's/<Path fileType="library">\/usr\/lib<\/Path>/ <Path fileType="library">\/usr\/lib<\/Path>\n             <Path fileType="library">\/usr\/lib64<\/Path>/g' $source/devel/multimedia/sound/jack-audio-connection-kit/pspec.xml > $destination/multimedia/sound/jack-audio-connection-kit/pspec.xml

#fix for gpac
echo "gpac x86_64 için uygun hale getiriliyor"
sed 's/<Path fileType="library">\/usr\/lib<\/Path>/ <Path fileType="library">\/usr\/lib<\/Path>\n             <Path fileType="library">\/usr\/lib64<\/Path>/g' $source/devel/multimedia/video/gpac/pspec.xml > $destination/multimedia/video/gpac/pspec.xml

##### removed ######

#pae
#echo "pae paketi kaldırılıyor"
#rm -rf $destination/kernel/pae

#xorg-video-geode
#echo "xorg-video-geode paketi kaldırılıyor"
#rm -rf $destination/x11/driver/xorg-video-geode

#psyco
#echo "psyco paketi kaldırılıyor"
#rm -rf $destination/programming/language/python/psyco

#grub
#echo "grub paketi kaldırılıyor"
#rm -rf $destination/system/base/grub
