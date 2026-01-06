# Early Warning Signals for Critical Transitions

MATLAB codebase for detecting early warning signals (EWS) of critical transitions in time series data. This repository contains methods for analyzing autocorrelation, scaling behavior, and other statistical indicators that precede tipping points in dynamical systems.

## Repository Structure

```
MatlabCode/
├── Core_Functions/     # Reusable analysis functions
├── Projects/           # Paper-specific code and analysis
├── Data/               # Datasets (HadISD, ice cores, etc.)
├── Archive/            # Legacy and experimental code
├── Tests/              # Unit tests for core functions
├── Figures/            # Generated figures
└── External_Libraries/ # Third-party dependencies
```

## Core Functions

### Indicator Methods

| Function | Description |
|----------|-------------|
| `ACF.m` | Autocorrelation function at specified lag |
| `ACF_sliding.m` | Sliding window ACF(1) indicator |
| `DFA.m` | Detrended Fluctuation Analysis |
| `DFA_sliding.m` | Sliding window DFA scaling exponent |
| `DFA_estimation.m` | Estimate DFA alpha from time series |
| `PSE.m` | Power Spectral Exponent estimation |
| `PSE_sliding.m` | Sliding window spectral exponent |
| `VAR_sliding.m` | Sliding window variance |
| `EOF_sliding.m` | Sliding window EOF analysis |

### Dynamical Systems

Test systems for validating EWS methods:

- **Hopf bifurcation** - `hopf.m`, `hopf100.m`
- **Homoclinic bifurcation** - `homoclinic.m`
- **Van der Pol oscillator** - `VanDerPol.m`

### Numerical Integration

- `milstein.m` - Milstein method for SDEs
- `milstein_potential.m` - Potential-based SDE integration

### Statistics

- `mannkendall.m` - Mann-Kendall trend test
- `gauss_smoother.m` - Gaussian smoothing

## Projects

| Project | Description |
|---------|-------------|
| `Paper2018_EPL` | EPL paper on scaling indicators |
| `Paper2019_Multidim` | Multidimensional EWS analysis |
| `Paper2021_Sahara` | Sahara greening transitions |
| `Paper3_Climate` | Paleoclimate analysis (AHP end) |
| `Thesis` | PhD thesis chapters (C1-C4) |
| `HadISD_Analysis` | Weather station data analysis |
| `Conferences` | Conference presentations |

## Data

- `HadISD/` - HadISD weather station data (Florida, Texas, Louisiana)
- `MAT_files/` - Processed MATLAB workspaces
- `CSV_files/` - Tabular data exports
- `Ice_Cycles/` - Ice core proxy records

## Quick Start

```matlab
% Add core functions to path
addpath(genpath('Core_Functions'))

% Generate test data with increasing autocorrelation
N = 1000;
phi = linspace(0.5, 0.95, N);  % AR(1) coefficient approaching 1
data = zeros(N, 1);
for i = 2:N
    data(i) = phi(i) * data(i-1) + randn;
end

% Calculate sliding window ACF(1)
windowSize = 100;
acf1 = ACF_sliding(data, 1, windowSize);

% Calculate sliding DFA exponent
dfa_alpha = DFA_sliding(data, 2, windowSize);

% Plot results
figure
subplot(3,1,1); plot(data); ylabel('Data')
subplot(3,1,2); plot(acf1); ylabel('ACF(1)')
subplot(3,1,3); plot(dfa_alpha); ylabel('DFA \alpha')
```

## Key Concepts

### Critical Slowing Down
As a system approaches a tipping point, it recovers more slowly from perturbations. This manifests as:
- **Increased autocorrelation** (ACF approaching 1)
- **Increased variance**
- **Spectral reddening** (PSE approaching 2)
- **DFA exponent increase** (alpha > 0.5)

### Scaling Analysis
- **DFA** (Detrended Fluctuation Analysis) - Measures long-range correlations
- **PSE** (Power Spectral Exponent) - Spectral slope in log-log space
- For white noise: DFA alpha = 0.5, PSE beta = 0
- For random walk: DFA alpha = 1.5, PSE beta = 2

## References

Key papers this codebase supports:

1. Prettyman et al. (2018) - "A novel method for detecting critical transitions..."
2. Thesis chapters on 1D and 2D early warning signals
3. Cyclone/hurricane case studies using HadISD data

## Requirements

- MATLAB R2016b or later
- Statistics and Machine Learning Toolbox
- Signal Processing Toolbox (for spectral analysis)

## License

Academic use - contact author for permissions.

---
*Maintained as part of PhD research on critical transitions and early warning signals.*
