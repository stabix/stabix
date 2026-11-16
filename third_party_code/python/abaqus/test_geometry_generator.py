import ast
import contextlib
import io
from pathlib import Path
import sys
import tempfile
import unittest
import warnings


PYTHON_ROOT = Path(__file__).resolve().parents[1]
sys.path.insert(0, str(PYTHON_ROOT))
sys.path.insert(0, str(PYTHON_ROOT / "abaqus"))

import tools
from proc.bicrystal import BicrystalIndent
from proc.indentation import Indentation


class AbaqusGeometryGeneratorTest(unittest.TestCase):
    def test_sx_berkovich_script_is_written_and_has_integer_sectors(self):
        with tempfile.TemporaryDirectory() as temporary, contextlib.redirect_stdout(io.StringIO()):
            output_dir = Path(temporary) / "model"
            tools.mkdir_p(str(output_dir))
            tools.mkdir_p(str(output_dir))
            indent = Indentation(
                modelname="SX",
                geo="customized",
                numFaces=3,
                free_mesh_inp="SX_Indenter.inp",
                h_sample=2.0,
                sample_rep=24,
            )
            indent.to_file(dst_path=str(output_dir), dst_name="SX.py")
            source = (output_dir / "SX.py").read_text()

        with warnings.catch_warnings():
            warnings.simplefilter("error", SyntaxWarning)
            tree = ast.parse(source)
            compile(tree, "SX.py", "exec")
        self.assertIn("mdb.ModelFromInputFile", source)
        self.assertIn("side2Elements = s_indenter[1:3]", source)
        assignments = [
            node for node in tree.body
            if isinstance(node, ast.Assign)
            and len(node.targets) == 1
            and isinstance(node.targets[0], ast.Name)
            and node.targets[0].id in ("sample_rep", "sectors_45")
        ]
        namespace = {}
        exec(compile(ast.Module(body=assignments, type_ignores=[]), "parameters", "exec"), namespace)
        self.assertEqual(list(range(namespace["sectors_45"])), [0, 1, 2])

    def test_bicrystal_generator_still_initializes(self):
        with contextlib.redirect_stdout(io.StringIO()):
            indent = BicrystalIndent(
                geo="customized", numFaces=3, d=0.1, trace_ang=0,
                inclination=90, len_trace=10,
            )
        self.assertIn("mdb.ModelFromInputFile", "".join(indent.proc))

    def test_mkdir_p_raises_if_path_is_a_file(self):
        with tempfile.TemporaryDirectory() as temporary:
            path = Path(temporary) / "file"
            path.touch()
            with contextlib.redirect_stdout(io.StringIO()), self.assertRaises(OSError):
                tools.mkdir_p(str(path))


if __name__ == "__main__":
    unittest.main()
