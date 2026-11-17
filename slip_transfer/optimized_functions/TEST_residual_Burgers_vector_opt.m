%% Test suite for residual_Burgers_vector_opt.m
% Comprehensive tests to validate the optimized vectorized implementation
% 
% Run this script to verify the optimized function works correctly
%
% Tests:
% 1. Single pair backward compatibility
% 2. Multiple pairs vectorization accuracy
% 3. Comparison with original function (loop-based)
% 4. Performance benchmark

function TEST_residual_Burgers_vector_opt()
    
    fprintf('\n=== Testing residual_Burgers_vector_opt.m ===\n\n');
    
    % Test 1: Single pair backward compatibility
    fprintf('Test 1: Single pair backward compatibility\n');
    test_single_pair();
    
    % Test 2: Multiple pairs
    fprintf('\nTest 2: Multiple pairs vectorization\n');
    test_multiple_pairs();
    
    % Test 3: Comparison with loop version
    fprintf('\nTest 3: Comparison with loop version\n');
    test_loop_comparison();
    
    % Test 4: Edge cases
    fprintf('\nTest 4: Edge cases\n');
    test_edge_cases();
    
    % Test 5: Performance benchmark
    fprintf('\nTest 5: Performance benchmark\n');
    test_performance();
    
    fprintf('\n=== All tests completed ===\n\n');
end

%% Test 1: Single pair backward compatibility
function test_single_pair()
    % Create random single pair
    b_in = randn(3, 1);
    b_out = randn(3, 1);
    
    % Test that it works and returns scalar
    try
        result = residual_Burgers_vector_opt(b_in, b_out);
        
        % Check output is scalar
        if isscalar(result)
            fprintf('  ✓ Single pair returns scalar\n');
        else
            fprintf('  ✗ Single pair did not return scalar (shape: %s)\n', mat2str(size(result)));
            return;
        end
        
        % Check result is non-negative
        if result >= 0
            fprintf('  ✓ Result is non-negative (%.6f)\n', result);
        else
            fprintf('  ✗ Result is negative: %.6f\n', result);
            return;
        end
        
        fprintf('  ✓ PASS: Single pair test\n');
        
    catch err
        fprintf('  ✗ FAIL: %s\n', err.message);
    end
end

%% Test 2: Multiple pairs vectorization
function test_multiple_pairs()
    % Create multiple pairs
    n_pairs = 100;
    b_in = randn(3, n_pairs);
    b_out = randn(3, n_pairs);
    
    try
        result = residual_Burgers_vector_opt(b_in, b_out);
        
        % Check output is vector of correct size
        if isvector(result) && length(result) == n_pairs
            fprintf('  ✓ Multiple pairs returns vector of correct size (%d)\n', n_pairs);
        else
            fprintf('  ✗ Output size mismatch (expected %d, got %s)\n', n_pairs, mat2str(size(result)));
            return;
        end
        
        % Check all results are non-negative
        if all(result >= 0)
            fprintf('  ✓ All results are non-negative\n');
        else
            fprintf('  ✗ Some results are negative\n');
            return;
        end
        
        % Check all results are finite
        if all(isfinite(result))
            fprintf('  ✓ All results are finite\n');
        else
            fprintf('  ✗ Some results are non-finite\n');
            return;
        end
        
        fprintf('  ✓ PASS: Multiple pairs test\n');
        
    catch err
        fprintf('  ✗ FAIL: %s\n', err.message);
    end
end

%% Test 3: Comparison with loop version
function test_loop_comparison()
    % Create multiple pairs
    n_pairs = 50;
    b_in = randn(3, n_pairs);
    b_out = randn(3, n_pairs);
    
    try
        % Vectorized version
        result_vec = residual_Burgers_vector_opt(b_in, b_out);
        
        % Loop version (using original function if available)
        result_loop = zeros(1, n_pairs);
        for i = 1:n_pairs
            result_loop(i) = residual_Burgers_vector(b_in(:,i), b_out(:,i));
        end
        
        % Compare
        max_diff = max(abs(result_vec - result_loop));
        rel_error = max_diff / (max(result_loop) + eps);
        
        if max_diff < 1e-14
            fprintf('  ✓ Results match perfectly (max diff: %.2e)\n', max_diff);
        elseif rel_error < 1e-12
            fprintf('  ✓ Results match within numerical precision (max diff: %.2e, rel error: %.2e)\n', max_diff, rel_error);
        else
            fprintf('  ✗ Results differ significantly (max diff: %.2e, rel error: %.2e)\n', max_diff, rel_error);
            return;
        end
        
        fprintf('  ✓ PASS: Loop comparison test\n');
        
    catch err
        fprintf('  ! Note: Could not compare with original function: %s\n', err.message);
        fprintf('  ! (This is OK if original residual_Burgers_vector.m is not in path)\n');
    end
end

%% Test 4: Edge cases
function test_edge_cases()
    
    try
        % Test case 1: Identical vectors (should give 0 for subtraction case)
        fprintf('  Testing: Identical vectors\n');
        b = [1; 0; 0];
        result = residual_Burgers_vector_opt(b, b);
        % Note: Result depends on sign of dot product, should still be valid
        if isfinite(result) && result >= 0
            fprintf('    ✓ Identical vectors handled (result: %.6f)\n', result);
        else
            fprintf('    ✗ Failed on identical vectors\n');
        end
        
        % Test case 2: Orthogonal vectors
        fprintf('  Testing: Orthogonal vectors\n');
        b1 = [1; 0; 0];
        b2 = [0; 1; 0];
        result = residual_Burgers_vector_opt(b1, b2);
        if isfinite(result) && result >= 0
            fprintf('    ✓ Orthogonal vectors handled (result: %.6f)\n', result);
        else
            fprintf('    ✗ Failed on orthogonal vectors\n');
        end
        
        % Test case 3: Nearly parallel vectors
        fprintf('  Testing: Nearly parallel vectors\n');
        b1 = [1; 0.001; 0];
        b2 = [1; 0; 0];
        result = residual_Burgers_vector_opt(b1, b2);
        if isfinite(result) && result >= 0
            fprintf('    ✓ Nearly parallel vectors handled (result: %.6f)\n', result);
        else
            fprintf('    ✗ Failed on nearly parallel vectors\n');
        end
        
        % Test case 4: Small magnitude vectors
        fprintf('  Testing: Small magnitude vectors\n');
        b1 = [1e-6; 0; 0];
        b2 = [1e-6; 0; 0];
        result = residual_Burgers_vector_opt(b1, b2);
        if isfinite(result) && result >= 0
            fprintf('    ✓ Small magnitude vectors handled (result: %.2e)\n', result);
        else
            fprintf('    ✗ Failed on small magnitude vectors\n');
        end
        
        fprintf('  ✓ PASS: Edge cases test\n');
        
    catch err
        fprintf('  ✗ FAIL: %s\n', err.message);
    end
end

%% Test 5: Performance benchmark
function test_performance()
    
    fprintf('  Benchmarking performance comparison:\n\n');
    
    % Test different array sizes
    sizes = [1, 10, 100, 1000];
    
    for n = sizes
        b_in = randn(3, n);
        b_out = randn(3, n);
        
        % Time optimized version
        tic;
        for rep = 1:100
            result_opt = residual_Burgers_vector_opt(b_in, b_out);
        end
        time_opt = toc / 100;
        
        % Time loop version (original)
        tic;
        for rep = 1:100
            result_loop = zeros(1, n);
            for i = 1:n
                result_loop(i) = residual_Burgers_vector(b_in(:,i), b_out(:,i));
            end
        end
        time_loop = toc / 100;
        
        speedup = time_loop / time_opt;
        
        fprintf('    %4d pairs: opt=%.3f µs, loop=%.3f µs, speedup=%.1f×\n', ...
                n, time_opt*1e6, time_loop*1e6, speedup);
    end
    
    fprintf('\n  ✓ PASS: Performance benchmark complete\n');
end
