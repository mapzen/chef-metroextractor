#!/usr/bin/env python

from json import load, JSONEncoder
from argparse import ArgumentParser, FileType
from re import compile
import sys

float_pat = compile(r'^-?\d+\.\d+(e-?\d+)?$')
charfloat_pat = compile(r'^[\[,\,]-?\d+\.\d+(e-?\d+)?$')

parser = ArgumentParser(description="Group (merge) multiple GeoJSON files.")

defaults = dict(precision=6, outfile=sys.stdout)

parser.set_defaults(**defaults)

parser.add_argument('files',
                  type=FileType('r'), help='Files to be merged', nargs="+")
parser.add_argument('-p', '--precision', dest='precision',
                  type=int, help='Digits of precision')
parser.add_argument('-o', '--outfile', dest='outfile',
                  type=FileType('wb', 0), help='Outfile')

if __name__ == '__main__':
    args = parser.parse_args()
    infiles = args.files
    outfile = args.outfile

    outjson = dict(type='FeatureCollection', features=[])

    for infile in infiles:
        injson = load(infile)

        if injson.get('type', None) != 'FeatureCollection':
            raise Exception('Sorry, "%s" does not look like GeoJSON' % infile)

        if type(injson.get('features', None)) != list:
            raise Exception('Sorry, "%s" does not look like GeoJSON' % infile)
        try:    
            outjson['features'] += injson['features']
        except:
            outjson['features'] += injson

    encoder = JSONEncoder(separators=(',', ':'))
    encoded = encoder.iterencode(outjson)

    format = '%.' + str(args.precision) + 'f'
    output = outfile

    for token in encoded:
        if charfloat_pat.match(token):
            # in python 2.7, we see a character followed by a float literal
            output.write(token[0] + format % float(token[1:]))

        elif float_pat.match(token):
            # in python 2.6, we see a simple float literal
            output.write(format % float(token))

        else:
            output.write(token)
