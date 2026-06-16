# Artifact Appendix

Paper title: **LendLocked: Privacy & Transparency for Digital Library Lending**

Artifact Hotcrp No: **11**

Requested Badge(s):
  - [x] **Available**
  - [x] **Functional**
  - [x] **Reproduced**

## Description 

The repository contains the artifacts in the research paper "LendLocked: Privacy & Transparency for Digital Library Lending" by Boya Wang (boya.wang@mpi-sp.org), Peter Hall (pf2184@nyu.edu), Sunoo Park (sunoo.park@nyu.edu), to appear in 2026 Privacy Enhancing Technologies Symposium (PETS). 

#### Abstract
> Digital library lending is a critical resource for access to information. Currently prevalent models of digital lending, however, involve opaque licensing schemes that entail serious drawbacks to reader privacy and freedom of expression. In popular modern library apps, publishers and hidden intermediaries control a wealth of information about readers and reading habits, at a scale and level of detail that would be essentially impossible in physical library lending. 
> 
> To understand digital lending needs in practice, our work begins with a series of interviews with library professionals (N=11). We present thematic findings on their concerns with existing systems, including privacy, surveillance, preservation, and lack of library control over resources. Many of the concerns raised are inherently unproblematic in the context of physical library lending---leading us to our central technical question: Can digital lending achieve privacy and transparency at least as strong as physical library lending?
> 
> Based on our qualitative findings, we provide the first rigorous modeling of security, privacy, and transparency requirements in digital library lending. As existing systems fall short of the strong guarantees we model, we propose a new system design, LendLocked, based on cryptography and trusted hardware, and prove it achieves these guarantees in the random oracle model. We micro-benchmark our design's key cryptographic functionalities, showing tolerable efficiency at the scale of the largest libraries.

#### Mapping Contributions to Artifacts

We list each of our contributions with their corresponding public artifacts including interview protocols, formal definition, construction algorithms, cryptographic proofs, and evaluation code. This repository only contains the evaluation artifacts, as all the other artifacts are already published in the paper. 

1. **Interview study**. As discussed in our paper *Appendix A Ethical Considerations*, the interview study was approved by our IRBs. Participants provided explicit consent to participation before their interview. 
To respect participants' choices on anonymity and consider the potential adverse privacy consequences of releasing detailed transcripts, we do NOT release participant identities nor transcripts. 
Instead, we publish the interview protocol and a summary of participant background information, in *Section 3 Interviews* and *Appendix D Additional Details on Interviews* of the paper. 
Before publication, we additionally double-checked with each participant on the accuracy of referenced quotes or our interpretations of their answers. 

2. **Formal modeling of a digital library lending system**. We formally define the functional, security, and privacy properties of a digital library lending system, published in *Section 5 Our Model* and *Appendix F Complete Definitions* of the paper. 

3. **Construction Algorithm**. We provide a specific construction, LendLocked, fulfilling the properties of the formal model, published in *Section 6 Construction of LendLocked* and *Appendix G Additional Algorithm Specifications* of the paper. 

4. **Cryptographic Proof**. We provide security and privacy proofs of LendLocked, published in *Section 7 Proofs of Security* and *Appendix H Remaining Proofs* of the paper. 

5. **Evaluation Code**. We microbenchmark the overhead of our construction caused by cryptographic operations, results summarized in *Section 8 Evaluation by Micro-Benchmarks*. 
This repository contains the benchmark code with required environment, to reproduce the performance results. 
We on purpose use micro-benchmarks to show how minimal the efficiency overhead caused by the cryptographic primitives in our design of LendLocked is, especially when comparing with the circulation delay in existing library lending systems. 

### Security/Privacy Issues and Ethical Concerns

LendLocked is a research project and our code is for the performance evaluation of LendLocked only. 
We refer readers to the paper's *Appendix A Ethical Considerations & Societal Impact* for detailed discussions on the ethics of our project, especially on the interview study and the context of controlled digital lending. 

This evaluation artifacts rely on public cryptographic libraries from [previous research](https://github.com/Zokrates). 
Some of these libraries may not have undergone any production-level security audit, and we solely rely on their functionalities. 
We hence caution the usage of our implementation building blocks in a production system that processes sensitive data. 
Our evaluation code runs *locally* on device, there is no data shared over the Internet. 

## Basic Requirements

To access or run our artifacts, there is no need of special hardware. 
Our evaluation artifacts require public softwares and environment setup. 

**Note:** The softwares used below may not support Windows, however, should be functional for Linux and MacOS. Our instructions are optimized for reproducing the results on tested environments, i.e., MacOS. 

### Hardware Requirements

The evaluation artifacts can run on a laptop and finish within half an hour. 
For the reported results in the paper, we used a **MacBook with Apple M1 Pro chip 1.30GHz and 16 GB memory**, released in October 2021. 
For a functional run using the script in this repository, any MacBook in the same or newer models should work. 
However, due to the increased capabilities of CPUs in the newer versions, we suspect the measured time to be considerably shorter than the ones reported here. 
We also note that the shortened time will be in favor of our evaluation claims, i.e., the efficiency improvement of hardware, software, and cryptographic primitives would introduce even less overhead for our design. 

### Software Requirements

All required software are publicly accessible. 
For a **functional run** of our evaluation code, we recommend the following software stack **version ranges**. 
Some evaluation results are in the scale of a few ms, and hence, very sensitive to the potential overhead caused by virtualization. 
Therefore, a **reproduction run** with matching benchmark results could require the **exact** version we tested marked in **bold**:

#### Software Prerequisites
1. macOS after Sequoia 15.3, reproduced with [**macOS Sequoia 15.7.3**](https://support.apple.com/en-us/102662)
2. git any version, reproduced with [**git 2.50.1 (Apple Git-155)**](https://git-scm.com/install/mac)
3. git lfs any version, reproduced with [**git-lfs/3.7.1 (GitHub; darwin arm64; go 1.25.3)**](https://github.com/git-lfs/git-lfs#on-macos)
4. conda after 24, reproduced with [**conda 24.11.3**](https://www.anaconda.com/docs/getting-started/miniconda/install/mac-cli-install)

#### Software Handled by Setup
5. Python after 3.11, reproduced with **Python 3.11.7**
6. pip after 23.3, reproduced with **pip 23.3.1** already preinstalled from Python 3.11.7
7. [**Zokrates 0.8.8**](https://github.com/Zokrates/ZoKrates/releases/tag/0.8.8) for constructing the zkSNARK in the evaluation 
8. [**ZnaKes 0.1.1**](https://pypi.org/project/ZnaKes/0.1.1/) for creating zokrates proof inputs
9. [**Zokrates pyCrypto 2e0601**](https://github.com/Zokrates/pycrypto/tree/2e0601ef3f4c2472362ef620e7c81fc555d5cf8d) for creating zokrates proof inputs
10. [**hyperfine 1.19.0**](https://github.com/sharkdp/hyperfine/tree/12fec42098642a19855ead34c8cb1e0be28c8ead) for automate multi-run time measurements

### Estimated Time and Storage Consumption

- Overall human time: 3 minutes. The reproduction of all experiments is fully automate via a one-click script, the human time is for reading our claim and the results as printed out. 
- Overall computer time: 35 minutes if using the one-click script. If running the sections separately:  
    - 1 minute to [check software prerequisites](#check-software-prerequisites)
    - 4 minutes to [clone the repository](#accessibility)
    - 3 minutes to [install the environments](#set-up-the-environment)
    - 1 minute to [check the environments](#testing-the-environment)
    - 24 minutes to reproduce [claim 1 borrowing efficiency](#experiment-1-membership-proof-efficiency)
    - 2 minutes to reproduce [claim 2 auditing efficiency](#experiment-2-hash-efficiency)
- Overall disk space: less than 10 GB
- Overall RAM consumption: comfortably runnable with a 16 GB RAM computer 
- Overall clean-up time: 1 minute with the [tear-down instructions](#clean-up) we provided. All files, softwares, and environment paths will be removed. 

**One Click Reproduction**: 
If you already fulfill the [Hardware Requirements](#hardware-requirements) and [Software Prerequisites](#software-prerequisites), we provide a script to facilitate a one-click reproduction (which basically run all following sections in order: check prerequisite, clone repository, set up environment, verify environment, execute experiments, compare results). 
To fetch only this script, run: 
```bash
curl -fsSL https://raw.githubusercontent.com/Boyaw/lendlocked/main/one-click-repro.sh -o one-click-repro.sh
# reproduce in one click
bash one-click-repro.sh
```

**Reproduction Notes**: We do not provide docker-based reproduction environment because of potential time difference/slowdown caused by docker's incompatibility with M1 chip. Instead, we provide the above one-click script to provide similar convenient reproduction and clean-up instructions to properly tear-down the setup. 

## Environment

### Check Software Prerequisites
We require 4 prerequisites as listed in [Software Prerequisites](#software-prerequisites) before cloning the repository and setting up the environment: macOS Sequoia, git, git-lfs, and conda. 
Check their existence by running: 
```bash
[[ "$(sw_vers -productVersion 2>/dev/null)" == 15.* ]] && command -v git >/dev/null && command -v git-lfs >/dev/null && command -v conda >/dev/null && echo "Prerequisites satisfied" || echo "Missing a prerequisite (macOS Sequoia / git / git-lfs / conda)"
```
If any one of the 4 prerequisites is missing, please refer to the linked install instructions from [Software Requirements](#software-requirements).
After getting `Prerequisites satisfied`, you can proceed with [repository clone and environment setup](#set-up-the-environment) in the following section. 

### Accessibility

All artifacts are accessible at the public Github repository [lendlocked](https://github.com/Boyaw/lendlocked). 

### Set up the environment

1. clone and enter the artifact repository

```bash
git lfs install    # register the lfs hooks if haven't
git clone git@github.com:Boyaw/lendlocked.git
cd lendlocked
ls
```

2. run the setup script
```bash
bash setup.sh
```

### Testing the Environment

3. activate the environment and export paths (please use the exact commands at the end of `setup.sh` script, example commands below contains placeholders):
```bash
conda activate ll-repro
export PATH="$PWD/bin:$PATH"
export ZOKRATES_STDLIB="$PWD/bin/stdlib"   # zokrates reads ZOKRATES_STDLIB for its stdlib
export PYTHONPATH="$PWD/pycrypto:$PYTHONPATH"   # zokrates_pycrypto lives inside the cloned pycrypto subdir
```

4. verify the path

```bash
# verify the two exports took effect:
which zokrates                  # -> .../bin/zokrates   (local copy shadows any global one)
which hyperfine                 # -> .../bin/hyperfine
echo "$ZOKRATES_STDLIB"         # -> .../bin/stdlib
ls "$ZOKRATES_STDLIB" >/dev/null && echo "ZOKRATES_STDLIB OK"       # stdlib dir exists
python -c "import zokrates_pycrypto" && echo "zokrates_pycrypto OK"  # importable from the clone
```

5. assert the exact software stack **BEFORE** trusting any reproduced numbers 

```bash
bash check_env.sh
```

For a functional run, the python ecosystem and the native binaries should match the required version ranges. 
If the script runs successfully (finished without hard failure), your setup should be good for a functional run. 

For a successful reproduction with consistent results, ideally all requirements should be matched exactly. 
At least, the following lines must match the exact version (while the other lines only need to match the required ranges, warnings are non-fatal): 
- macOS 15.7.3
- Python 3.11.7
- Zokrates 0.8.8, 
- ZnaKes 0.1.1, 
- Zokrates pyCrypto 2e0601, 

```bash
== env safeguard ==
  OK    interpreter in env: /opt/anaconda3/envs/ll-repro
== environment (checked only, not pinned) ==
  OK    macOS = 15.7.3
  OK    git: git version 2.50.1 (Apple Git-155)
== python ecosystem (pinned) ==
  OK    python = 3.11.7
  OK    pip = 23.3.1
  OK    ZnaKes = 0.1.1
  OK    pycrypto commit = 2e0601ef3f4c2472362ef620e7c81fc555d5cf8d
== native binaries (asserted) ==
  OK    zokrates = 0.8.8
  OK    hyperfine = 1.19.0

Environment check passed.
```

## Artifact Evaluation

We provide the artifacts for borrowing efficiency and auditing efficiency, as other parts of our protocol design does not add considerable overhead over existing practices. 
We elaborate the reason why and why not we benchmark the procedures in our construction explicit in the later [limitation section](#recap-of-construction) of the artifacts. 

### Main Results and Claims


#### Main Result 1: Borrowing Efficiency

The bottleneck of borrowing efficiency is the cryptographic operations on the e-reader and the library side. 
*Table 3 Measurements of Proof Functions* in our paper shows that, even for the scale of the largest library in the world, the cryptographic computation that must happen online on the e-reader side will finish within 5 seconds. 
The column of Merkle depth denotes the number of registered user-e-reader pairs, i.e., Merkle depth 10, 20, 30 indicates $2^{10} \approx 1K$, $2^{20} \approx 1M$, $2^{30} \approx 1B$ registrations. 
The first row shows four cryptographic computation steps for the required membership proof scaling with the number of registrations, i.e., `setup`, `witness`, `prove`, `verify`. 
As `setup` happens offline on the e-reader and `verify` happens on the library side who has reasonably sufficient computational resources than an average user device, our claim relies on the result that both the `witness` and `prove` added up will take less than 5 seconds for Merkle depth 30. 
This claim is reproducible by executing [Experiment 1 Membership Proof Efficiency](#experiment-1-membership-proof-efficiency). 

#### Main Result 2: Auditing Efficiency

The public audit procedure ensures transparency of digital library lending. 
Auditors, e.g., internal auditor from national library organizations, publishers who are interested in auditing copyright compliance of libraries, can verify the append-only-ness of the catalog periodically. 
In current practices of library lending, the auditing often happen through a tedious, potentially manual process, a few times per year. 
With our design of a cryptographic catalog, an auditor with a laptop can automatically verify the append-only proof monthly within a few days even for the largest existing library.
Essentially, the auditor recompute the hashes of each newly appended record since last audit. 
This claim is reproducible by executing [Experiment 2 Hash Efficiency](#experiment-2-hash-efficiency). 

### Experiments

#### Experiment 1: Membership Proof Efficiency
> - Time: 24 compute-minutes 
> - Storage: less than 10 GB

**exp 1a Merkle depth 10**

1. enter into the subfolder `exp-borrow-depth-10`, which includes: 
- `10-create-input.py`, input generation script with Merkle depth 10
- `10-loan-proof.zok`, zokrates source file for loan proof (note that reproduction run only requires the compiled `out`)
- `abi.json`, proof input template defining the format
- `out`, the pre-compiled program from `10-loan-proof.zok`
- `out.r1cs`, an export of the constraint system, as an easier reference for interested reader to inspect circuit size
```bash
# enter the experiment subfolder
cd exp-borrow-depth-10
```

2. generate fresh inputs
```bash
# this python script WRITES 20-proof-inputs.txt
# expect the script to run for about a minute
python 10-create-input.py
```

3. run the benchmarks in this order
```bash
hyperfine --warmup 3 --runs 5 'zokrates setup'                    --export-json 10_setup.json
hyperfine --warmup 3 --runs 5 "zokrates compute-witness -a $(cat 10-proof-inputs.txt)" --export-json 10_witness.json
hyperfine --warmup 3 --runs 5 'zokrates generate-proof'           --export-json 10_proof.json
hyperfine --warmup 3 --runs 5 'zokrates verify'                   --export-json 10_verify.json
```

4. expected results (due to cryptographic randomness and device temperature, the numbers will not be identical, but should be similar)
```bash
(ll-repro) user@macpro exp-borrow-depth-10 % hyperfine --warmup 3 --runs 5 'zokrates setup'                    --export-json 10_setup.json
hyperfine --warmup 3 --runs 5 "zokrates compute-witness -a $(cat 10-proof-inputs.txt)" --export-json 10_witness.json
hyperfine --warmup 3 --runs 5 'zokrates generate-proof'           --export-json 10_proof.json
hyperfine --warmup 3 --runs 5 'zokrates verify'                   --export-json 10_verify.json
Benchmark 1: zokrates setup
  Time (mean ± σ):      2.368 s ±  0.015 s    [User: 7.873 s, System: 0.272 s]
  Range (min … max):    2.352 s …  2.388 s    5 runs
 
Benchmark 1: zokrates compute-witness -a 19758412836956187705098872130204300246430766689444862701921329124704953062645 4321988522515564108990097159188373120811834778373154659530061977419689120154 4009794841637244632734809057537800215928401851241330692070142992394760622722 14416893394599051284868181732426499658761167405771674008794515017442215409913 4553250288663903115717677817401727525261562177715491933894449226682283950492 3814687126 4207057211 2301474087 1696421512 1054042432 4114589074 2402006685 2358319779 2636307903 771130895 3338794104 910337493 3941248527 2566242658 3403499691 2178970740 2780070436 59738663 1645461473 534297178 1910759638 3322112274 1297763356 629541565 38654257 3305789272 2153894818 222417624 3572959456 4252490776 2872080752 2967572678 1 0 0 0 0 0 0 0 0 0 2576817173 85244481 2596561856 2255375492 2794840420 1782105243 2233078322 224377663 2868205599 2537009619 1620830863 3872042866 3969069788 1888500782 3572146597 3847022253 2836095705 235016979 3924538583 2295676569 1346335958 4045419796 3885894217 2899768670 2662873574 2776819738 4169635575 215831002 2546324098 2868684311 1621128226 2970965221 2764362413 2154280342 2932117484 1459218082 2997336012 1549461915 101902398 2264250305 2930015840 2321511960 1470280671 155374319 2535829433 1029561825 2723201146 2038818870 280440794 2669576670 213771388 1616405657 2083766662 3260669584 1831970450 1710683843 2408855228 1079018165 2214813011 2125881869 799556152 241244772 2789497932 1981448089 2396270100 581138062 183963467 1786945471 909715492 3791725341 50298776 3912496056 2291351018 1747045928 583503599 3609069204 2296515330 3978121736 3936207279 4136468773
  Time (mean ± σ):      1.415 s ±  0.002 s    [User: 1.356 s, System: 0.056 s]
  Range (min … max):    1.412 s …  1.417 s    5 runs
 
Benchmark 1: zokrates generate-proof
  Time (mean ± σ):      2.182 s ±  0.021 s    [User: 6.063 s, System: 0.330 s]
  Range (min … max):    2.151 s …  2.199 s    5 runs
 
Benchmark 1: zokrates verify
  Time (mean ± σ):       5.7 ms ±   0.4 ms    [User: 4.2 ms, System: 1.4 ms]
  Range (min … max):     5.3 ms …   6.3 ms    5 runs
```


**exp 1b Merkle depth 20**

1. enter into the subfolder `exp-borrow-depth-20`, which includes: 
- `20-create-input.py`, input generation script with Merkle depth 20
- `20-loan-proof.zok`, zokrates source file for loan proof (note that reproduction run only requires the compiled `out`)
- `abi.json`, proof input template defining the format
- `out`, the pre-compiled program from `20-loan-proof.zok`
- `out.r1cs`, an export of the constraint system, as an easier reference for interested reader to inspect circuit size
```bash
# enter the experiment subfolder
cd exp-borrow-depth-20
```

2. generate fresh inputs
```bash
# this python script WRITES 20-proof-inputs.txt and prints EdDSA timings
# expect the script to run for about a minute
python 20-create-input.py
```

3. run the benchmarks in this order
```bash
hyperfine --warmup 3 --runs 5 'zokrates setup'                    --export-json 20_setup.json
hyperfine --warmup 3 --runs 5 "zokrates compute-witness -a $(cat 20-proof-inputs.txt)" --export-json 20_witness.json
hyperfine --warmup 3 --runs 5 'zokrates generate-proof'           --export-json 20_proof.json
hyperfine --warmup 3 --runs 5 'zokrates verify'                   --export-json 20_verify.json
```

4. expected results (due to cryptographic randomness and device temperature, the numbers will not be identical, but should be similar)
```bash
(ll-repro) user@macpro exp-borrow-depth-20 % hyperfine --warmup 3 --runs 5 'zokrates setup'                    --export-json 20_setup.json
Benchmark 1: zokrates setup
  Time (mean ± σ):      2.761 s ±  0.023 s    [User: 9.605 s, System: 0.316 s]
  Range (min … max):    2.744 s …  2.800 s    5 runs
 
(ll-repro) user@macpro exp-borrow-depth-20 % hyperfine --warmup 3 --runs 5 "zokrates compute-witness -a $(cat 20-proof-inputs.txt)" --export-json 20_witness.json
Benchmark 1: zokrates compute-witness -a ...some_very_long_numbers...
  Time (mean ± σ):      1.566 s ±  0.003 s    [User: 1.510 s, System: 0.054 s]
  Range (min … max):    1.562 s …  1.571 s    5 runs
 
(ll-repro) user@macpro exp-borrow-depth-20 % hyperfine --warmup 3 --runs 5 'zokrates generate-proof'           --export-json 20_proof.json
Benchmark 1: zokrates generate-proof
  Time (mean ± σ):      2.481 s ±  0.011 s    [User: 6.959 s, System: 0.355 s]
  Range (min … max):    2.471 s …  2.499 s    5 runs
 
(ll-repro) user@macpro exp-borrow-depth-20 % hyperfine --warmup 3 --runs 5 'zokrates verify'                   --export-json 20_verify.json
Benchmark 1: zokrates verify
  Time (mean ± σ):       5.7 ms ±   0.4 ms    [User: 4.1 ms, System: 1.3 ms]
  Range (min … max):     5.3 ms …   6.3 ms    5 runs
```

**exp 1c Merkle depth 30**

1. enter into the subfolder `exp-borrow-depth-30`, which includes: 
- `30-create-input.py`, input generation script with Merkle depth 20
- `30-loan-proof.zok`, zokrates source file for loan proof (note that reproduction run only requires the compiled `out`)
- `abi.json`, proof input template defining the format
- `out`, the pre-compiled program from `30-loan-proof.zok`
- `out.r1cs`, an export of the constraint system, as an easier reference for interested reader to inspect circuit size
```bash
# enter the experiment subfolder
cd exp-borrow-depth-30
```

2. generate fresh inputs
```bash
# this python script WRITES 30-proof-inputs.txt and prints EdDSA timings
# expect the script to run for about a minute
python 30-create-input.py
```

3. run the benchmarks in this order
```bash
hyperfine --warmup 3 --runs 5 'zokrates setup'                    --export-json 30_setup.json
hyperfine --warmup 3 --runs 5 "zokrates compute-witness -a $(cat 30-proof-inputs.txt)" --export-json 30_witness.json
hyperfine --warmup 3 --runs 5 'zokrates generate-proof'           --export-json 30_proof.json
hyperfine --warmup 3 --runs 5 'zokrates verify'                   --export-json 30_verify.json
```

4. expected results (due to cryptographic randomness and device temperature, the numbers will not be identical, but should be similar)
```bash
(ll-repro) user@macpro exp-borrow-depth-30 % hyperfine --warmup 3 --runs 5 'zokrates setup' --export-json 30_setup.json
hyperfine --warmup 3 --runs 5 "zokrates compute-witness -a $(cat 30-proof-inputs.txt)" --export-json 30_witness.json
hyperfine --warmup 3 --runs 5 'zokrates generate-proof'           --export-json 30_proof.json
hyperfine --warmup 3 --runs 5 'zokrates verify'                   --export-json 30_verify.json
Benchmark 1: zokrates setup
  Time (mean ± σ):      3.208 s ±  0.079 s    [User: 11.506 s, System: 0.378 s]
  Range (min … max):    3.141 s …  3.320 s    5 runs
 
Benchmark 1: zokrates compute-witness -a ...some_very_long_numbers...
  Time (mean ± σ):      1.748 s ±  0.009 s    [User: 1.675 s, System: 0.070 s]
  Range (min … max):    1.739 s …  1.760 s    5 runs
 
Benchmark 1: zokrates generate-proof
  Time (mean ± σ):      2.832 s ±  0.079 s    [User: 7.858 s, System: 0.401 s]
  Range (min … max):    2.755 s …  2.923 s    5 runs
 
Benchmark 1: zokrates verify
  Time (mean ± σ):       6.0 ms ±   0.3 ms    [User: 4.3 ms, System: 1.4 ms]
  Range (min … max):     5.6 ms …   6.3 ms    5 runs
```
**compare results**

Readers can manually compare the claimed numbers with the newly measured result in each `.json` file generated by `hyperfine` command. 
We also provide a python script to automate checks: 
- the mean and media of all 12 measurements are either within 5% margin or within an absolute tolerance of 1ms (as verification is in total a few ms, a 1ms can fall out of 5% margin)
- the stddev is form-wise correct, i.e., more than 0 

Expected results when all checks passed:
```bash
(ll-repro) user@macpro lendlocked % python compare-res.py

== Merkle depth 10 ==
  setup    mean   OK    meas 2.3675s  claim 2.3750s
  setup    median OK    meas 2.3666s  claim 2.3630s
  setup    stddev OK    meas 0.0145s  (must be > 0)
  witness  mean   OK    meas 1.4147s  claim 1.4140s
  witness  median OK    meas 1.4145s  claim 1.4050s
  witness  stddev OK    meas 0.0020s  (must be > 0)
  prove    mean   OK    meas 2.1819s  claim 2.2070s
  prove    median OK    meas 2.1905s  claim 2.1630s
  prove    stddev OK    meas 0.0207s  (must be > 0)
  verify   mean   OK    meas 0.0057s  claim 0.0060s
  verify   median OK    meas 0.0058s  claim 0.0050s
  verify   stddev OK    meas 0.0004s  (must be > 0)

== Merkle depth 20 ==
  setup    mean   OK    meas 2.7612s  claim 2.7940s
  setup    median OK    meas 2.7529s  claim 2.8060s
  setup    stddev OK    meas 0.0234s  (must be > 0)
  witness  mean   OK    meas 1.5661s  claim 1.5700s
  witness  median OK    meas 1.5663s  claim 1.5690s
  witness  stddev OK    meas 0.0032s  (must be > 0)
  prove    mean   OK    meas 2.4806s  claim 2.4470s
  prove    median OK    meas 2.4777s  claim 2.4440s
  prove    stddev OK    meas 0.0107s  (must be > 0)
  verify   mean   OK    meas 0.0057s  claim 0.0060s
  verify   median OK    meas 0.0056s  claim 0.0050s
  verify   stddev OK    meas 0.0004s  (must be > 0)

== Merkle depth 30 ==
  setup    mean   OK    meas 3.2083s  claim 3.1040s
  setup    median OK    meas 3.1645s  claim 3.1090s
  setup    stddev OK    meas 0.0790s  (must be > 0)
  witness  mean   OK    meas 1.7484s  claim 1.7430s
  witness  median OK    meas 1.7452s  claim 1.7400s
  witness  stddev OK    meas 0.0093s  (must be > 0)
  prove    mean   OK    meas 2.8319s  claim 2.7570s
  prove    median OK    meas 2.7896s  claim 2.7540s
  prove    stddev OK    meas 0.0793s  (must be > 0)
  verify   mean   OK    meas 0.0060s  claim 0.0050s
  verify   median OK    meas 0.0059s  claim 0.0050s
  verify   stddev OK    meas 0.0003s  (must be > 0)
```

#### Experiment 2: Hash Efficiency

> Time: 2 compute minutes
> Storage: 4 KB

In our evaluation, we use a back-of-the-envelope calculation to estimate the auditing time. 
We measure the time of one hash function and one signature verification. 
Each record can contain at most 27 (we use an overestimation of 30 hashes for size of ~100M tree) hashes, and 2 signatures. 
We assume the auditor needs to check 100M records per month (which is itself a very comfortable overestimation). 

Running the following python script to compute the estimated auditing time: 
```bash
(ll-repro) user@macpro lendlocked % python exp-audit.py
Warmup hash.
Signature verification warmed up!
One record hash lower margin (ms):
0.015175342559814453
One record hash (ms):
0.015974044799804688
One record hash higher margin (ms):
0.016772747039794925
Private key (32 bytes): b'0c7a12f57116e4c228dceee1e73563a8733d9c7eaeba634d85f812a6ae9221c8'
Public key (32 bytes):  b'81cdb824548e9344ac26113b221488eb1778817ae715034d760d0d9ec6b9e20b'
Signature (64 bytes): b'50afffeff94e08163d3ba9d62c825a49fc81af97271b9e7c04be09f97977877c50105a2088272114f5dc7e30a3dbea7bfdfaa53923cf4687239cc183a16d8d0d'
The signature is valid.
One record signature time lower margin (ms):
1.957392692565918
One record signature time (ms):
2.060413360595703
One record signature time higher margin (ms):
2.1634340286254883
Lower margin audit time for 100M records (days):
2.2830648554695974
Audit time for 100M records (days):
2.4032261636522083
Higher margin audit time for 100M records (days):
2.523387471834819
```
**Reproduction Note:** 
This measurement, similar to the `zokrates verify` measurement, is very sensitive to machine thermals as each single computation can be at 0.1-1 ms scale. 
The 5% margin may not be informative. 
However, our claim in the paper remains as long as the overall calculated auditing time is within a few days. 

## Clean Up

After finishing the run, it is easy to tear down everything by:
```bash
conda deactivate
# remove the conda env
conda env remove -n ll-repro
cd ..
# remove the artifact repository
rm -rf lendlocked
# remove the one-click script, if used
rm one-click-repro.sh
```

## Limitations

This repository only contains the evaluation artifacts, as all the other artifacts of our work are already included in the paper. 

The artifacts in this repository only benchmark the computational overhead caused by our cryptographic design in the borrow and auditing protocols, since our design does not have considerable impact in other procedures. 
We on purpose choose microbenchmarks to show the little overhead caused by the cryptographic operations, especially compared with the time needed for existing library lending practices with physical interactions. 

In the following, we provide detailed discussions on the design of our microbenchmarks.

#### Explanations on Benchmark Design

There are five subprotocols in our construction: Register, Borrow, Access, Return, Audit. 
In the evaluation, we focus on the Borrow and Audit subprotocol. 
It is because these two parts are where we introduce tailored cryptographic operations, and hence, create overhead compared to existing implementations of library lending systems. 

To justify our evaluation design, we provide a review of the functions in each subprotocol focusing on their realization cost. 

**Register** 
This subprotocol only runs once per U-R pair with standard operations widely seen in existing systems. Therefore, it will not become a bottleneck on the performance of our design. We hence do not measure Register subprotocol in the evaluation. 

- `PatronRegL` represents the (potentially physical) interactions that happen during patron registration. This is a standard procedure and our construction introduce no overhead (especially compare to the time spent on physical interactions).
- `GenRegReqU` outputs a registration request that contains a user secret which will be used later in U-R key pair generation. The generation and transmission of authentication information is a standard procedure, and hence, is not a bottleneck.
- `KeyGenRegR` requires a standard key generation function commonly seen in digital applications, and hence, is not a bottleneck.
- `ProcessRefReqL` adds a new leaf node to a Merkle tree which contains all registered verification keys. This is a standard and much more light-weight operation e.g., in large-scale transparency log for certificate transparency. Hence, it is not a bottleneck. 
- `FinishRegR` is a one-time verification, which is also standard e.g., in transparency log systems. 

**Borrow**
This subprotocol contains cryptographic operations and plays major role in user experience, and hence, is the focus of our evaluation. Please refer to the paper for exact measurement results in *Table 3*. 

**Access**
This subprotocol contains standard communication and computation operations in existing applications. 
Hence, Access subprotocol is not a bottleneck and we do not focus on it in the evaluation. 

- `PrepAccessU` contains only communication cost from U to R, which are prevalent in e.g., device-app communication.
- `GenLoadReqR` can contain a one-round communication with logBB with a lookup operation. This is a standard operation in client-server communication. It can follow with a local loading operation, which is prevalent in e-reading applications. Hence, this function is not a bottleneck. 
- `ProcessLoadReqL` is when L check (and allow download of) the content in its internal database. This is a standard operation in the current digital library systems. Hence, this function is not a bottleneck. 
- `ProcessLoadResR` is the same as downloading content in the ebook systems, and hence, not a bottleneck. 

**Return** 
This subprotocol is syntax-wise symmetric to the Borrow subprotocol, at the same time, requires less computation. 
Hence, the microbenchmark on Borrow subprotocol already represents the efficiency. 

- `PrepRetU` is similar to `PrepAccessU` in Access subprotocol, it contains only communication cost from U to R, which are prevalent in e.g., device-app communication.
- `GenRetReqR`is a symmetric operation as `GenLoadReqR` in Borrow subprotocol, but with a much more light-weight computation: only need to provide the esk as a proof of knowledge on epk.
- `ProcessRetReqL` is a symmetric operation as `ProcessLoanReqL`, hence, we refer to the same measurement in *Table 3*. 
- `ProcessRetResR` contains a lookup on logBB with the reference location and the deletion of content, both are standard operations in digital applications e.g., email systems. 

**Audit**
This subprotocol runs by an audior offline. 
It does not affect user experience, however, the scalability matters especially for libraries with a large amount of circulations. We provide measurements in the scenario of small, medium, and the largest libraries. 
Please refer to the paper for exact measurement results in *Section Evaluation by Micro-Benchmarks: Audit Protocol*. 


## Notes on Reusability

We note two scenarios of reusing our artifacts. 

1. Environment Setup of ZoKrates and its Python support libraries. 
Our setup script include installing ZoKrates and its Python support (for creating proof inputs), which are not specified by ZoKrates official documents. The path configuration of ZoKrates and its Python support libraries can be non-straightforward, and often cause compiling errors if missing any of the three. We hope our setup can compliment the current ZoKrates documentation and facilitate easier setup of ZoKrates applications. 

2. General simulation on anonymous registration verification. 
The ZoKrates source scripts in this repository contain the construction of a Zero-Knowledge Succinct Non-Interactive Argument of Knowledge (zk-SNARK) on an append-only Merkle tree. This setting is quite common in e.g. anonymous registration verification by proving the possession of a signing key that corresponds to one of the public keys being logged on an append-only public board. The proof is, in other words, showing "I am a registered user" without revealing the exact identity by no revealing the exact signature created by this user. We hope our scripts can provide a better foundation to use ZoKrates in prototyping systems requiring anonymous registration verification, e.g., anonymous credential systems, digital wallet, privacy-preserving transparency log etc. Our scripts are at the scales of 1K, 1M, and 1B, however, can be easily extended to even larger scale, by increasing the simulation depth of Merkle Tree. 
