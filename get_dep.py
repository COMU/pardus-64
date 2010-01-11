#!/usr/bin/python
# -*- coding: utf-8 -*-
import optparse

import pisi
dep_list = {}


list_packages  = open('liste.txt', 'r')
had_packages = list_packages.readlines()
def main():
    usage = "usage: %prog [options] path/query"
    parser = optparse.OptionParser(usage=usage)
    parser.add_option("-f", "--file",
                      action="store_false", dest="full", default=True,
                      help="Where is the file where i put to output")

    (options, args) = parser.parse_args()
    if len(args) != 1:
        parser.error("Incorrect number of arguments")
    path_output = args[0]
    print path_output
    list_pspec_xml  = open(path_output, 'r')
    list_pspec =  list_pspec_xml.readlines()
    list_packages.close()
    list_pspec_xml.close()
    for i in list_pspec:
        importSpec(i)
    hede  = open('dep.txt', 'w')
    hodu =  hede.writelines(dep_list.keys())
    hede.close

def importSpec(_spec):
    _spec = _spec.split("\n")[0]
    if (_spec == '#'):
        return
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

if __name__ == '__main__':
    
    main()
