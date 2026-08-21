# fiov2_toolkit

FalconStor `fio` benchmark toolkit — a collection of shell and PowerShell wrapper
scripts that drive [fio](https://github.com/axboe/fio) (Flexible I/O Tester)
against raw disks or files on Linux and Windows, and emit CSV results ready to
be imported into the companion Excel workbooks for charting.

See [`FalconStor fiov2 script user guide.md`](FalconStor%20fiov2%20script%20user%20guide.md)
for the full narrative guide (package requirements, execution-policy fixes,
CSV/Excel import walkthrough). This section is a quick technical reference to
every script in the repo.

## Script Reference

| Script | Platform | fio target | Type | Summary |
|---|---|---|---|---|
| [`falcon_io_fio_v2_for_excel.sh`](falcon_io_fio_v2_for_excel.sh) | Linux (bash) | fio v2 | Full sweep | Runs the complete I/O test matrix against a raw device/file (`libaio`, `direct=1`) and appends results to `FalconStor.Linux.fiov2.csv`. |
| [`falcon_io_fio_v2_for_excel_win.sh`](falcon_io_fio_v2_for_excel_win.sh) | Windows x86 (sh) | fio v2 | Full sweep | Same test matrix as the Linux v2 script, using `ioengine=windowsaio` and `--thread`; writes `FalconStor.Windowsx86.fiov2.csv`. |
| [`falcon_io_fio_v2_for_excel_winx64.ps1`](falcon_io_fio_v2_for_excel_winx64.ps1) | Windows x64 (PowerShell v2) | fio v2 | Full sweep | PowerShell port of the full test matrix; writes `FalconStor.Win64_fiov2.csv`. |
| [`falcon_io_fio_v2_for_excel_winx64_bz20069.ps1`](falcon_io_fio_v2_for_excel_winx64_bz20069.ps1) | Windows x64 (PowerShell v2) | fio v2 | Reduced sweep | Cut-down variant of the winx64 script (fewer block sizes / iodepths, 10s runtime) used for the bz20069 regression check — much faster to run. |
| [`falcon_io_fio_v3_for_excel.sh`](falcon_io_fio_v3_for_excel.sh) | Linux (bash) | fio v3 | Full sweep | Same matrix as the Linux v2 script, adds `--random_generator=tausworthe64` for fio v3's RNG; writes `FalconStor.Linux.fiov3.csv`. |
| [`fio_stress.sh`](fio_stress.sh) | Linux (bash) | fio v2 | Stress loop | Interactive script that repeats the 70/30 and 30/70 random read/write mix in an infinite loop for a single block size/iodepth/target — used for burn-in / stress testing rather than a one-shot benchmark. |
| [`fio_test.ps1`](fio_test.ps1) | Windows (PowerShell) | fio v2 | Single pattern | Parametrized single-pass test (block size, iodepth, disk range) with an interactive overwrite confirmation and optional CSV logging. |
| [`fio_test.sh`](fio_test.sh) | Linux (bash) | fio v2 | Single pattern | Parametrized single-pass test (block size, iodepth, target device list) with an interactive overwrite confirmation and optional CSV logging; Linux counterpart of `fio_test.ps1`. |

### Common I/O test matrix (full-sweep scripts)

The four "full sweep" scripts (`falcon_io_fio_v2_for_excel*`, `falcon_io_fio_v3_for_excel.sh`)
each drive fio through the same benchmark matrix:

- **I/O modes:** sequential read, sequential write, random read, random write,
  plus mixed random read/write at 70/30 and 30/70 ratios
- **Block sizes:** 512b, 4k, 8k, 16k, 32k, 64k, 128k, 256k
- **Queue depths:** 1, 4, 16, 64
- **Numjobs:** 1 (single stream)
- **Common fio flags:** `--direct=1 --group_reporting --minimal`, 30s runtime per case

Output is fio's `--minimal` (semicolon-delimited) format, converted to
comma-delimited CSV at the end of the run (`sed -i 's/;/,/g'` on Linux, a
`-replace ";",","` pass on PowerShell) so it can be opened directly in Excel.

## Quick Start

**Linux, full sweep:**
```bash
./falcon_io_fio_v2_for_excel.sh -target /dev/sdb:/dev/sdc -size 20%
```

**Windows x64, full sweep (PowerShell):**
```powershell
.\falcon_io_fio_v2_for_excel_winx64.ps1 -target \\.\PhysicalDrive1:\\.\PhysicalDrive2 -size 20%
```

**Linux, single pattern:**
```bash
./fio_test.sh 16k 4 /dev/sdb /root/io_result_log.csv
```

**Windows, single pattern:**
```powershell
.\fio_test.ps1 16k 4 1 20 c:\ io_result_log.csv
```

`-target`/`-size` accept multiple devices separated by `:` and a size as a
percentage (e.g. `20%`) or an absolute value (e.g. `10G`). See the user guide
for the full parameter breakdown, Windows execution-policy workaround, and
CSV/Excel import steps.

## Requirements

- `fio` v2.x or v3.x (Linux: RPM or built from source, needs `libaio`;
  Windows: the `fio-*.msi` build matching your OS bitness)
- Linux scripts: bash/sh with `awk`/`sed`
- Windows scripts: PowerShell v2+ (`Set-ExecutionPolicy RemoteSigned` may be
  required to run unsigned `.ps1` files), run as Administrator for raw disk access

## Output

Full-sweep scripts produce a CSV named after the model and platform, e.g.
`FalconStor.Linux.fiov2.csv`, `FalconStor.Windowsx86.fiov2.csv`,
`FalconStor.Win64_fiov2.csv`. Import these into
[`FS Benchmark Standard-1 READ WRITE Record-1.05_fiov2.xls`](FS%20Benchmark%20Standard-1%20READ%20WRITE%20Record-1.05_fiov2.xls)
to auto-chart the results. Results from `fio_test.sh` / `fio_test.ps1` import
into [`fiov2_log_reader.xls`](fiov2_log_reader.xls) instead.

## Repository Contents

- `falcon_io_fio_v2_for_excel*.sh`, `falcon_io_fio_v2_for_excel_winx64*.ps1`,
  `falcon_io_fio_v3_for_excel.sh` — full I/O test matrix scripts (see table above)
- `fio_stress.sh`, `fio_test.sh`, `fio_test.ps1` — single-pattern / stress-loop scripts
- `FalconStor fiov2 script user guide.doc` / `.md` — full user guide
- `FS Benchmark Standard-1 READ WRITE Record-1.05_fiov2.xls` — Excel template for full-sweep CSV results
- `fiov2_log_reader.xls` — Excel template for `fio_test.*` single-pattern results
- `fio_wininfo.txt` — Windows environment notes

## References

- fio project source: https://github.com/axboe/fio
- Windows fio builds: http://www.bluestop.org/fio/
