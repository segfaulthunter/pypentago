#! /usr/bin/env python
# -*- coding: us-ascii -*-

# pypentago - a board game
# Copyright (C) 2008 Florian Mayer

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.


import unittest
from pypentago import crypto


class PasswordTest(unittest.TestCase):
    def test_hash_pwd(self):
        pwd = 'fourty-two'
        for m in crypto.methods:
            h = crypto.hash_pwd(pwd, m)
            if m != 'plain':
                self.assertNotEqual(h.rsplit('$')[-1], pwd)
            self.assertNotEqual(h, pwd)
            self.assertEqual(crypto.check_pwd(h, pwd), True)
    
    def test_unknown_method(self):
        self.assertRaises(ValueError, crypto.hash_pwd, 'fourty-two', '42')
    
    def test_invalid_hash(self):
        self.assertRaises(ValueError, crypto.check_pwd, 'invalid$hash', '42')


if __name__ == '__main__':
    unittest.main()
