import unittest

from robotframeworklexer import *


class TestVariableFinder(unittest.TestCase):

    def _verify(self, string, *expected):
        tokenizer = VariableTokenizer()
        actual = list(tokenizer.tokenize(string, ARGUMENT))
        self.assertEqual(len(actual), len(expected))
        for act, exp in zip(actual, expected):
            self.assertEqual(act, exp)

    def test_empty_string(self):
        self._verify('', ('', ARGUMENT))

    def test_no_variable(self):
        self._verify('text', ('text', ARGUMENT))
        self._verify('${text', ('${text', ARGUMENT))

    def test_scalar_variable(self):
        self._verify('${variable}',
                     ('${', SYNTAX), ('variable', VARIABLE), ('}', SYNTAX))

    def test_list_variable(self):
        self._verify('@{my var}',
                     ('@{', SYNTAX), ('my var', VARIABLE), ('}', SYNTAX))

    def test_environment_variable(self):
        self._verify('%{VAR_NAME}',
                     ('%{', SYNTAX), ('VAR_NAME', VARIABLE), ('}', SYNTAX))

    def test_normal_texst_and_variable(self):
        self._verify("can haz @{var}?!??!!",
                     ('can haz ', ARGUMENT),
                     ('@{', SYNTAX), ('var', VARIABLE), ('}', SYNTAX),
                     ('?!??!!', ARGUMENT))

    def test_string_with_multiple_variables(self):
        self._verify("${var} + ${bar}@{x}",
                     ('${', SYNTAX), ('var', VARIABLE), ('}', SYNTAX),
                     (' + ', ARGUMENT),
                     ('${', SYNTAX), ('bar', VARIABLE), ('}', SYNTAX),
                     ('@{', SYNTAX), ('x', VARIABLE), ('}', SYNTAX))

    def test_escaping(self):
        self._verify('\\${not var}', ('\\${not var}', ARGUMENT))
        self._verify('-\\${a}-\\${b}-', ('-\\${a}-\\${b}-', ARGUMENT))

    def test_internal(self):
        self._verify('${var${inside}}',
                     ('${', SYNTAX), ('var', VARIABLE), ('${', SYNTAX),
                     ('inside', VARIABLE), ('}', SYNTAX), ('}', SYNTAX))
        self._verify('@{%{var${not}} end',
                     ('@{', SYNTAX), ('%{', SYNTAX), ('var${not', VARIABLE),
                     ('}', SYNTAX), ('}', SYNTAX), (' end', ARGUMENT))

    def test_list_var_index(self):
        self._verify('${var}[0] is not special',
                     ('${', SYNTAX), ('var', VARIABLE), ('}', SYNTAX),
                     ('[0] is not special', ARGUMENT))
        self._verify('@{var}[ 0] is special',
                     ('@{', SYNTAX), ('var', VARIABLE), ('}', SYNTAX),
                     ('[', SYNTAX), (' 0', VARIABLE), (']', SYNTAX),
                     (' is special', ARGUMENT))

    def test_list_var_index_with_variable(self):
        self._verify('@{var}[${i}] end',
                     ('@{', SYNTAX), ('var', VARIABLE), ('}', SYNTAX),
                     ('[', SYNTAX), ('${', SYNTAX), ('i', VARIABLE),
                     ('}', SYNTAX), (']', SYNTAX), (' end', ARGUMENT))
