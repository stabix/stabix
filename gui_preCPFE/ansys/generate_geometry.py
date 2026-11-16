"""Generate a geometry-only SpaceClaim script from preCPFE parameters."""

import json
import math
import os
import sys


def _replace_once(text, old, new):
    if text.count(old) != 1:
        raise ValueError("Geometry template has changed: expected exactly one " + repr(old))
    return text.replace(old, new, 1)


def _replace_expected(text, old, new, count):
    if text.count(old) != count:
        raise ValueError("Geometry template has changed: unexpected occurrences of " + repr(old))
    return text.replace(old, new)


def _number(data, name):
    value = data[name]
    if isinstance(value, bool) or not isinstance(value, (int, float)):
        raise ValueError(name + " must be a number")
    value = float(value)
    if math.isnan(value) or math.isinf(value):
        raise ValueError(name + " must be finite")
    return value


def render(data, script_path):
    kind = data["kind"]
    if kind not in ("SX", "BX"):
        raise ValueError("Only SX and BX indentation are supported")
    if data["indenter_type"] != "conical":
        raise ValueError("Only the cono-spherical indenter is supported")
    radius = _number(data, "tipRadius")
    angle = _number(data, "coneAngle")
    height = _number(data, "h_sample")
    if radius <= 0 or height <= 0 or not 0 < angle < 180:
        raise ValueError("Tip radius and specimen height must be positive and cone angle must be between 0 and 180 degrees")

    directory = os.path.dirname(os.path.abspath(__file__))
    if kind == "SX":
        diameter = _number(data, "D_sample")
        xfrac = _number(data, "box_xfrac")
        zfrac = _number(data, "box_zfrac")
        center = _number(data, "r_center_frac")
        if diameter <= 0 or not 0 < xfrac < 1 or not 0 < zfrac < 1 or not 0 < center < 1:
            raise ValueError("SX diameter must be positive and subdivision fractions must be strictly between 0 and 1")
        template = "3D_SX_indentation_allBodies_Discovery_Geometry_noBCs.py"
        marker = "# Specimen Geometry\n"
        values = (
            "h_sample = %.17g / 1000.0\n"
            "D_sample = %.17g / 1000.0\n"
            "r_sample = D_sample / 2.0\n"
            "a = %.17g * %.17g * r_sample\n"
            "x_mid = %.17g * r_sample\n"
            "z_mid = -h_sample * %.17g\n"
            "z_fin = -h_sample\n"
        ) % (height, diameter, center, xfrac, xfrac, zfrac)
    else:
        length = _number(data, "len_sample")
        width = _number(data, "w_sample")
        distance = _number(data, "ind_dist")
        inclination = _number(data, "inclination")
        trace = _number(data, "trace_angle")
        if length <= 0 or width <= 0 or not 0 < inclination < 180:
            raise ValueError("BX dimensions must be positive and inclination must be between 0 and 180 degrees")
        xmin, xmax = (distance - length) / 2.0, (distance + length) / 2.0
        bottom = distance - height * math.tan(math.radians(90.0 - inclination))
        if not (xmin < 0 < xmax and xmin < distance < xmax and xmin < bottom < xmax):
            raise ValueError("Indenter and grain boundary must remain inside the specimen at both top and bottom")
        template = "3D_BX_indentation_allBodies_Discovery_Geometry.py"
        marker = "# SPECIMEN GEOMETRY\n"
        values = (
            "h_sample = %.17g\n"
            "l_sample = %.17g\n"
            "w_sample = %.17g\n"
            "z_fin = -h_sample\n"
            "distIndSam = %.17g\n"
            "inclination = %.17g\n"
            "angGB = %.17g - 90.0\n"
        ) % (height, length, width, distance, inclination, trace)

    with open(os.path.join(directory, template), "r", encoding="utf-8-sig") as stream:
        source = stream.read()
    if source.count(marker) != 1:
        raise ValueError("Geometry template marker is missing or ambiguous: " + marker)
    body = source[source.index(marker):]
    if body.count("ExtrudeType.None") != 2:
        raise ValueError("Geometry template has changed: expected two revolve operations")
    body = body.replace("ExtrudeType.None", "getattr(ExtrudeType, 'None')")
    body = _replace_once(body, "File.SaveAs(outputPath)", "DocumentSave.Execute(outputPath, ExportOptions.Create())")
    body = _replace_once(body, "MM(-0.08)", "MM(-tipRadius * 0.1)")
    sharing = (
        "options = ShareTopologyOptions()\n"
        "options.Tolerance = UM(0.2)\n"
        "result = ShareTopology.FindAndFix(options)"
        if kind == "SX" else
        "options = ShareTopologyOptions()\n"
        "options.Tolerance = UM(0)\n"
        "result = ShareTopology.FindAndFix(options)"
    )
    body = _replace_once(body, sharing, "# Share specimen topology manually in Mechanical.")

    if kind == "BX":
        body = _replace_expected(body, "UM(-l_sample/2)", "UM(-l_sample/2 + distIndSam/2)", 1)
        body = _replace_expected(body, "UM(l_sample/2)", "UM(l_sample/2 + distIndSam/2)", 2)
        body = _replace_once(
            body,
            "selection = Selection.Create(GetRootPart().CoordinateSystems[0].Axes[0])\n"
            "result = DatumPlaneCreator.Create(selection, False, None)",
            "angle = math.radians(90.0 - inclination)\n"
            "result = DatumPlaneCreator.Create(Point.Create(UM(distIndSam), UM(0), UM(0)), "
            "Direction.Create(math.cos(angle), 0, -math.sin(angle)))",
        )
        body = _replace_once(
            body, "result = Move.Translate(selection, direction, UM(distIndSam), options)",
            "result = Move.Translate(selection, direction, UM(0), options)",
        )

    output_path = os.path.splitext(os.path.abspath(script_path))[0] + ".scdocx"
    header = (
        "# -*- coding: utf-8 -*-\n"
        "# Python Script, API Version = V251\n"
        "# Geometry only: configure mesh, contacts, loads and CP materials in Mechanical.\n"
        "# Run in a new empty SpaceClaim document.\n"
        "import math\n"
        "import os\n"
        "from SpaceClaim.Api.V251 import AngleUnit, MetricUnits, MetricLengthUnit, MetricMassUnit, UnitsSystemType\n"
        "root = GetRootPart()\n"
        "if len(root.GetAllBodies()) or len(root.Curves) or len(root.DatumPlanes) or len(root.Components):\n"
        "    raise RuntimeError('Run this script in a new empty document.')\n"
        "Window.ActiveWindow.Units.ActiveUnitsSystem = UnitsSystemType.Metric\n"
        "Window.ActiveWindow.Units.MetricUnits = MetricUnits(MetricLengthUnit.Micrometers, MetricMassUnit.Grams, AngleUnit.Degrees)\n"
        "tipRadius = %.17g / 1000.0\n"
        "coneAngle = %.17g\n"
        "h_trans = tipRadius * (1 - math.sin(math.radians(coneAngle / 2.0)))\n"
        "arcXVal = math.sqrt(tipRadius**2 - (tipRadius - h_trans)**2)\n"
        "segXVal = arcXVal + math.tan(math.radians(coneAngle / 2.0)) * (tipRadius - h_trans)\n"
        "z_ini = 0\n"
        "RevolDegree = 360\n"
        "mergeFlag = False\n"
        "outputPath = %s\n"
        "if os.path.exists(outputPath):\n"
        "    raise RuntimeError('Output geometry already exists: ' + outputPath)\n"
    ) % (radius, angle, "u" + ascii(output_path))
    return header + values + body


def main(argv):
    if len(argv) != 3:
        raise ValueError("Usage: generate_geometry.py parameters.json output.py")
    if sys.version_info[0] < 3:
        raise ValueError("Select a Python 3 executable for ANSYS geometry export")
    with open(argv[1], "r", encoding="utf-8-sig") as stream:
        data = json.load(stream)
    script = render(data, argv[2])
    with open(argv[2], "w", encoding="utf-8", newline="\n") as stream:
        stream.write(script)
    print("Geometry script written to " + os.path.abspath(argv[2]))


if __name__ == "__main__":
    main(sys.argv)
