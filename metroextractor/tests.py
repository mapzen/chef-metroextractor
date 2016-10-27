import unittest, tempfile, os

from . import nothingburger

class Nothingburger (unittest.TestCase):

    def setUp(self):
        handle, self.filename = tempfile.mkstemp()
        os.close(handle)
    
    def tearDown(self):
        os.remove(self.filename)

    def test_tell_us(self):
        nothingburger.tell_us([0, 1, 2, 3], self.filename)
        with open(self.filename) as file:
            self.assertEqual(next(file), '[0, 1, 2, 3]\n')