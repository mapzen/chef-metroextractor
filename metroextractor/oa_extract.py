import requests, uritemplate

from sys import stderr
from argparse import ArgumentParser
from io import BytesIO, TextIOWrapper
from zipfile import ZipFile, ZIP_DEFLATED
from csv import DictReader, DictWriter
from urllib.parse import urljoin
from itertools import product

OA_URL = 'https://results.openaddresses.io/index.json'

COLUMNS = ['LON', 'LAT', 'NUMBER', 'STREET', 'UNIT', 'CITY',
           'DISTRICT', 'REGION', 'POSTCODE', 'ID', 'HASH',
           'OA:Source']

parser = ArgumentParser(description='Tell us what they told you.')

parser.add_argument('bbox', type=float, nargs=4, metavar='deg.',
                    help='Bounding box degrees, given as (lon, lat, lon, lat).')

parser.add_argument('filename',
                    help='Output filename, should end in .zip.')

def main():
    args = parser.parse_args()
    return(extract_oa(args.bbox, args.filename))

def extract_oa(bbox, filename):
    '''
    '''
    bounds = get_bounds(*bbox)
    points = iterate_tile_addresses(*bounds)
    
    buffer = BytesIO()
    outcsv = DictWriter(TextIOWrapper(buffer, line_buffering=True), COLUMNS)
    outcsv.writerow({f: f for f in outcsv.fieldnames})
    count = 0
    
    for point in points:
        outcsv.writerow(point)
        count += 1
    
    print('Saved {} address points'.format(count), file=stderr)
    
    zipfile = ZipFile(filename, 'w', ZIP_DEFLATED, allowZip64=True)
    zipfile.writestr('addresses.csv', buffer.getvalue())

def get_bounds(lon1, lat1, lon2, lat2):
    '''
    '''
    minlon, minlat = min(lon1, lon2), min(lat1, lat2)
    maxlon, maxlat = max(lon1, lon2), max(lat1, lat2)
    
    return minlon, minlat, maxlon, maxlat

def iterate_tile_coords(minlon, minlat, maxlon, maxlat):
    '''
    '''
    lons = range(int(minlon), int(maxlon + 1), 1)
    lats = range(int(minlat), int(maxlat + 1), 1)

    return list(product(lons, lats))

def iterate_tile_addresses(minlon, minlat, maxlon, maxlat):
    '''
    '''
    lonlats = iterate_tile_coords(minlon, minlat, maxlon, maxlat)
    
    for (lon, lat) in lonlats:
        tile_url_tpl = urljoin(OA_URL, requests.get(OA_URL).json()['tileindex_url'])
        tile_url = uritemplate.expand(tile_url_tpl, dict(lat=lat, lon=lon))
        zipfile = ZipFile(BytesIO(requests.get(tile_url).content))
        print('Downloaded {}'.format(tile_url), file=stderr)
    
        csv_names = [name for name in zipfile.namelist() if name.endswith('.csv')]
        file = TextIOWrapper(zipfile.open(csv_names[0]))
        rows = DictReader(file)
        
        for row in rows:
            try:
                x, y = float(row['LON']), float(row['LAT'])
            except:
                continue
            if minlon <= x <= maxlon and minlat <= y <= maxlat:
                yield row
