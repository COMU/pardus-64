#!/usr/bin/python
# -*- coding: utf-8 -*-

import pisi
dep_list = {}

list_packages  = open('liste.txt', 'r')
list_pspec_xml  = open('son.txt', 'r')
list_pspec =  list_pspec_xml.readlines()
had_packages = list_packages.readlines()
list_packages.close()
list_pspec_xml.close()


def main():
    usage = "usage: %prog [options] path/to/noan path/to/repo/source"
    parser = optparse.OptionParser(usage=usage)
    parser.add_option("-r", "--release", dest="release",
                      help="Use RELEASE as ditro version instead", metavar="RELEASE")
    parser.add_option("-u", "--update",
                      action="store_false", dest="full", default=True,
                      help="Run SVN UP and load changed files only")

    (options, args) = parser.parse_args()
    if len(args) != 2:
        parser.error("Incorrect number of arguments")

    path_noan, path_source = args

    os.environ['DJANGO_SETTINGS_MODULE'] = 'noan.settings'
    sys.path.insert(0, path_noan)
    try:
        import noan.settings
    except ImportError:
        parser.error('Noan path is invalid.')

    updateDB(path_source, options.full, options.release)

def importSpec(_spec):
    _spec = _spec.split("\n")[0]
    pspec = pisi.specfile.SpecFile(_spec)
    for dep in pspec.source.buildDependencies:
        if dep.package+"\n" in had_packages:
            print dep.package," var."
        else:
            dep_list[dep.package+"\n"] = ""
    for pack in pspec.packages:
        for dep in pack.runtimeDependencies():
            if isinstance(dep, pisi.specfile.AnyDependency):
                for any_dep in dep.dependencies:
                    if any_dep.package+'\n' in had_packages:
                        print any_dep.package," var."
                    else:
                        dep_list[any_dep.package+'\n'] = ""
            else:
                if dep.package+"\n" in had_packages:
                    print dep.package," var."
                else:
                    dep_list[dep.package+"\n"] = ""
for i in list_pspec:
    importSpec(i)


hede  = open('dep.txt', 'w')
hodu =  hede.writelines(dep_list.keys())
hede.close
