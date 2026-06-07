<#
.SYNOPSIS
    Computes a monotonic, collision-proof build number shared by ALL platforms.

.DESCRIPTION
    The build number is the whole number of minutes elapsed since
    2020-01-01T00:00:00Z (UTC). Because it is derived from wall-clock time it:

      * Always strictly increases  -> a build number can never be reused.
      * Is identical on Android and iOS when computed in the same minute
        -> the two stores stay in sync instead of drifting apart.
      * Stays far below Android's versionCode ceiling (2,100,000,000) for
        thousands of years, while already being far above any legacy
        manually-assigned number (the old 44..61 range).

    Pass -MinFloor to guarantee the result is strictly greater than a known
    previous build number (e.g. the value currently in pubspec.yaml), which
    protects against two builds landing in the very same minute.

.EXAMPLE
    pwsh scripts/build_number.ps1
    # -> 3380123

.EXAMPLE
    pwsh scripts/build_number.ps1 -MinFloor 3380123
    # -> at least 3380124
#>
param(
    [int64]$MinFloor = 0
)

$epoch2020 = [datetimeoffset]::FromUnixTimeSeconds(1577836800) # 2020-01-01T00:00:00Z
$now = [datetimeoffset]::UtcNow
$minutes = [int64][math]::Floor(($now - $epoch2020).TotalMinutes)

if ($minutes -le $MinFloor) {
    $minutes = $MinFloor + 1
}

Write-Output $minutes
