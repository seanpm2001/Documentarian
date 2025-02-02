# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

using module ../Classes/ValeMetricsInfo.psm1

#region    RequiredFunctions

$SourceFolder = $PSScriptRoot
while ('Source' -ne (Split-Path -Leaf $SourceFolder)) {
  $SourceFolder = Split-Path -Parent -Path $SourceFolder
}
$RequiredFunctions = @(
  Resolve-Path -Path "$SourceFolder/Public/Functions/Invoke-Vale.ps1"
)
foreach ($RequiredFunction in $RequiredFunctions) {
  . $RequiredFunction
}

#endregion RequiredFunctions

function Get-ProseMetric {
  [CmdletBinding()]
  [OutputType([ValeMetricsInfo])]
  param(
    [string[]]$Path
  )

  begin {
    $MetricsParameters = @(
      'ls-metrics'
      '--output', 'JSON'
    )
  }

  process {
    $DocumentList = @()
    foreach ($Item in Get-Item $Path) {
      if ($Item -is [System.IO.DirectoryInfo]) {
        $DocumentList += Get-ChildItem -Path $Item.FullName -Recurse -File -Include '*.md'
        | Select-Object -ExpandProperty FullName
      } else {
        $DocumentList += $Item.FullName
      }
    }

    foreach ($Document in $DocumentList) {
      $Info = Invoke-Vale -ArgumentList ($MetricsParameters + $Document)
      [ValeMetricsInfo]::new($Info, $Document)
    }
  }
}
