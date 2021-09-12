# proxima

An exploratory project for accelerating quantum systems simulation by performing approximate computations via artificial intelligence methods.

![electron-positions](images/electron-positions.png)
![n-electrons-histogram](images/n-electrons-histogram.png)
![x-expectation-value-c-based-plot](images/x-expectation-value-c-based-plot.png)
![x-expectation-value-n-based-plot](images/x-expectation-value-n-based-plot.png)

## Building

The following command must be executed for packaging the project contents:

```sh
swift package update && swift build
```

## Usage

The main executable may be launched after the compilation has finished via the following simple command (currently just samples generation is supported, to get a complete list of available
commands and their options run the executable with flag `-h`). The command given as an example says that the system must generate 20 samples (in our case 20 two-dimensional electron locations
in a potential well), with degree of accuracy which is equal to 120, using 4 workers and 17 as a seed number. The results must be put into the file `assets/corpora/**foo**.tsv`.

```sh
./.build/debug/proxima -n 20 -p 120 -w 4 -s 17 -o foo
```
