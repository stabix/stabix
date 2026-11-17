function tests = test_ebsd_chi
tests = functiontests(localfunctions);
end

function setupOnce(testCase)
root = fileparts(fileparts(mfilename('fullpath')));
testCase.TestData.original_path = path;
addpath(fullfile(root, 'gui_ebsd_map'), fullfile(root, 'crystallo'), ...
    fullfile(root, 'crystal_plasticity'), fullfile(root, 'slip_transfer'), ...
    fullfile(root, 'test'), fullfile(root, 'util'));
end

function teardownOnce(testCase)
path(testCase.TestData.original_path);
end

function setup(testCase)
fig = figure('Visible', 'off');
testCase.TestData.figure = fig;
gui.handles.NumPh = uicontrol(fig, 'Style', 'edit', 'String', '1');
gui.flag.flag_lattice = 1;
gui.flag.CalculationFlag = 0;
gui.flag.pmparam2plot_value4GB = 18;
gui.config_data.struct1 = 'fcc';
gui.config_data.slips_1 = 1;
gui.config_data.slips_2 = 1;
gui.GF2_struct.data_smoothed = zeros(2,12);
gui.GF2_struct.data_smoothed(:,1) = [1;2];
gui.RB_struct.data_smoothed = zeros(1,14);
gui.GBs = struct('grainA', 1, 'grainB', 2, 'trace_angle', 0);
gui.grcen = zeros(2,18);
for grain = 1:2
    gui.grains(grain) = struct('ID', grain, 'material', 'Al', ...
        'structure', 'fcc', 'phase', 1);
end
gui.stressTensor.sigma = diag([0 0 1]);
gui.stressTensor.sigma_n = gui.stressTensor.sigma;
guidata(fig, gui);
end

function teardown(testCase)
close(testCase.TestData.figure);
end

function testIdenticalGrainsHaveUnitMaximumDespitePaddedSlips(testCase)
interface_map_mprime_calculator_map;
gui = guidata(testCase.TestData.figure);
verifyEqual(testCase, gui.results.chi_max, 1, 'AbsTol', 1e-12);
verifyTrue(testCase, all(gui.results.chi_max_slipA <= 12));
verifyTrue(testCase, all(gui.results.chi_max_slipB <= 12));
end

function testBoundaryTraceControlsChiAndSelectedPair(testCase)
fig = testCase.TestData.figure;
gui = guidata(fig);
gui.grcen(2,4:6) = [23 41 17];
for angle = [0 37 90]
    gui.GBs.trace_angle = angle;
    guidata(fig, gui);
    set(0, 'CurrentFigure', fig);
    interface_map_mprime_calculator_map;
    gui = guidata(fig);
    vectors = gui.calculations.vect;
    normal = [-sind(angle), cosd(angle), 0];
    expected = zeros(12,12);
    for a = 1:12
        for b = 1:12
            expected(a,b) = chi_factor(vectors(a,1:3,1), vectors(a,4:6,1), ...
                vectors(b,1:3,2), vectors(b,4:6,2), normal);
        end
    end
    verifyEqual(testCase, gui.results.chi_max, max(expected(:)), 'AbsTol', 1e-12);
    a = gui.results.chi_max_slipA(1);
    b = gui.results.chi_max_slipB(1);
    verifyEqual(testCase, expected(a,b), max(expected(:)), 'AbsTol', 1e-12);
end
end

function testUndefinedBoundaryGeometryRaisesError(testCase)
fig = testCase.TestData.figure;
gui = guidata(fig);
gui.GBs.trace_angle = NaN;
guidata(fig, gui);
verifyError(testCase, @interface_map_mprime_calculator_map, 'STABiX:UndefinedChi');
end
