import ast
import importlib.util
import json
import math
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


GENERATOR = Path(__file__).with_name("generate_geometry.py")
spec = importlib.util.spec_from_file_location("generate_geometry", GENERATOR)
generator = importlib.util.module_from_spec(spec)
spec.loader.exec_module(generator)


class GenerateGeometryTest(unittest.TestCase):
    def setUp(self):
        self.common = dict(indenter_type="conical", tipRadius=1.0,
                           coneAngle=120.0, h_sample=4.0)
        self.sx = dict(self.common, kind="SX", D_sample=8.0,
                       box_xfrac=0.3, box_zfrac=0.3, r_center_frac=0.25)
        self.bx = dict(self.common, kind="BX", len_sample=10.0,
                       w_sample=8.0, ind_dist=1.2, inclination=75.0,
                       trace_angle=30.0)

    def test_sx_and_bx_generate_valid_standalone_scripts(self):
        for data in (self.sx, self.bx):
            with self.subTest(kind=data["kind"]):
                script = generator.render(data, "model.py")
                compile(script, "model.py", "exec")
                self.assertIn("DocumentSave.Execute(outputPath", script)
                self.assertNotIn("File.ResetProject()", script)

    def test_gui_dimensions_are_converted_and_offsets_preserved(self):
        for data, marker in ((self.sx, "# Specimen Geometry\n"),
                             (self.bx, "# SPECIMEN GEOMETRY\n")):
            source = generator.render(data, "model.py").split(marker)[0]
            assignments = [node for node in ast.parse(source).body
                           if isinstance(node, ast.Assign)
                           and all(isinstance(target, ast.Name) and target.id != "root"
                                   for target in node.targets)]
            values = {"math": math}
            exec(compile(ast.Module(body=assignments, type_ignores=[]), "<parameters>", "exec"), values)
            if data["kind"] == "SX":
                self.assertAlmostEqual(values["D_sample"], 0.008)
                self.assertAlmostEqual(values["a"], 0.0003)
            else:
                self.assertAlmostEqual(values["distIndSam"], 1.2)
                self.assertAlmostEqual(values["inclination"], 75)
                self.assertAlmostEqual(values["angGB"], -60)

    def test_bx_boundary_must_intersect_both_surfaces(self):
        self.bx["inclination"] = 1.0
        with self.assertRaisesRegex(ValueError, "grain boundary"):
            generator.render(self.bx, "model.py")

    def test_invalid_export_does_not_create_script(self):
        self.sx["indenter_type"] = "flatPunch"
        with tempfile.TemporaryDirectory() as directory:
            parameters = Path(directory) / "parameters.json"
            script = Path(directory) / "model.py"
            parameters.write_text(json.dumps(self.sx), encoding="utf-8")
            result = subprocess.run(
                [sys.executable, str(GENERATOR), str(parameters), str(script)],
                capture_output=True, text=True)
            self.assertNotEqual(result.returncode, 0)
            self.assertIn("cono-spherical", result.stderr)
            self.assertFalse(script.exists())


if __name__ == "__main__":
    unittest.main()
