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


# Fix the PYTHONPATH so we needn't have src in it.
import sys
from os.path import dirname, abspath, join
sys.path.append(abspath(join(dirname(__file__), "..")))
# End of prefix for executable files.

import unittest
from pypentago import core
from pypentago import board, _board
from pypentago.exceptions import (SquareNotEmpty, NotYourTurn, GameFull,
                                  InvalidTurn)
class Called(Exception):
    pass
def fail(*args, **kw):
    raise Called

class TestGame(unittest.TestCase):
    def setUp(self):
        self.game = core.Game()
        self.players = [core.Player() for _ in xrange(2)]
        for p in self.players:
            self.game.add_player(p)
    
    def test_win_dia(self):
        board = self.game.board
        # Construct winning situation.
        board.set_value(2, 0, 0, 0)
        board.set_value(2, 0, 1, 1)
        board.set_value(2, 0, 2, 2)
        board.set_value(2, 3, 0, 0)
        board.set_value(2, 3, 1, 1)

        # See whether the winner has been found.
        winner, loser = self.game.get_winner()
        self.assertNotEqual(winner, None)
        self.assertEqual(winner.uid, 2)

    def test_win_dia_sec(self):
        board = self.game.board
        # Construct winning situation.
        board.set_value(2, 0, 0, 1)
        board.set_value(2, 0, 1, 2)
        board.set_value(2, 1, 2, 0)
        board.set_value(2, 3, 0, 1)
        board.set_value(2, 3, 1, 2)

        # See whether the winner has been found.
        winner, loser = self.game.get_winner()
        self.assertNotEqual(winner, None)
        self.assertEqual(winner.uid, 2)

    def test_square_not_empty(self):
        self.players[0].do_turn((0, 0, 0, "R", 1))
        self.assertRaises(SquareNotEmpty, self.players[1].do_turn, 
                          (0, 0, 0, "R", 1))
    
    def test_not_your_turn(self):
        self.players[0].do_turn((0, 0, 0, "R", 1))
        self.assertRaises(NotYourTurn, self.players[0].do_turn, 
                          (1, 0, 0, "R", 1))
    
    def test_game_full(self):
        self.assertRaises(GameFull, self.game.new_id)
    
    def test_players(self):
        p_1, p_2 = self.players
        p_2.display_turn = fail
        # See if p_2.display_turn gets called
        self.assertRaises(Called, p_1.do_turn, (1, 0, 0, "R", 1))
    
    def test_beginner(self):
        beginner = self.game.random_beginner()
        other = self.game.other_player(beginner)
        self.assertRaises(NotYourTurn, other.do_turn, (1, 0, 0, "R", 1))
        self.assertEqual(beginner.do_turn((1, 0, 0, "R", 1)), None)
    
    def test_other(self):
        one, other = self.players
        self.assert_(self.game.other_player(one) is other)
        self.assert_(self.game.other_player(other) is one)
    
    def test_invalid(self):
        p_1, p_2 = self.players
        self.assertRaises(InvalidTurn, p_1.do_turn, (42, 0, 0, "R", 1))
        self.assertRaises(InvalidTurn, p_1.do_turn, (0, 42, 0, "R", 1))
        self.assertRaises(InvalidTurn, p_1.do_turn, (0, 0, 42, "R", 1))
        self.assertRaises(InvalidTurn, p_1.do_turn, (0, 0, 0, "cake", 1))
        self.assertRaises(InvalidTurn, p_1.do_turn, (0, 0, 0, "R", 5))
    
    def test_quit(self):
        p_1, p_2 = self.players
        p_2.opponent_quit = fail
        self.assertRaises(Called, p_1.quit_game)


class TestFallback(TestGame):
    def setUp(self):
        core.Board = board.Board
        TestGame.setUp(self)


if __name__ == "__main__":
    unittest.main()
