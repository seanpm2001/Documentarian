# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

using module ../../Classes/SourceFolder.psm1

#region    RequiredFunctions

$SourceFolder = $PSScriptRoot
while ('Source' -ne (Split-Path -Leaf $SourceFolder)) {
  $SourceFolder = Split-Path -Parent -Path $SourceFolder
}
$RequiredFunctions = @(
  Resolve-Path -Path "$SourceFolder/Private/Functions/New-SourceFolder.ps1"
)
foreach ($RequiredFunction in $RequiredFunctions) {
  . $RequiredFunction
}

#endregion RequiredFunctions

function Get-SourceFolder {
  [CmdletBinding(DefaultParameterSetName = 'ByPreset')]
  [OutputType([SourceFolder])]
  param(
    [Parameter(Mandatory, ParameterSetName = 'ByOption')]
    [Parameter(ParameterSetName = 'WithSpecificFolders')]
    [ValidateSet('Classes', 'Enums', 'Formats', 'Functions', 'Tasks', 'Types')]
    [string[]]$Category,

    [Parameter(Mandatory, ParameterSetName = 'ByOption')]
    [Parameter(ParameterSetName = 'WithSpecificFolders')]
    [ValidateSet('Public', 'Private')]
    [string[]]$Scope,

    [Parameter(ParameterSetName = 'ByPreset')]
    [Parameter(ParameterSetName = 'WithSpecificFolders')]
    [ValidateSet('Ordered', 'Functions', 'PS1Xmls', 'Tasks', 'All')]
    [string]$Preset = 'All',

    [Parameter(ParameterSetName = 'ByPreset')]
    [Parameter(Mandatory, ParameterSetName = 'ByOption')]
    [Parameter(ParameterSetName = 'WithSpecificFolders')]
    [string]$PublicFolder,

    [Parameter(ParameterSetName = 'ByPreset')]
    [Parameter(Mandatory, ParameterSetName = 'ByOption')]
    [Parameter(ParameterSetName = 'WithSpecificFolders')]
    [string]$PrivateFolder,

    [Parameter(ParameterSetName = 'ByPreset')]
    [Parameter(Mandatory, ParameterSetName = 'ByOption')]
    [Parameter(ParameterSetName = 'WithSourceFolder')]
    [string]$SourceFolder
  )

  process {
    $Category ??= @('Classes', 'Enums', 'Formats', 'Functions', 'Tasks', 'Types')
    $CategoryPattern = "\b$($Category -join '|')\b"
    if ($SourceFolder) {
      $PublicFolder = Join-Path -Path $SourceFolder -ChildPath 'Public'
      | Resolve-Path -ErrorAction Stop

      $PrivateFolder = Join-Path -Path $SourceFolder -ChildPath 'Private'
      | Resolve-Path -ErrorAction Stop
    } else {
      $PublicFolder = $PublicFolder ? $PublicFolder : './Source/Public'
      | Resolve-Path -ErrorAction Stop

      $PrivateFolder = $PrivateFolder ? $PrivateFolder : './Source/Private'
      | Resolve-Path -ErrorAction Stop
    }

    $FolderPaths = switch ($Preset) {
      'Ordered' {
        @(
          Join-Path -Path $PrivateFolder -ChildPath Enums
          Join-Path -Path $PublicFolder -ChildPath Enums
          Join-Path -Path $PrivateFolder -ChildPath Classes
          Join-Path -Path $PublicFolder -ChildPath Classes
        )
      }

      'Functions' {
        @(
          Join-Path -Path $PrivateFolder -ChildPath Functions
          Join-Path -Path $PublicFolder -ChildPath Functions
        )
      }

      'PS1Xmls' {
        @(
          Join-Path -Path $PublicFolder -ChildPath Formats
          Join-Path -Path $PublicFolder -ChildPath Types
        )
      }

      'Tasks' {
        @(
          Join-Path -Path $PublicFolder -ChildPath Tasks
        )
      }

      'All' {
        @(
          Join-Path -Path $PrivateFolder -ChildPath Enums
          Join-Path -Path $PublicFolder -ChildPath Enums
          Join-Path -Path $PrivateFolder -ChildPath Classes
          Join-Path -Path $PublicFolder -ChildPath Classes
          Join-Path -Path $PrivateFolder -ChildPath Functions
          Join-Path -Path $PublicFolder -ChildPath Functions
          Join-Path -Path $PublicFolder -ChildPath Formats
          Join-Path -Path $PublicFolder -ChildPath Tasks
          Join-Path -Path $PublicFolder -ChildPath Types
        )
      }

      default {
        switch ($Scope) {
          'Public' {
            @(
              Join-Path -Path $PublicFolder -ChildPath $Category
            )
          }
          'Private' {
            @(
              Join-Path -Path $PrivateFolder -ChildPath $Category
            )
          }
        }
      }
    }
    $FolderPaths
    | Where-Object -FilterScript { $_ -match $CategoryPattern }
    | ForEach-Object -Process {
      if (Test-Path -Path $_) {
        New-SourceFolder -Path $_
      }
    }
  }
}
