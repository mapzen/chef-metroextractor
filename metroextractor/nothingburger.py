from __future__ import print_function
from argparse import ArgumentParser

parser = ArgumentParser(description='Tell us what they told you.')

parser.add_argument('bbox', type=float, nargs=4, metavar='deg.',
                    help='Bounding box degrees, given as (lon, lat, lon, lat)')

parser.add_argument('filename',
                    help='Output filename')

def tell_us(bbox, filename):
    '''
    '''
    with open(filename, 'w') as file:
        print(bbox, file=file)

def main():
    args = parser.parse_args()
    return(tell_us(args.bbox, args.filename))
