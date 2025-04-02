function [fullres, fullresloc] = load_gridV2(filepath, filename, batchinfo, batchdims)
    % Construct full file path
    tempfp = fullfile(filepath, filename);

    
    % Read "Required Inputs" sheet
    
    % Read X and Y dimensions
    bundleinfoTOT = xlsread(tempfp, 'Required Inputs', 'C3:J3'); % Bundle info: 1:X Data Dimension, 2:Depth, 3:Y Data Dimension
    X_dim = bundleinfoTOT(1); % X Data Dimension
    Y_dim = bundleinfoTOT(4); % Y Data Dimension

    % Print dimensions expected
    disp(['X_dim: ', num2str(X_dim)]);
    disp(['Y_dim: ', num2str(Y_dim)]);
    disp(['Expected rows: ', num2str(X_dim * Y_dim)]);

    % Calculate pixel sizes (optional, if needed for downstream processing)
    pixelsizeX = (bundleinfoTOT(1) - bundleinfoTOT(3)) / (X_dim - 1);
    pixelsizeY = (bundleinfoTOT(2) - bundleinfoTOT(4)) / (Y_dim - 1);

    
    % Read data from the single test sheet
    
    % Test sheet is named "Test 001 Tagged"
    sheetname = 'Test 001 Tagged'; % Updated sheet name
    try
        % Read the entire data block from the test sheet
        data = xlsread(tempfp, sheetname, 'A3:H57002'); % Adjust range as needed
    catch
        error('Test sheet not found or data range is invalid.');
    end

    % Check the actual number of rows in the data
    actual_rows = size(data, 1);
    disp(['Actual rows in data: ', num2str(actual_rows)]);

    % If the data size does not match X_dim * Y_dim, adjust X_dim and Y_dim
    if actual_rows ~= X_dim * Y_dim
        warning('Data size mismatch: Adjusting dimensions to match actual data.');
        % Calculate new dimensions based on the actual number of rows
        X_dim_new = floor(sqrt(actual_rows)); % Approximate X_dim
        Y_dim_new = ceil(actual_rows / X_dim_new); % Calculate Y_dim to match the number of rows
        disp(['Adjusted X_dim: ', num2str(X_dim_new)]);
        disp(['Adjusted Y_dim: ', num2str(Y_dim_new)]);
        X_dim = X_dim_new;
        Y_dim = Y_dim_new;
    end

    % Initialize output arrays
    fullres = zeros(X_dim, Y_dim, 6); % 6 columns for quantitative data
    fullresloc = zeros(X_dim, Y_dim, 2); % 2 columns for X and Y coordinates

    % Populate fullres and fullresloc
    for k = 1:X_dim
        for l = 1:Y_dim
            % Calculate the index in the data array
            idx = (k - 1) * Y_dim + l;

            % Check if idx exceeds the number of rows in data
            if idx > actual_rows
                % If there's not enough data, fill with NaN
                fullres(k, l, 1:6) = NaN;
                fullresloc(k, l, 1:2) = NaN;
            else
                % Populate fullres with quantitative data
                fullres(k, l, 1:6) = data(idx, 1:6); % Columns 1-6: displacement, load, modulus, stiffness, hardness, etc.

                % Populate fullresloc with X and Y coordinates
                fullresloc(k, l, 1) = data(idx, 7); % Column 7: X coordinate
                fullresloc(k, l, 2) = data(idx, 8); % Column 8: Y coordinate
            end
        end
    end

    disp('Loading complete');
end