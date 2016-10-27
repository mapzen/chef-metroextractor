import unittest, unittest.mock

from . import nothingburger

class Nothingburger (unittest.TestCase):

    def test_tell_us(self):
        with unittest.mock.patch('io.open') as io_open:
            nothingburger.tell_us([0, 1, 2, 3], 'filename.txt')

        io_open.assert_called_once_with('filename.txt', 'w')
        write_call = io_open.return_value.__enter__.return_value.mock_calls[0]
        self.assertTrue(write_call[1][0].startswith('[0, 1, 2, 3]'))
